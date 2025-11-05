# Auto-Redirect to Stripe Dashboard

## Overview
Automatic redirection to Stripe Dashboard when entering the Stripe view with an active account.

---

## How It Works

### 1. **View Entry**
When user navigates to the Stripe account view, the controller's `onInit()` method automatically calls `checkAccountStatus()`.

### 2. **Account Status Check**
```dart
final statusData = await _service.getAccountStatus();
```

**GET Request:**
```http
GET http://10.10.7.62:7010/api/v1/stripe/account-status
Authorization: Bearer ${token}
```

**Expected Response:**
```json
{
  "success": true,
  "hasAccount": true,
  "accountId": "acct_1SPz8YPUEGClq8ci",
  "accountStatus": "active",
  "chargesEnabled": true,
  "payoutsEnabled": true,
  "detailsSubmitted": true
}
```

### 3. **Auto-Redirect Logic**
If both conditions are met:
- ✅ `accountId` exists (e.g., "acct_1SPz8YPUEGClq8ci")
- ✅ `accountStatus` is "active"

Then automatically:
1. Print confirmation: `✅ Active account detected: acct_xxx`
2. Print redirect message: `🔗 Auto-redirecting to Stripe Dashboard...`
3. Call `getLoginLink()` method

### 4. **Get Login Link**
```dart
final result = await _service.getLoginLink();
```

**GET Request:**
```http
GET http://10.10.7.62:7010/api/v1/stripe/login-link
Authorization: Bearer ${token}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Login link generated successfully",
  "data": {
    "url": "https://connect.stripe.com/express/xxx"
  }
}
```

### 5. **WebView Opens**
- **Title:** "Stripe Dashboard"
- **URL:** Stripe Express Dashboard
- **User:** Can view and manage their Stripe account

---

## Complete Flow Diagram

```
User navigates to Stripe view
    ↓
Controller onInit() called
    ↓
checkAccountStatus() executed
    ↓
GET request to: stripe/account-status
    ↓
Response received with account data
    ↓
Check: accountId exists? ──No──> Show account UI
    ↓ Yes
Check: accountStatus == 'active'? ──No──> Show account UI
    ↓ Yes
Print: "Active account detected"
    ↓
Print: "Auto-redirecting to Stripe Dashboard..."
    ↓
Call getLoginLink()
    ↓
GET request to: stripe/login-link
    ↓
Response with dashboard URL received
    ↓
Open WebView with title "Stripe Dashboard"
    ↓
User views Stripe Dashboard
    ↓
User closes WebView
    ↓
Return to app
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
      
      // Auto-redirect to login link if account is active
      final accountId = statusData['accountId'] ?? statusData['stripeAccountId'];
      final status = statusData['accountStatus'] ?? statusData['status'];
      
      if (accountId != null && status == 'active') {
        print('✅ Active account detected: $accountId');
        print('🔗 Auto-redirecting to Stripe Dashboard...');
        
        // Automatically open login link for active accounts
        await getLoginLink();
      }
    } else {
      hasStripeAccount.value = false;
    }
    
    print('✅ Account status checked');
  } catch (e) {
    print('❌ Error checking account status: $e');
    hasStripeAccount.value = false;
  } finally {
    isLoading.value = false;
  }
}
```

### Service Method
**File:** `get_account_transaction_service.dart`

```dart
// Get login link to Stripe Dashboard
Future<Map<String, dynamic>> getLoginLink() async {
  try {
    await LocalStorage.getAllPrefData();
    
    if (LocalStorage.token.isEmpty) {
      throw Exception('No access token found');
    }

    final url = '${AppUrls.baseUrl}${AppUrls.getLoginLink}';
    final headers = {
      'Authorization': 'Bearer ${LocalStorage.token}',
      'Content-Type': 'application/json',
    };

    final response = await _dio.get(
      url,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      
      if (data is Map && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      } else if (data is Map<String, dynamic>) {
        return data;
      }
      
      return {};
    } else {
      throw Exception('Failed to get login link: ${response.statusMessage}');
    }
  } catch (e) {
    throw Exception('Failed to get login link: $e');
  }
}
```

---

## When Auto-Redirect Happens

### ✅ Auto-Redirect Triggers
1. **View Entry:** User navigates to Stripe account view
2. **Active Account:** Account status is "active"
3. **Account ID Present:** Valid Stripe account ID exists

### ❌ Auto-Redirect Does NOT Trigger
1. **No Account:** User has no Stripe account
2. **Pending Status:** Account status is "pending" or "restricted"
3. **Incomplete Onboarding:** Account exists but not fully set up
4. **No Account ID:** Account ID is null or missing

---

## User Experience

### Scenario 1: Active Account
```
User opens Stripe view
    ↓
Loading indicator shows briefly
    ↓
WebView opens automatically (Stripe Dashboard)
    ↓
User sees their Stripe account dashboard
```

### Scenario 2: Pending Account
```
User opens Stripe view
    ↓
Loading indicator shows
    ↓
Account dashboard UI displays
    ↓
Shows "Complete Your Setup" message
    ↓
User can click "Continue Onboarding" button
```

### Scenario 3: No Account
```
User opens Stripe view
    ↓
Loading indicator shows
    ↓
"Create Stripe Account" button displays
    ↓
User can click to start account creation
```

---

## Console Output

### Successful Auto-Redirect
```
✅ Account data loaded successfully
✅ Active account detected: acct_1SPz8YPUEGClq8ci
🔗 Auto-redirecting to Stripe Dashboard...
✅ Account status checked
🔗 Opening URL in WebView: https://connect.stripe.com/express/xxx
```

### No Auto-Redirect (Pending Account)
```
✅ Account data loaded successfully
✅ Account status checked
```

### Error Case
```
❌ Error checking account status: Network error
```

---

## Backend Requirements

### Account Status Endpoint
**Endpoint:** `GET /api/v1/stripe/account-status`

**Must Return:**
```json
{
  "success": true,
  "hasAccount": true,
  "accountId": "acct_xxx",           // Required for auto-redirect
  "accountStatus": "active",         // Must be "active" for auto-redirect
  "chargesEnabled": true,
  "payoutsEnabled": true,
  "detailsSubmitted": true
}
```

### Login Link Endpoint
**Endpoint:** `GET /api/v1/stripe/login-link`

**Must Return:**
```json
{
  "success": true,
  "message": "Login link generated successfully",
  "data": {
    "url": "https://connect.stripe.com/express/xxx"  // Dashboard URL
  }
}
```

---

## Error Handling

### Network Errors
- Auto-redirect fails silently
- User sees normal account UI
- Can manually click "Open Dashboard" button

### Invalid Token
- Error logged to console
- User sees error message
- No auto-redirect occurs

### Missing URL in Response
- Error logged to console
- User sees error snackbar
- Can retry manually

---

## Benefits

✅ **Seamless UX:** Users with active accounts go directly to dashboard  
✅ **Time Saving:** No need to click "Open Dashboard" button  
✅ **Smart Detection:** Only redirects when appropriate  
✅ **Fallback Available:** Manual button still works if auto-redirect fails  
✅ **Non-Intrusive:** Doesn't affect users without active accounts  

---

## Disabling Auto-Redirect

If you want to disable auto-redirect, simply comment out or remove these lines:

```dart
// Comment out this block to disable auto-redirect
if (accountId != null && status == 'active') {
  print('✅ Active account detected: $accountId');
  print('🔗 Auto-redirecting to Stripe Dashboard...');
  await getLoginLink();
}
```

---

## Testing Scenarios

### Test 1: Active Account
1. Create Stripe account and complete onboarding
2. Ensure account status is "active"
3. Navigate to Stripe view
4. **Expected:** WebView opens automatically with dashboard

### Test 2: Pending Account
1. Create Stripe account but don't complete onboarding
2. Ensure account status is "pending"
3. Navigate to Stripe view
4. **Expected:** Account UI shows, no auto-redirect

### Test 3: No Account
1. Ensure user has no Stripe account
2. Navigate to Stripe view
3. **Expected:** "Create Account" button shows, no auto-redirect

### Test 4: Network Error
1. Disconnect internet
2. Navigate to Stripe view
3. **Expected:** Error message, no crash

### Test 5: Manual Button
1. Have active account
2. Close auto-opened WebView
3. Click "Open Dashboard" button manually
4. **Expected:** WebView opens again

---

## Status

✅ **Implemented and Ready to Use**

**Last Updated:** November 5, 2024

---

## Summary

When users with **active Stripe accounts** (with valid `accountId` and `accountStatus: "active"`) enter the Stripe view, the app automatically:
1. Detects the active account
2. Makes a GET request to `stripe/login-link`
3. Opens the Stripe Dashboard in a WebView

This provides a seamless experience for users who want to access their Stripe dashboard directly.
