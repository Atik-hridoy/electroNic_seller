import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/get_account_transaction_service.dart';
import '../views/stripe_webview.dart';

class AccountTransactionController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isLoadingTransactions = false.obs;
  final RxBool isCreatingAccount = false.obs;
  final RxBool hasStripeAccount = false.obs;
  
  // Stripe Connect Account Information
  final RxString accountHolderName = ''.obs;
  final RxString stripeAccountId = ''.obs;
  final RxString stripeEmail = ''.obs;
  final RxString country = ''.obs;
  final RxString currency = ''.obs;
  final RxString accountStatus = ''.obs;
  final RxBool payoutsEnabled = false.obs;
  final RxBool chargesEnabled = false.obs;
  final RxBool detailsSubmitted = false.obs;
  final RxBool onboardingComplete = false.obs;
  
  // Balance Information
  final RxDouble totalBalance = 0.0.obs;
  final RxDouble availableBalance = 0.0.obs;
  final RxDouble pendingBalance = 0.0.obs;
  final RxDouble withdrawnAmount = 0.0.obs;
  
  // Transaction History
  final RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredTransactions = <Map<String, dynamic>>[].obs;
  
  // Filter options
  final RxString selectedFilter = 'All'.obs;
  final List<String> filterOptions = ['All', 'Credit', 'Debit', 'Pending', 'Completed'];
  
  // Service
  final GetAccountTransactionService _service = GetAccountTransactionService();
  
  @override
  void onInit() {
    super.onInit();
    checkAccountStatus();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
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
  
  // Load account information
  Future<void> loadAccountData(Map<String, dynamic> accountData) async {
    try {
      // Parse Stripe Connect account information
      accountHolderName.value = accountData['accountHolderName'] ?? accountData['displayName'] ?? 'N/A';
      stripeAccountId.value = accountData['stripeAccountId'] ?? accountData['id'] ?? 'N/A';
      stripeEmail.value = accountData['email'] ?? 'N/A';
      country.value = accountData['country'] ?? 'US';
      currency.value = accountData['currency'] ?? 'USD';
      accountStatus.value = accountData['status'] ?? 'pending';
      payoutsEnabled.value = accountData['payoutsEnabled'] ?? false;
      chargesEnabled.value = accountData['chargesEnabled'] ?? false;
      detailsSubmitted.value = accountData['detailsSubmitted'] ?? false;
      onboardingComplete.value = accountData['onboardingComplete'] ?? false;
      
      // Parse balance information if available
      totalBalance.value = (accountData['totalBalance'] ?? 0.0).toDouble();
      availableBalance.value = (accountData['availableBalance'] ?? 0.0).toDouble();
      pendingBalance.value = (accountData['pendingBalance'] ?? 0.0).toDouble();
      withdrawnAmount.value = (accountData['withdrawnAmount'] ?? 0.0).toDouble();
      
      // Load transactions if account is active
      if (accountStatus.value == 'active' || payoutsEnabled.value) {
        await loadTransactions();
      }
      
      print('✅ Account data loaded successfully');
    } catch (e) {
      print('❌ Error loading account data: $e');
    }
  }
  
  // Create Stripe Connect account (using GET account link)
  Future<void> createStripeAccount() async {
    try {
      isCreatingAccount.value = true;
      
      // Use GET request to get account link instead of POST to create account
      final result = await _service.getAccountLink();
      
      if (result['url'] != null) {
        final url = result['url'] as String;
        
        // Open the URL in webview for account setup
        await _openUrlInWebView(url, title: 'Setup Stripe Account');
        
        // Refresh account status after webview closes
        await checkAccountStatus();
      } else {
        Get.snackbar(
          'Error',
          'No account link received from server',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('❌ Error getting account link: $e');
      Get.snackbar(
        'Error',
        'Failed to get account link: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isCreatingAccount.value = false;
    }
  }
  
  // Get account link to customize Stripe account
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
      print('❌ Error getting account link: $e');
      Get.snackbar(
        'Error',
        'Failed to get account link: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get login link to Stripe Dashboard
  Future<void> getLoginLink() async {
    try {
      isLoading.value = true;
      
      final result = await _service.getLoginLink();
      
      if (result['url'] != null) {
        final url = result['url'] as String;
        
        // Open Stripe Dashboard in webview
        await _openUrlInWebView(url, title: 'Stripe Dashboard');
      }
    } catch (e) {
      print('❌ Error getting login link: $e');
      Get.snackbar(
        'Error',
        'Failed to open Stripe Dashboard: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
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
  
  // Open URL in WebView
  Future<void> _openUrlInWebView(String url, {String title = 'Stripe Connect'}) async {
    try {
      print('🔗 Opening URL in WebView: $url');
      
      final result = await Get.to<bool>(
        () => StripeWebView(
          url: url,
          title: title,
        ),
        fullscreenDialog: true,
      );
      
      // If result is true, user completed the onboarding
      if (result == true) {
        print('✅ Onboarding completed successfully');
        await checkAccountStatus();
      }
    } catch (e) {
      print('❌ Error opening WebView: $e');
      Get.snackbar(
        'Error',
        'Failed to open page: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  // Load transaction history
  Future<void> loadTransactions() async {
    try {
      isLoadingTransactions.value = true;
      
      final transactionData = await _service.getTransactions();
      
      transactions.clear();
      transactions.addAll(transactionData);
      filteredTransactions.assignAll(transactions);
      
      print('✅ Loaded ${transactions.length} transactions');
    } catch (e) {
      print('❌ Error loading transactions: $e');
      
      // Load sample transactions on error
      _loadSampleTransactions();
      
      Get.snackbar(
        'Notice',
        'Using sample transaction data. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingTransactions.value = false;
    }
  }
  
  // Filter transactions
  void filterTransactions(String filter) {
    selectedFilter.value = filter;
    
    if (filter == 'All') {
      filteredTransactions.assignAll(transactions);
    } else {
      filteredTransactions.assignAll(
        transactions.where((transaction) {
          if (filter == 'Credit') {
            return transaction['type'] == 'credit';
          } else if (filter == 'Debit') {
            return transaction['type'] == 'debit';
          } else if (filter == 'Pending') {
            return transaction['status'] == 'pending';
          } else if (filter == 'Completed') {
            return transaction['status'] == 'completed';
          }
          return true;
        }),
      );
    }
  }
  
  // Refresh all data
  Future<void> refreshData() async {
    await checkAccountStatus();
  }
  
  // Request withdrawal
  void requestWithdrawal() {
    Get.snackbar(
      'Request Withdrawal',
      'Withdrawal feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // View transaction details
  void viewTransactionDetails(Map<String, dynamic> transaction) {
    // This will be handled in the view
  }
  
  // Load sample Stripe account data
  void _loadSampleAccountData() {
    accountHolderName.value = 'John Doe';
    stripeAccountId.value = 'acct_1234567890';
    stripeEmail.value = 'seller@example.com';
    country.value = 'US';
    currency.value = 'USD';
    accountStatus.value = 'active';
    payoutsEnabled.value = true;
    chargesEnabled.value = true;
    
    totalBalance.value = 50000.0;
    availableBalance.value = 45000.0;
    pendingBalance.value = 5000.0;
    withdrawnAmount.value = 20000.0;
  }
  
  // Load sample transactions
  void _loadSampleTransactions() {
    transactions.addAll([
      {
        'id': 'TXN001',
        'amount': 5000.0,
        'type': 'credit',
        'status': 'completed',
        'date': '2024-11-01',
        'description': 'Payment received from Order #12345',
      },
      {
        'id': 'TXN002',
        'amount': 2000.0,
        'type': 'debit',
        'status': 'completed',
        'date': '2024-11-02',
        'description': 'Withdrawal to bank account',
      },
      {
        'id': 'TXN003',
        'amount': 3500.0,
        'type': 'credit',
        'status': 'pending',
        'date': '2024-11-03',
        'description': 'Payment received from Order #12346',
      },
      {
        'id': 'TXN004',
        'amount': 1500.0,
        'type': 'debit',
        'status': 'completed',
        'date': '2024-11-04',
        'description': 'Platform fee deduction',
      },
      {
        'id': 'TXN005',
        'amount': 7500.0,
        'type': 'credit',
        'status': 'completed',
        'date': '2024-11-05',
        'description': 'Payment received from Order #12347',
      },
    ]);
    filteredTransactions.assignAll(transactions);
  }
  
  // Format currency
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
  
  // Get masked Stripe account ID
  String get maskedStripeAccountId {
    if (stripeAccountId.value.length > 8) {
      final lastFour = stripeAccountId.value.substring(stripeAccountId.value.length - 4);
      return 'acct_••••$lastFour';
    }
    return stripeAccountId.value;
  }
  
  // Get currency symbol
  String get currencySymbol {
    switch (currency.value.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'INR':
        return '₹';
      default:
        return currency.value;
    }
  }
}
