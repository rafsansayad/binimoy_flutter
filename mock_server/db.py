# Mock database for Binimoy API
from datetime import datetime, timedelta
import uuid

# Create users first
alice_id = str(uuid.uuid4())
bob_id = str(uuid.uuid4())

# In-memory database matching SRS schema
db = {
    "users": [
        {
            "userId": alice_id,
            "firstName": "Alice",
            "lastName": "Rahman", 
            "userName": "alice_r",
            "phone": "8801711111111",
            "pin": "1234",
            "isPhoneVerified": True,
            "isKycVerified": True,
            "createdAt": datetime.now().isoformat(),
            "updatedAt": datetime.now().isoformat()
        },
        {
            "userId": bob_id,
            "firstName": "Bob",
            "lastName": "Khan",
            "userName": "bob_k", 
            "phone": "8801722222222",
            "pin": "5678",
            "isPhoneVerified": True,
            "isKycVerified": False,
            "createdAt": datetime.now().isoformat(),
            "updatedAt": datetime.now().isoformat()
        }
    ],
    "kyc": [
        {
            "userId": alice_id,
            "nidFrontPic": "https://example.com/nid_front_1.jpg",
            "nidBackPic": "https://example.com/nid_back_1.jpg",
            "selfie": "https://example.com/selfie_1.jpg",
            "submittedAt": datetime.now().isoformat(),
            "status": "verified"
        }
    ],
    "access_tokens": [
        {
            "atId": 1,
            "userId": alice_id,
            "accessToken": "access_token_123",
            "createdAt": datetime.now().isoformat(),
            "expiresAt": (datetime.now() + timedelta(hours=1)).isoformat(),
            "lastUsedAt": datetime.now().isoformat(),
            "isValid": True
        }
    ],
    "refresh_tokens": [
        {
            "rtId": 1,
            "userId": alice_id,
            "refreshToken": "refresh_token_123",
            "createdAt": datetime.now().isoformat(),
            "expiresAt": (datetime.now() + timedelta(days=30)).isoformat(),
            "lastUsedAt": datetime.now().isoformat(),
            "isValid": True
        }
    ],
    "otp": [
        {
            "otpId": 1,
            "phone": "8801711111111",
            "otp": "123456",
            "createdAt": datetime.now().isoformat(),
            "expiresAt": (datetime.now() + timedelta(minutes=5)).isoformat(),
            "verifiedAt": None
        }
    ]
}

def get_user_by_phone(phone):
    return next((user for user in db["users"] if user["phone"] == phone), None)

def get_user_by_id(user_id):
    return next((user for user in db["users"] if user["userId"] == user_id), None)

def get_user_by_username(username):
    return next((user for user in db["users"] if user["userName"] == username), None)