class BackpackerProfile {
  BackpackerProfile({
    required this.copperCoins,
    required this.reputationScore,
    required this.publishFee,
    required this.dailyCheckinReward,
    required this.canCheckinToday,
    required this.canAffordPublish,
    this.lastCheckinDate,
    this.completedTasks,
  });

  final int copperCoins;
  final int reputationScore;
  final int publishFee;
  final int dailyCheckinReward;
  final bool canCheckinToday;
  final bool canAffordPublish;
  final String? lastCheckinDate;
  final int? completedTasks;

  factory BackpackerProfile.fromJson(Map<String, dynamic> json) {
    return BackpackerProfile(
      copperCoins: json['copperCoins'] as int? ?? 0,
      reputationScore: json['reputationScore'] as int? ?? 100,
      publishFee: json['publishFee'] as int? ?? 5,
      dailyCheckinReward: json['dailyCheckinReward'] as int? ?? 2,
      canCheckinToday: json['canCheckinToday'] as bool? ?? true,
      canAffordPublish: json['canAffordPublish'] as bool? ?? false,
      lastCheckinDate: json['lastCheckinDate'] as String?,
      completedTasks: json['completedTasks'] as int?,
    );
  }
}
