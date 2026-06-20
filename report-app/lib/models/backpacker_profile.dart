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

  static int _readInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool _readBool(dynamic value, {bool defaultValue = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return defaultValue;
  }

  static String? _readDateString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  factory BackpackerProfile.fromJson(Map<String, dynamic> json) {
    return BackpackerProfile(
      copperCoins: _readInt(json['copperCoins']),
      reputationScore: _readInt(json['reputationScore'], defaultValue: 100),
      publishFee: _readInt(json['publishFee'], defaultValue: 5),
      dailyCheckinReward: _readInt(json['dailyCheckinReward'], defaultValue: 2),
      canCheckinToday: _readBool(json['canCheckinToday'], defaultValue: true),
      canAffordPublish: _readBool(json['canAffordPublish']),
      canTakeTask: _readBool(json['canTakeTask'], defaultValue: true),
      minReputationToTake: _readInt(json['minReputationToTake'], defaultValue: 60),
      lastCheckinDate: _readDateString(json['lastCheckinDate']),
      completedTasks: json['completedTasks'] == null ? null : _readInt(json['completedTasks']),
      taskRewardCoins: json['taskRewardCoins'] == null ? null : _readInt(json['taskRewardCoins']),
      reputationTaskComplete:
          json['reputationTaskComplete'] == null ? null : _readInt(json['reputationTaskComplete']),
    );
  }

  String get reputationBlockedMessage =>
      'Reputasi Anda ($reputationScore) di bawah minimum $minReputationToTake poin. '
      'Selesaikan tugas dengan baik atau check-in harian untuk memulihkan reputasi.';

  String get publishBlockedMessage =>
      'Koin tembaga tidak cukup ($copperCoins/$publishFee). '
      'Check-in harian (+$dailyCheckinReward koin) atau selesaikan tugas (+${taskRewardCoins ?? 3} koin).';
}
