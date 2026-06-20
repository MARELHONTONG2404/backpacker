class BackpackerProfile {
  BackpackerProfile({
    required this.copperCoins,
    required this.reputationScore,
    required this.publishFee,
    required this.dailyCheckinReward,
    required this.canCheckinToday,
    required this.canAffordPublish,
    required this.canTakeTask,
    required this.minReputationToTake,
    this.lastCheckinDate,
    this.completedTasks,
    this.taskRewardCoins,
    this.reputationTaskComplete,
  });

  final int copperCoins;
  final int reputationScore;
  final int publishFee;
  final int dailyCheckinReward;
  final bool canCheckinToday;
  final bool canAffordPublish;
  final bool canTakeTask;
  final int minReputationToTake;
  final String? lastCheckinDate;
  final int? completedTasks;
  final int? taskRewardCoins;
  final int? reputationTaskComplete;

  factory BackpackerProfile.fromJson(Map<String, dynamic> json) {
    return BackpackerProfile(
      copperCoins: json['copperCoins'] as int? ?? 0,
      reputationScore: json['reputationScore'] as int? ?? 100,
      publishFee: json['publishFee'] as int? ?? 5,
      dailyCheckinReward: json['dailyCheckinReward'] as int? ?? 2,
      canCheckinToday: json['canCheckinToday'] as bool? ?? true,
      canAffordPublish: json['canAffordPublish'] as bool? ?? false,
      canTakeTask: json['canTakeTask'] as bool? ?? true,
      minReputationToTake: json['minReputationToTake'] as int? ?? 60,
      lastCheckinDate: json['lastCheckinDate'] as String?,
      completedTasks: json['completedTasks'] as int?,
      taskRewardCoins: json['taskRewardCoins'] as int?,
      reputationTaskComplete: json['reputationTaskComplete'] as int?,
    );
  }
}
