# Binimoy - A Venmo Clone

Binimoy is a mobile-first, student-focused social peer-to-peer (P2P) payments and budgeting application designed for the Bangladesh market. It integrates with existing Mobile Financial Services (MFS) like bKash and Nagad to provide a seamless financial experience.

## Features

- **OTP-based User Authentication**: Secure login using phone number and OTP.
- **P2P Money Transfer**: Send money to friends with an attached memo.
- **Secure MFS Integration**: Connect with bKash and Nagad wallets.
- **Social Feed**: View friends' public transaction activities.
- **Bill Splitting**: Split bills with friends and track payments.
- **External Payment Links**: Request money from non-users via shareable links.
- **Personal Budgeting**: Plan budgets, track expenses, and receive spending alerts.


## Usage

- **Onboarding**: Register using your phone number and complete KYC to unlock all features.
- **Send Money**: Tap "Send" to transfer money to friends or merchants.
- **Request Money**: Use "Request" to generate payment links for non-users.
- **Bill Management**: Create and manage bills with friends.

## API Documentation

- **Authentication**: `/api/v1/auth/register`, `/api/v1/auth/login`, `/api/v1/auth/get-otp`
- **Compliance**: `/api/v1/compliance/kyc-submit`, `/api/v1/compliance/kyc-status`
- **User Management**: `/api/v1/user/get-profile`, `/api/v1/user/update-profile`
- **Payments**: `/pay`, `/bills`, `/feed`

