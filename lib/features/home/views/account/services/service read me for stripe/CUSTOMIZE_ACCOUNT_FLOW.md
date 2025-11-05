# Customize Stripe Account Implementation

## Overview
Implementation of the "Customize Account" feature that allows users to customize their Stripe Connect account settings via a GET request and WebView redirection.

---

## Implementation Details

### 1. **API Endpoint**

**Endpoint:** `stripe/account-link`  
**Method:** GET  
**Authentication:** Bearer Token (from LocalStorage)  
**Purpose:** Get a customization link for the Stripe Connect account

---

### 2. **Service Layer** (`get_account_transaction_service.dart`)

**Method:** `getAccountLink()`

```dart
Future<Map<String, dynamic>> getAccountLink() async {
  // Makes GET request with Bearer token
  final url = '${AppUrls.baseUrl}${AppUrls.getAccountLink}';
  final headers = {
    'Authorization': 'Bearer ${LocalStorage.token}',
    'Content-Type': 'application/json',
  };
  
  final response = await _dio.get(url, options: Options(headers: headers));
  
  // Returns the data containing the URL
  return data['data'] as Map<String, dynamic>;
}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Account link generated successfully",
  "statusCode": 200,
  "data": {
    "url": "https://connect.stripe.com/setup/e/acct_xxx/xxx"
  }
}
```

---

### 3. **Controller Layer** (`account_transaction_controller.dart`)

**Method:** `getAccountLink()`

**Flow:**
1. User clicks "Customize" button
2. Shows loading indicator
3. Calls `_service.getAccountLink()` with Bearer token
4. Receives response with customization URL
5. Opens URL in WebView with title "Customize Account"
6. After WebView closes, refreshes account status
7. Hides loading indicator

**Code:**
```dart
Future<void> getAccountLink() async {
  try {
    isLoading.value = true;
    
    final result = await _service.getAccountLink();
    
    if (result['url'] != null) {
      final url = result['url'] as String;
      
      // Open URL in webview for account customization
      await _openUrlInWebView(url, title: 'Customize Account');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to get account link: $e');
  } finally {
    isLoading.value = false;
  }
}
```

---

### 4. **UI Implementation** (`account_transaction_view.dart`)

**Button Location:** Account Dashboard View (when account is fully set up)

**Button Code:**
```dart
OutlinedButton.icon(
  onPressed: controller.getAccountLink,
  icon: const Icon(Icons.edit, size: 20),
  label: const Text('Customize'),
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.purple.shade600,
    side: BorderSide(color: Colors.purple.shade600),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

**Button States:**
- **Idle:** Shows "Customize" with edit icon
- **Loading:** Disabled while request is in progress
- **Success:** Opens WebView with Stripe customization page
- **Error:** Shows error snackbar

---

## User Flow

```
1. User has completed Stripe account setup
   ↓
2. User sees Account Dashboard with "Customize" button
   ↓
3. User clicks "Customize" button
   ↓
4. GET request to: baseUrl + 'stripe/account-link'
   Headers: { 'Authorization': 'Bearer ${token}' }
   ↓
5. Backend generates account customization link
   ↓
6. Backend returns URL for Stripe account settings
   ↓
7. App opens URL in WebView (title: "Customize Account")
   ↓
8. User customizes Stripe account settings:
   - Business details
   - Banking information
   - Payout schedule
   - Branding
   - Tax information
   ↓
9. User completes customization
   ↓
10. WebView detects completion and closes
   ↓
11. App refreshes account status
   ↓
12. UI updates with latest account information
```

---

## Features Available in Customization

When users click "Customize", they can modify:

### Business Information
- Business name
- Business type
- Industry
- Website
- Support phone/email

### Banking Details
- Bank account information
- Payout schedule
- Statement descriptor

### Branding
- Logo
- Brand colors
- Icon

### Tax Information
- Tax ID
- VAT number
- Tax forms

### Settings
- Email notifications
- Dashboard preferences
- API settings

---

## API Request Example

**Request:**
```http
GET http://10.10.7.62:7010/api/v1/stripe/account-link
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

**Response:**
```json
{
  "success": true,
  "message": "Account link generated successfully",
  "statusCode": 200,
  "data": {
    "url": "https://connect.stripe.com/setup/e/acct_1SPz8YPUEGClq8ci/5dUKJFonTwu4",
    "expiresAt": "2024-11-05T12:00:00Z",
    "type": "account_update"
  }
}
```

---

## Error Handling

### Network Errors
- Shows user-friendly error message
- Logs detailed error to console
- Button returns to idle state

### API Errors
- Displays error from backend
- Logs status code and response
- Allows user to retry

### WebView Errors
- Shows error snackbar
- Provides refresh button
- Allows user to close and retry

### Token Errors
- Shows "No access token found" error
- Redirects to login if needed

---

## WebView Behavior

**Title:** "Customize Account"  
**Features:**
- Fullscreen display
- Loading progress indicator
- Refresh button
- Close button
- Auto-detection of completion
- Error handling

**Completion Detection:**
Automatically detects when user completes customization by checking URL for:
- `return_url`
- `refresh_url`
- `success`

---

## Testing Scenarios

### 1. **Happy Path**
- Click "Customize" → Link generated → WebView opens → Customize account → Success

### 2. **No Internet**
- Click "Customize" → Network error shown → Button returns to idle

### 3. **Invalid Token**
- Click "Customize" → 401 error → Error message shown

### 4. **User Cancels**
- Click "Customize" → WebView opens → User closes → Account unchanged

### 5. **Link Expired**
- Click "Customize" → Expired link error → User can retry

---

## Differences from Create Account Flow

| Feature | Create Account | Customize Account |
|---------|---------------|-------------------|
| **Endpoint** | `stripe/connect-account` (POST) | `stripe/account-link` (GET) |
| **Purpose** | Create new account | Modify existing account |
| **When Available** | No account exists | Account exists and active |
| **Button Label** | "Create Stripe Account" | "Customize" |
| **WebView Title** | "Stripe Connect" | "Customize Account" |
| **Icon** | Account balance | Edit |

---

## Security Considerations

✅ **Bearer Token:** Securely passed in Authorization header  
✅ **HTTPS:** All Stripe URLs use HTTPS  
✅ **WebView Isolation:** Runs in isolated context  
✅ **No Token Exposure:** Token never sent to Stripe  
✅ **Link Expiration:** Stripe links expire after 1 hour  
✅ **Account Verification:** Only account owner can customize  

---

## Files Involved

### Modified:
1. `account_transaction_view.dart` - Updated button label to "Customize"
2. `account_transaction_controller.dart` - Updated WebView title to "Customize Account"

### Existing (No Changes Needed):
1. `get_account_transaction_service.dart` - Already has `getAccountLink()` method
2. `stripe_webview.dart` - Reuses existing WebView component
3. `app_urls.dart` - Already has `getAccountLink` endpoint

---

## Status

✅ **Fully Implemented and Ready to Use**

**Last Updated:** November 5, 2024

---

## Usage Example

```dart
// In your controller or view
await controller.getAccountLink();

// This will:
// 1. Make GET request to stripe/account-link
// 2. Extract URL from response
// 3. Open WebView with title "Customize Account"
// 4. Allow user to customize their Stripe account
// 5. Auto-close when complete
// 6. Refresh account status
```
