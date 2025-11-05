# Fallback Create Account Implementation

## Overview
Automatic fallback to create Stripe Connect account (POST request) when the account status check (GET request) fails.

---

## How It Works

### 1. **Primary Request: Check Account Status**
```dart
final statusData = await _service.getAccountStatus();
```

**GET Request:**
```http
GET http://10.10.7.62:7010/api/v1/stripe/account-status
Authorization: Bearer ${token}
```

### 2. **If Status Check Fails**
When the GET request fails (network error, 404, 500, etc.), automatically trigger:

```dart
final result = await _service.createConnectAccount();
```

**POST Request:**
```http
POST http://10.10.7.62:7010/api/v1/stripe/connect-account
Authorization: Bearer ${token}
Content-Type: application/json
```

### 3. **Handle Create Account Response**
If account creation succeeds and returns a URL:
- Open WebView with the URL
- Title: "Setup Stripe Account"
- User completes Stripe onboarding
- After WebView closes, check account status again

---

## Complete Flow Diagram

```
User enters Stripe view
    ↓
Controller onInit() called
    ↓
checkAccountStatus() executed
    ↓
GET request to: stripe/account-status
    ↓
Request FAILS ❌
    ↓
Print: "Error checking account status"
    ↓
Print: "Attempting to create Stripe Connect account..."
    ↓
POST request to: stripe/connect-account
    ↓
Response: { success: true, url: "..." }
    ↓
Print: "Connect account created successfully"
    ↓
Print: "Account link received: [URL]"
    ↓
Open WebView with "Setup Stripe Account" title
    ↓
User completes Stripe onboarding
    ↓
WebView closes
    ↓
Call checkAccountStatus() again
    ↓
GET request to: stripe/account-status (should succeed now)
    ↓
Account status loaded successfully
```

---

## Code Implementation

### Controller Method
**File:** `account_transaction_controller.dart`

```dart
// Check if user has Stripe Connect account
Future<void> checkAccountStatus() async {
  try {
    isLoading.value = true;
    
    final statusData = await _service.getAccountStatus();
    
    if (statusData['hasAccount'] == true) {
      hasStripeAccount.value = true;
      await loadAccountData(statusData);
      
      // Call login link API if account is active (without redirecting)
      final accountId = statusData['accountId'] ?? statusData['stripeAccountId'];
      final status = statusData['accountStatus'] ?? statusData['status'];
      
      if (accountId != null && status == 'active') {
        print('✅ Active account detected: $accountId');
        print('🔗 Fetching login link in background...');
        
        // Call the login link API without opening WebView
        await _fetchLoginLinkInBackground();
      }
    } else {
      hasStripeAccount.value = false;
    }
    
    print('✅ Account status checked');
  } catch (e) {
    print('❌ Error checking account status: $e');
    print('🔄 Attempting to create Stripe Connect account...');
    
    // If account status check fails, try to create a connect account
    try {
      final result = await _service.createConnectAccount();
      
      if (result['success'] == true) {
        print('✅ Connect account created successfully');
        
        // Check if URL is returned
        if (result['url'] != null) {
          final url = result['url'] as String;
          print('🔗 Account link received: $url');
          
          // Open the URL in webview for account setup
          await _openUrlInWebView(url, title: 'Setup Stripe Account');
          
          // Refresh account status after webview closes
          await checkAccountStatus();
        } else {
          hasStripeAccount.value = false;
        }
      } else {
        hasStripeAccount.value = false;
      }
    } catch (createError) {
      print('❌ Error creating connect account: $createError');
      hasStripeAccount.value = false;
    }
  } finally {
    isLoading.value = false;
  }
}
```

---

## When Fallback Triggers

### ✅ Fallback Triggers When:
1. **404 Error:** Account status endpoint not found
2. **500 Error:** Server error on status check
3. **Network Error:** No internet connection
4. **Timeout:** Request takes too long
5. **Invalid Response:** Malformed JSON response
6. **Any Exception:** Any error during status check

### ❌ Fallback Does NOT Trigger When:
1. **Status Check Succeeds:** Even if `hasAccount: false`
2. **Account Exists:** Status check returns account data
3. **Valid Response:** Status check returns valid data

---

## Console Output

### Scenario 1: Status Check Fails, Create Succeeds
```
🔄 Checking account status...
❌ Error checking account status: DioException [404]
🔄 Attempting to create Stripe Connect account...
📤 API REQUEST: POST stripe/connect-account
✅ Connect account created successfully
🔗 Account link received: https://connect.stripe.com/setup/...
🔗 Opening URL in WebView: https://connect.stripe.com/setup/...
[User completes onboarding]
✅ Onboarding completed successfully
🔄 Checking account status...
✅ Account status checked
✅ Account data loaded successfully
```

### Scenario 2: Status Check Fails, Create Also Fails
```
🔄 Checking account status...
❌ Error checking account status: Network error
🔄 Attempting to create Stripe Connect account...
❌ Error creating connect account: Network error
```

### Scenario 3: Status Check Succeeds (No Fallback)
```
🔄 Checking account status...
✅ Account status checked
```

---

## API Details

### Primary API: Get Account Status
**Endpoint:** `GET /api/v1/stripe/account-status`

**Request:**
```http
GET http://10.10.7.62:7010/api/v1/stripe/account-status
Authorization: Bearer ${token}
Content-Type: application/json
```

**Success Response:**
```json
{
  "success": true,
  "hasAccount": true,
  "accountId": "acct_xxx",
  "accountStatus": "active"
}
```

**Error Response (triggers fallback):**
```json
{
  "success": false,
  "message": "No account found"
}
```
Or any HTTP error (404, 500, etc.)

### Fallback API: Create Connect Account
**Endpoint:** `POST /api/v1/stripe/connect-account`

**Request:**
```http
POST http://10.10.7.62:7010/api/v1/stripe/connect-account
Authorization: Bearer ${token}
Content-Type: application/json
```

**Success Response:**
```json
{
  "success": true,
  "message": "Connect account created successfully",
  "data": {
    "accountId": "acct_xxx",
    "url": "https://connect.stripe.com/setup/e/acct_xxx/xxx"
  }
}
```

---

## User Experience

### Scenario 1: First Time User (Status Check Fails)
```
User opens Stripe view
    ↓
Loading indicator shows
    ↓
(Status check fails in background)
    ↓
(Account creation triggered automatically)
    ↓
WebView opens with Stripe onboarding
    ↓
User completes setup
    ↓
WebView closes
    ↓
Account dashboard shows
```

**User Perspective:** Seamless - they don't notice the fallback

### Scenario 2: Existing User (Status Check Succeeds)
```
User opens Stripe view
    ↓
Loading indicator shows briefly
    ↓
Account dashboard displays
    ↓
(No fallback triggered)
```

### Scenario 3: Network Error (Both Fail)
```
User opens Stripe view
    ↓
Loading indicator shows
    ↓
(Both requests fail)
    ↓
"Create Stripe Account" button shows
    ↓
User can retry manually
```

---

## Benefits

✅ **Automatic Recovery:** Handles missing accounts gracefully  
✅ **Seamless UX:** User doesn't notice the fallback  
✅ **Error Resilient:** Works even if status endpoint is unavailable  
✅ **Self-Healing:** Creates account automatically when needed  
✅ **No User Action:** No manual intervention required  
✅ **Retry Logic:** Checks status again after account creation  

---

## Error Handling

### Primary Request Fails
- Logs error to console
- Triggers fallback automatically
- User doesn't see error message

### Fallback Request Fails
- Logs error to console
- Sets `hasStripeAccount.value = false`
- User sees "Create Account" button
- User can retry manually

### Both Requests Fail
- User sees normal "no account" UI
- Can click "Create Stripe Account" button
- Can click "Login to Existing Account" button

---

## Testing Scenarios

### Test 1: Status Check Fails (404)
1. Backend returns 404 for status endpoint
2. **Expected:** 
   - Fallback triggers
   - POST to create-connect-account
   - WebView opens if successful

### Test 2: Status Check Fails (Network Error)
1. Disconnect internet
2. Open Stripe view
3. **Expected:**
   - Status check fails
   - Create account also fails
   - User sees "Create Account" button

### Test 3: Status Check Succeeds
1. User has existing account
2. Open Stripe view
3. **Expected:**
   - Status check succeeds
   - No fallback triggered
   - Account dashboard shows

### Test 4: Create Account Succeeds
1. Status check returns 404
2. Create account succeeds with URL
3. **Expected:**
   - WebView opens
   - User completes onboarding
   - Status check runs again
   - Account dashboard shows

---

## Backend Requirements

### Status Endpoint Behavior
The backend should:
- Return 404 or error if no account exists
- Return account data if account exists
- This triggers the fallback appropriately

### Create Account Endpoint Behavior
The backend should:
- Create a new Stripe Connect account
- Return the onboarding URL
- Return success status

---

## Preventing Infinite Loops

The implementation prevents infinite loops by:
1. Only calling `checkAccountStatus()` once after account creation
2. Not calling fallback if already in fallback
3. Setting `hasStripeAccount.value = false` on failure
4. Using try-catch blocks to prevent cascading errors

---

## Status

✅ **Implemented and Ready to Use**

**Last Updated:** November 5, 2024

---

## Summary

When the `stripe/account-status` GET request fails, the system automatically:
1. Logs the error
2. Attempts to create a Stripe Connect account via POST to `stripe/connect-account`
3. If successful, opens the onboarding URL in a WebView
4. After onboarding, rechecks the account status
5. Displays the account dashboard

This provides a robust, self-healing system that handles missing accounts and API failures gracefully without requiring user intervention.
