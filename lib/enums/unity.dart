enum ResultStatus {
  success(true),
  failure(false);

  final bool value;
  const ResultStatus(this.value);
}
