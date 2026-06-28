class APIconst {
  static String baseUrl = 'https://market.saied.aait-d.com/api';
  static const verify = 'app/driver/auth/register/verify';
  static const passwordVerify = 'app/client/password/verify';

  static const resend = 'app/driver/auth/register/send-otp';
  static const forgetPassword = 'app/client/password/forget';
  static const login = 'app/driver/auth/login';
  static const registerCredentials = 'app/driver/auth/register/credentials';
  static const registerDocument = 'app/driver/auth/register/document';
  static const loginGuest = 'client/auth/login-as-guest';
  static const resetPassword = 'app/client/password/reset';
  static const changePassword = 'app/client/password/change';
  static const logout = 'app/driver/auth/logout';
  static const wallet = 'client/wallet';
  static const walletPayment = 'payment/wallet';
  static const walletCharge = 'payment/wallet/charge';
  static const loyaltyTransactions = 'client/loyalty/transactions';
  static const rateOrder = 'client/ratings/orders';

  static const home = 'app/driver/home';
  static const getAvailableOrders = 'app/driver/orders';
  static const getOrders = 'app/driver/my-orders';
  static String getOrderDetailsById(String id) => 'app/driver/orders/$id';
  static String getChatById(String id) => 'app/driver/chat/$id';
  static String sendMessage = 'app/driver/chat';

  static String walletDetails(String walletId) => 'client/wallet/$walletId';
  static const mosques = 'general/mosques';
  static const countries = 'general/countries';
  static const cities = 'general/cities';
  static const media = 'general/media';
  static const notificationsList = 'general/notifications';
  static const products = 'general/catalog/products';
  static const subCategories = 'general/catalog/sub-categories';
  static const searchHistories = 'general/search-histories';
  static const favorites = 'general/favorites';
  static const toggleFavorite = 'general/favorites/toggle';
  static const messages = 'client/messages';

  static const profile = 'client/profile';
  static const profileSendOtp = 'app/client/profile/send/otp';
  static const profileUpdateAuth = 'app/client/profile/update/auth';
  static const profileUpdatePassword = 'client/profile/update-password';
  static const profileNotificationSwitch =
      'app/client/profile/notification/switch';
  static const profileOnlineSwitch = 'app/driver/profile/online/switch';
  static const profileLanguageSwitch = 'app/client/profile/language/switch/';
  static const profileUpdateDocuments = 'app/driver/profile/document';
  static const profileUpdateCredentials = 'app/driver/profile';
  static const contactUs = 'general/pages/contact';
  static const profileDeleteAccount = 'app/client/profile';
  static const appPages = 'general/pages/page';
  static const generalAttachment = 'general/attachment';

  static const stores = 'general/stores';

  static const methodsMyfatoorah = 'payment/methods/myfatoorah';

  static String membershipCancel(String membershipId) =>
      'client/memberships/$membershipId/leave';

  static const updateChecker = 'api/v1/app-update/by-domain-type';
  static const membershipsJoin = 'client/memberships/join';
  static const couponScan = 'client/coupon/scan';
  static const cartAdd = 'general/cart/add';
  static const cartQuantity = 'general/cart/quantity';
  static const cart = 'client/cart';
  static const cartItems = 'client/cart/items';
  static String cartItem(String id) => 'client/cart/items/$id';
  static const cartMosque = 'general/cart/mosque';
  static const checkout = 'client/orders/checkout';
  static const orders = 'client/orders';
  static const requests = 'client/service-requests';
  static const categories = 'general/categories';
  static const districts = 'general/districts';
  static const addresses = 'client/addresses';
  static const serviceRequests = 'client/service-requests';

  static const clearSearchHistories = 'general/search-histories/clear';

  static const contacts = 'app/driver/contacts';
  static const driverNotifications = 'app/driver/notifications';
  static const driverWallet = 'app/driver/wallet';
  static String showPage(String type) => 'general/show-page/$type';
  static const faqs = 'general/faqs';

  static const services = 'general/services';
  static String address(String id) => 'client/addresses/$id';
  static String addressDefault(String id) => 'client/addresses/$id/default';

  static String getServiceForm(String serviceId) =>
      'general/services/$serviceId/form-fields';
}
