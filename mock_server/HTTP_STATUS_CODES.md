# HTTP Status Codes

## Authentication & Authorization

### 200 - OK
- **Login successful** - Returns user data + tokens
- **Registration successful** - Returns user data + tokens
- **OTP sent** - Returns success message
- **OTP verified** - Returns success message
- **Token refresh successful** - Returns new tokens
- **Logout successful** - Returns success message

### 400 - Bad Request
- **Missing required fields** - Phone, PIN, OTP, etc.
- **Invalid OTP** - Wrong OTP code
- **OTP expired** - OTP verification time exceeded
- **Missing refresh token** - Required for token refresh

### 401 - Unauthorized
- **Invalid access token** - Token doesn't exist or expired
- **Missing access token** - No Authorization header
- **Invalid refresh token** - Refresh token doesn't exist or expired

### 403 - Forbidden
- **Invalid PIN** - Wrong PIN during login
- **OTP verification required** - Must verify OTP before login/register

### 404 - Not Found
- **User not found** - User ID doesn't exist

- **Phone already registered** - User with phone exists
- **Username taken** - Username already in use

## Response Format

### Success (200)
```json
// Simple string
"OTP sent"

// Complex object
{
  "user": {...},
  "accessToken": "...",
  "refreshToken": "..."
}
```

### Error (4xx)
```json
{
  "error": "Error message"
}
``` 