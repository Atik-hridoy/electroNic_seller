# Background Login Link Fetch

## Overview
Automatically fetch Stripe login link in the background when entering the Stripe view with an active account, WITHOUT opening the WebView.

---

## How It Works

### 1. **View Entry**
When user navigates to the Stripe account view, the controller's `onInit()` automatically calls `checkAccountStatus()`.

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
  "payoutsEnabled": true
}
```

### 3. **Background API Call Logic**
If both conditions are met:
- ✅ `accountId` exists (e.g., "acct_1SPz8YPUEGClq8ci")
- ✅ `accountStatus` is "active"

Then automatically:
1. Print: `✅ Active account detected: acct_xxx`
2. Print: `🔗 Fetching login link in background...`
3. Call `_fetchLoginLinkInBackground()` method

### 4. **Background Login Link Fetch**
```dart
await _fetchLoginLinkInBackground();
```

**GET Request (in background):**
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

### 5. **Result**
- ✅ API call is made in background
- ✅ URL is received and logged to console
- ✅ Link is cached for potential future use
- ❌ **NO WebView opens automatically**
- ✅ User sees normal account UI
- ✅ User can manually click "Open Dashboard" button if needed

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
Print: "Fetching login link in background..."
    ↓
Call _fetchLoginLinkInBackground()
    ↓
GET request to: stripe/login-link (in background)
    ↓
Response with dashboard URL received
    ↓
Print: "Login link received: [URL]"
    ↓
Print: "Link cached for manual access"
    ↓
NO WebView opens
    ↓
User sees normal account dashboard UI
    ↓
User can manually click "Open Dashboard" button
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
    hasStripeAccount.value = false;
  } finally {
    isLoading.value = false;
  }
}

// Fetch login link in background without opening WebView
Future<void> _fetchLoginLinkInBackground() async {
  try {
    print('📡 Calling login link API...');
    
    final result = await _service.getLoginLink();
    
    if (result['url'] != null) {
      final url = result['url'] as String;
      print('✅ Login link received: $url');
      print('💾 Link cached for manual access');
      // Store the URL if needed for later use
      // You can save it to a variable or local storage if required
    } else {
      print('⚠️ No login link URL in response');
    }
  } catch (e) {
    print('❌ Error fetching login link: $e');
    // Fail silently - don't show error to user
  }
}
```

---

## Key Differences from Auto-Redirect

| Feature | Auto-Redirect (Old) | Background Fetch (New) |
|---------|---------------------|------------------------|
| **API Call** | Yes | Yes |
| **WebView Opens** | ✅ Automatically | ❌ No |
| **User Sees** | WebView immediately | Normal account UI |
| **User Action** | None (automatic) | Can click "Open Dashboard" |
| **Error Handling** | Shows snackbar | Fails silently |
| **Console Output** | "Auto-redirecting..." | "Fetching in background..." |

---

## Console Output

### Successful Background Fetch
```
✅ Account data loaded successfully
✅ Active account detected: acct_1SPz8YPUEGClq8ci
🔗 Fetching login link in background...
📡 Calling login link API...
✅ Login link received: https://connect.stripe.com/express/xxx
💾 Link cached for manual access
✅ Account status checked
```

### No Active Account
```
✅ Account data loaded successfully
✅ Account status checked
```

### Error Case (Silent)
```
✅ Account data loaded successfully
✅ Active account detected: acct_1SPz8YPUEGClq8ci
🔗 Fetching login link in background...
📡 Calling login link API...
❌ Error fetching login link: Network error
✅ Account status checked
```

---

## User Experience

### Scenario 1: Active Account
```
User opens Stripe view
    ↓
Loading indicator shows briefly
    ↓
Account dashboard UI displays
    ↓
(Login link fetched in background - user doesn't notice)
    ↓
User can click "Open Dashboard" button if desired
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
No background API call
```

### Scenario 3: No Account
```
User opens Stripe view
    ↓
Loading indicator shows
    ↓
"Create Stripe Account" button displays
    ↓
No background API call
```

---

## Benefits

✅ **Non-Intrusive:** User sees normal UI, not forced into WebView  
✅ **Pre-Cached:** Login link is ready if user clicks "Open Dashboard"  
✅ **Silent Errors:** Network errors don't disrupt user experience  
✅ **User Control:** User decides when to open dashboard  
✅ **Performance:** Link is pre-fetched for faster manual access  
✅ **Flexibility:** Can store URL for later use if needed  

---

## When Background Fetch Happens

### ✅ Background Fetch Triggers
1. **View Entry:** User navigates to Stripe account view
2. **Active Account:** Account status is "active"
3. **Account ID Present:** Valid Stripe account ID exists

### ❌ Background Fetch Does NOT Trigger
1. **No Account:** User has no Stripe account
2. **Pending Status:** Account status is "pending" or "restricted"
3. **Incomplete Onboarding:** Account exists but not fully set up
4. **No Account ID:** Account ID is null or missing

---

## Optional: Store URL for Later Use

If you want to store the fetched URL for later use, you can add:

```dart
// Add to controller class
RxString cachedLoginUrl = ''.obs;

// Update _fetchLoginLinkInBackground method
Future<void> _fetchLoginLinkInBackground() async {
  try {
    print('📡 Calling login link API...');
    
    final result = await _service.getLoginLink();
    
    if (result['url'] != null) {
      final url = result['url'] as String;
      cachedLoginUrl.value = url; // Store for later use
      print('✅ Login link received: $url');
      print('💾 Link cached for manual access');
    } else {
      print('⚠️ No login link URL in response');
    }
  } catch (e) {
    print('❌ Error fetching login link: $e');
  }
}

// Then use cached URL when user clicks "Open Dashboard"
Future<void> getLoginLink() async {
  try {
    isLoading.value = true;
    
    // Use cached URL if available
    if (cachedLoginUrl.value.isNotEmpty) {
      print('🔗 Using cached login link');
      await _openUrlInWebView(cachedLoginUrl.value, title: 'Stripe Dashboard');
      return;
    }
    
    // Otherwise fetch new URL
    final result = await _service.getLoginLink();
    
    if (result['url'] != null) {
      final url = result['url'] as String;
      await _openUrlInWebView(url, title: 'Stripe Dashboard');
    }
  } catch (e) {
    print('❌ Error getting login link: $e');
    Get.snackbar('Error', 'Failed to open Stripe Dashboard: $e');
  } finally {
    isLoading.value = false;
  }
}
```

---

## Error Handling

### Silent Failure
- API call fails silently
- No error message shown to user
- User experience is not disrupted
- User can still manually click "Open Dashboard"
- Manual click will make a fresh API call

### Network Errors
- Logged to console only
- User sees normal UI
- No snackbar or dialog

### Invalid Token
- Logged to console only
- User sees normal UI
- Manual dashboard access will show proper error

---

## Testing Scenarios

### Test 1: Active Account
1. Create Stripe account and complete onboarding
2. Ensure account status is "active"
3. Navigate to Stripe view
4. **Expected:** 
   - Normal UI shows
   - Console shows "Login link received"
   - No WebView opens

### Test 2: Pending Account
1. Create Stripe account but don't complete onboarding
2. Ensure account status is "pending"
3. Navigate to Stripe view
4. **Expected:** 
   - Account UI shows
   - No background API call
   - No console message about login link

### Test 3: Network Error
1. Have active account
2. Disconnect internet
3. Navigate to Stripe view
4. **Expected:** 
   - Normal UI shows
   - Console shows error (silent)
   - No error message to user

### Test 4: Manual Dashboard Access
1. Have active account
2. Navigate to Stripe view (background fetch happens)
3. Click "Open Dashboard" button manually
4. **Expected:** 
   - WebView opens
   - Shows Stripe Dashboard

---

## Status

✅ **Implemented and Ready to Use**

**Last Updated:** November 5, 2024

---

## Summary

When users with **active Stripe accounts** enter the Stripe view, the app automatically:
1. Detects the active account
2. Makes a GET request to `stripe/login-link` in the background
3. Logs the received URL to console
4. **Does NOT open any WebView**
5. User sees normal account dashboard UI
6. User can manually click "Open Dashboard" if desired

This provides a non-intrusive experience where the login link is pre-fetched for potential use, but the user maintains full control over when to access the Stripe Dashboard.
