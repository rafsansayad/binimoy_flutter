from flask import Flask, jsonify, request
from flask_cors import CORS
from datetime import datetime, timedelta
import uuid
from db import db, get_user_by_phone, get_user_by_id, get_user_by_username

app = Flask(__name__)
CORS(app)



# ================= AUTH =================

@app.route('/api/v1/auth/register', methods=['POST'])
def register():
    data = request.json
    first_name = data.get('firstName')
    last_name = data.get('lastName')
    username = data.get('userName')
    pin = data.get('pin')
    phone = data.get('phone')
    
    if not all([first_name, last_name, username, pin, phone]):
        return jsonify({"error": "All fields required"}), 400
    
    # Check if OTP was verified recently (session-based)
    latest_verified_otp = None
    for otp_record in db["otp"]:
        if otp_record['phone'] == phone and otp_record['verifiedAt']:
            if latest_verified_otp is None or otp_record['createdAt'] > latest_verified_otp['createdAt']:
                latest_verified_otp = otp_record
    
    if not latest_verified_otp:
        return jsonify({"error": "OTP verification required"}), 403
    
    # Check if verification is still valid (10 minutes)
    verified_time = datetime.fromisoformat(latest_verified_otp['verifiedAt'])
    if verified_time < datetime.now() - timedelta(minutes=10):
        return jsonify({"error": "OTP verification expired"}), 403
    
    if get_user_by_phone(phone):
        return jsonify({"error": "Phone already registered"}), 409
    
    if get_user_by_username(username):
        return jsonify({"error": "Username taken"}), 409
    
    user = {
        "userId": str(uuid.uuid4()),
        "firstName": first_name,
        "lastName": last_name,
        "userName": username,
        "phone": phone,
        "pin": pin,
        "isPhoneVerified": True,
        "isKycVerified": False,
    }
    db["users"].append(user)
    
    # Generate tokens
    access_token = f"at_{user['userId']}_{datetime.now().timestamp()}"
    refresh_token = f"rt_{user['userId']}_{datetime.now().timestamp()}"
    
    db["access_tokens"].append({
        "at_id": len(db["access_tokens"]) + 1,
        "user_id": user["userId"],
        "access_token": access_token,
        "created_at": datetime.now().isoformat(),
        "expires_at": (datetime.now() + timedelta(hours=1)).isoformat(),
        "is_valid": True
    })
    
    db["refresh_tokens"].append({
        "rt_id": len(db["refresh_tokens"]) + 1,
        "user_id": user["userId"],
        "refresh_token": refresh_token,
        "created_at": datetime.now().isoformat(),
        "expires_at": (datetime.now() + timedelta(days=30)).isoformat(),
        "is_valid": True
    })
    
    safe_user = {
        "userId": user["userId"],
        "firstName": user["firstName"],
        "lastName": user["lastName"],
        "userName": user["userName"],
        "phone": user["phone"],
        "isPhoneVerified": user["isPhoneVerified"],
        "isKycVerified": user["isKycVerified"],
    }
    return jsonify({
        "user": safe_user,
        "accessToken": access_token,
        "refreshToken": refresh_token
    })

@app.route('/api/v1/auth/login', methods=['POST'])
def login():
    data = request.json
    phone = data.get('phone')
    pin = data.get('pin')
    
    if not all([phone, pin]):
        return jsonify({"error": "Phone and PIN required"}), 400
    
    # Find latest VERIFIED OTP for this phone
    latest_verified_otp = None
    for otp_record in db["otp"]:
        if otp_record['phone'] == phone and otp_record['verifiedAt']:
            if latest_verified_otp is None or otp_record['createdAt'] > latest_verified_otp['createdAt']:
                latest_verified_otp = otp_record
    
    # Check if OTP was verified recently
    if not latest_verified_otp:
        return jsonify({"error": "OTP verification required"}), 403
    
    # Check if verification is still valid (10 minutes)
    verified_time = datetime.fromisoformat(latest_verified_otp['verifiedAt'])
    if verified_time < datetime.now() - timedelta(minutes=10):
        return jsonify({"error": "OTP verification expired"}), 403
    
    # Verify PIN and get user
    user = get_user_by_phone(phone)
    if not user or user["pin"] != pin:
        return jsonify({"error": "Invalid PIN"}), 403
    
    # Generate new access token
    access_token = f"at_{user['userId']}_{datetime.now().timestamp()}"
    refresh_token = f"rt_{user['userId']}_{datetime.now().timestamp()}"
    
    db["access_tokens"].append({
        "at_id": len(db["access_tokens"]) + 1,
        "user_id": user["userId"],
        "access_token": access_token,
        "created_at": datetime.now().isoformat(),
        "expires_at": (datetime.now() + timedelta(hours=1)).isoformat(),
        "is_valid": True
    })
    
    db["refresh_tokens"].append({
        "rt_id": len(db["refresh_tokens"]) + 1,
        "user_id": user["userId"],
        "refresh_token": refresh_token,
        "created_at": datetime.now().isoformat(),
        "expires_at": (datetime.now() + timedelta(days=30)).isoformat(),
        "is_valid": True
    })
    
    # Create safe user object (without PIN)
    safe_user = {
        "userId": user["userId"],
        "firstName": user["firstName"],
        "lastName": user["lastName"],
        "userName": user["userName"],
        "phone": user["phone"],
        "isPhoneVerified": user["isPhoneVerified"],
        "isKycVerified": user["isKycVerified"],
    }
    
    return jsonify({
        "user": safe_user,
        "accessToken": access_token,
        "refreshToken": refresh_token
    })

@app.route('/api/v1/auth/get-otp', methods=['POST'])
def get_otp():
    phone = request.json.get('phone')
    if not phone:
        return jsonify({"success": False, "error": "Phone required"}), 400
    
    otp_record = {
        "otpId": len(db["otp"]) + 1,
        "phone": phone,
        "otp": "123456",
        "createdAt": datetime.now().isoformat(),
        "expiresAt": (datetime.now() + timedelta(minutes=5)).isoformat(),
        "verifiedAt": None
    }
    db["otp"].append(otp_record)
    
    return jsonify("OTP sent")

@app.route('/api/v1/auth/verify-otp', methods=['POST'])
def verify_otp():
    data = request.json
    phone = data.get('phone')
    otp = data.get('otp')
    
    if not all([phone, otp]):
        return jsonify({"success": False, "error": "Phone and OTP required"}), 400
    
    otp_record = next((o for o in db["otp"] if o["phone"] == phone and o["otp"] == otp), None)
    if not otp_record:
        return jsonify({"success": False, "error": "Invalid OTP"}), 400
    
    # Check if OTP is expired
    if datetime.fromisoformat(otp_record['expiresAt']) < datetime.now():
        return jsonify({"success": False, "error": "OTP expired"}), 400
    
    # Mark OTP as verified
    otp_record['verifiedAt'] = datetime.now().isoformat()
    
    return jsonify("OTP verification succesfull")

@app.route('/api/v1/auth/logout', methods=['POST'])
def logout():
    data = request.json
    refresh_token = data.get('refreshToken')
    access_token = data.get('accessToken')
    
    # Mark tokens as invalid
    for token in db["refresh_tokens"]:
        if token["refresh_token"] == refresh_token:
            token["is_valid"] = False
    
    for token in db["access_tokens"]:
        if token["access_token"] == access_token:
            token["is_valid"] = False
    
    return jsonify("Logged out successfully")

@app.route('/api/v1/auth/refresh-access-token', methods=['POST'])
def refresh_access_token():
    refresh_token = request.json.get('refreshToken')
    if not refresh_token:
        return jsonify({"error": "Refresh token required"}), 400
    
    token_record = next((t for t in db["refresh_tokens"] if t["refresh_token"] == refresh_token and t["is_valid"]), None)
    if not token_record:
        return jsonify({"error": "Invalid refresh token"}), 401
    
    # Generate new tokens
    access_token = f"at_{token_record['user_id']}_{datetime.now().timestamp()}"
    new_refresh_token = f"rt_{token_record['user_id']}_{datetime.now().timestamp()}"
    
    db["access_tokens"].append({
        "at_id": len(db["access_tokens"]) + 1,
        "user_id": token_record["user_id"],
        "access_token": access_token,
        "created_at": datetime.now().isoformat(),
        "expires_at": (datetime.now() + timedelta(hours=1)).isoformat(),
        "is_valid": True
    })
    
    db["refresh_tokens"].append({
        "rt_id": len(db["refresh_tokens"]) + 1,
        "user_id": token_record["user_id"],
        "refresh_token": new_refresh_token,
        "created_at": datetime.now().isoformat(),
        "expires_at": (datetime.now() + timedelta(days=30)).isoformat(),
        "is_valid": True
    })
    
    return jsonify({
        "accessToken": access_token,
        "refreshToken": new_refresh_token
    })

# ================= COMPLIANCE =================

@app.route('/api/v1/compliance/kyc-submit', methods=['POST'])
def kyc_submit():
    data = request.json
    user_id = data.get('userId')
    nid = data.get('nid')
    selfie = data.get('selfie')
    
    if not all([user_id, nid, selfie]):
        return jsonify({"error": "User ID, NID, and selfie required"}), 400
    
    kyc_record = {
        "user_id": user_id,
        "nid_front_pic": nid,
        "nid_back_pic": nid,
        "selfie": selfie,
        "submitted_at": datetime.now().isoformat(),
        "status": "pending"
    }
    db["kyc"].append(kyc_record)
    
    return jsonify("KYC submitted successfully")

@app.route('/api/v1/compliance/kyc-status', methods=['GET'])
def kyc_status():
    user_id = request.args.get('userId')
    if not user_id:
        return jsonify({"error": "User ID required"}), 400
    
    kyc_record = next((k for k in db["kyc"] if k["user_id"] == int(user_id)), None)
    if not kyc_record:
        return jsonify({"status": "not_submitted"})
    
    return jsonify({"status": kyc_record["status"]})

# ================= USER =================

@app.route('/api/v1/user/get-profile', methods=['GET'])
def get_profile():
    user_id = request.args.get('userId')
    if not user_id:
        return jsonify({"error": "User ID required"}), 400
    
    user = get_user_by_id(int(user_id))
    if not user:
        return jsonify({"error": "User not found"}), 404
    
    safe_user = {
        "userId": user["userId"],
        "firstName": user["firstName"],
        "lastName": user["lastName"],
        "userName": user["userName"],
        "phone": user["phone"],
        "isPhoneVerified": user["isPhoneVerified"],
        "isKycVerified": user["isKycVerified"],
    }
    return jsonify(safe_user)

@app.route('/api/v1/user/update-profile', methods=['POST'])
def update_profile():
    data = request.json
    user_id = data.get('userId')
    username = data.get('username')
    
    if not all([user_id, username]):
        return jsonify({"error": "User ID and username required"}), 400
    
    user = get_user_by_id(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404
    
    if get_user_by_username(username) and get_user_by_username(username)["userId"] != user_id:
        return jsonify({"error": "Username already taken"}), 409
    
    user["userName"] = username
    user["updatedAt"] = datetime.now().isoformat()
    
    safe_user = {
        "userId": user["userId"],
        "firstName": user["firstName"],
        "lastName": user["lastName"],
        "userName": user["userName"],
        "phone": user["phone"],
        "isPhoneVerified": user["isPhoneVerified"],
        "isKycVerified": user["isKycVerified"],
    }
    return jsonify(safe_user)

@app.route('/api/v1/user/change-pin', methods=['POST'])
def change_pin():
    data = request.json
    phone = data.get('phone')
    otp = data.get('otp')
    pin = data.get('pin')
    
    if not all([phone, otp, pin]):
        return jsonify({"error": "Phone, OTP, and PIN required"}), 400
    
    # Check OTP
    otp_record = next((o for o in db["otp"] if o["phone"] == phone and o["otp"] == otp), None)
    if not otp_record:
        return jsonify({"error": "Invalid OTP"}), 400
    
    # Check if OTP is expired
    if datetime.fromisoformat(otp_record['expires_at']) < datetime.now():
        return jsonify({"error": "OTP expired"}), 400
    
    user = get_user_by_phone(phone)
    if not user:
        return jsonify({"error": "User not found"}), 404
    
    user["pin"] = pin
    user["updated_at"] = datetime.now().isoformat()
    
    return jsonify("PIN changed successfully")

if __name__ == '__main__':
    app.run(port=3000, debug=True)