class OperationStatus{
  bool success = false;
  String? errorMessage;
  int? errorType;

  OperationStatus(this.success, this.errorMessage, this.errorType);
}