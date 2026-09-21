import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class PaywallFailure extends Failure {
  const PaywallFailure(super.message, this.code);

  final String code;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

//for general failures

class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
}


// for IAP failures 

class ProductNotFoundFailure extends Failure {
  const ProductNotFoundFailure(super.message);
}
class PurchaseFailedFailure extends Failure {
  const PurchaseFailedFailure(super.message);
}
class ConnectionFailedFailure extends Failure {
  const ConnectionFailedFailure(super.message);
}

class PurchasePendingFailure extends Failure {
  const PurchasePendingFailure(super.message);
}
class PurchaseCancelledFailure extends Failure {
  const PurchaseCancelledFailure(super.message);
}


