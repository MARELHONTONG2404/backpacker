class CoinTransaction {
  CoinTransaction({
    required this.transactionId,
    required this.amount,
    required this.balanceAfter,
    required this.txType,
    this.remark,
    this.createTime,
  });

  final int transactionId;
  final int amount;
  final int balanceAfter;
  final String txType;
  final String? remark;
  final String? createTime;

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      transactionId: json['transactionId'] as int? ?? 0,
      amount: json['amount'] as int? ?? 0,
      balanceAfter: json['balanceAfter'] as int? ?? 0,
      txType: json['txType'] as String? ?? '',
      remark: json['remark'] as String?,
      createTime: json['createTime'] as String?,
    );
  }
}
