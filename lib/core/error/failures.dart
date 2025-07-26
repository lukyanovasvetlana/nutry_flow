abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class AnalyticsFailure extends Failure {
  AnalyticsFailure(String message) : super(message);
} 