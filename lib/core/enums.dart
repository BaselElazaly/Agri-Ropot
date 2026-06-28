enum RequestState {
  loading,
  done,
  error,
  initial;

  bool get isLoading => this == RequestState.loading;

  bool get isDone => this == RequestState.done;

  bool get isError => this == RequestState.error;

  bool get isInitial => this == RequestState.initial;
}

enum ErrorType {
  network,
  server,
  backEndValidation,
  empty,
  unknown,
  none,
  cancel,
  unAuth,
}

enum UserType { user, guest }

enum OrderStatus { active, completed, cancelled }

enum WalletTransaction { success, failure }

enum VerifyType { register, forgetPassword, changeAuth }

enum SupportAndComplaintsType { contact, complaint }

enum AuthType { phone, email }
