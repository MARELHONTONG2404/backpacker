import '../models/app_notification.dart';
import 'app_localizations.dart';

bool _isZh(AppLocalizations l10n) =>
    l10n.localeName == 'zh' || l10n.localeName.startsWith('zh_');

/// Menerjemahkan pesan dari backend (Bahasa Indonesia) ke locale aktif.
String localizeServerMessage(AppLocalizations l10n, String message) {
  if (!_isZh(l10n)) return message;

  final exact = _exactZh[message.trim()];
  if (exact != null) return exact;

  for (final entry in _patternZh) {
    final match = entry.pattern.firstMatch(message);
    if (match != null) return entry.translate(match);
  }

  return message;
}

/// Riwayat koin — remark dari backend + fallback txType.
String localizeCoinRemark(AppLocalizations l10n, String? remark, String txType) {
  if (!_isZh(l10n)) {
    return remark != null && remark.isNotEmpty ? remark : localizedTxType(l10n, txType);
  }

  if (remark != null && remark.isNotEmpty) {
    final mapped = _coinRemarkZh[remark.trim()];
    if (mapped != null) return mapped;
  }

  return localizedTxType(l10n, txType);
}

String localizeNotificationTitle(AppLocalizations l10n, AppNotification notification) {
  if (!_isZh(l10n)) return notification.title;

  switch (notification.notifyType) {
    case 'ORDER_TAKEN':
      return l10n.notifOrderTakenTitle;
    case 'ORDER_SUBMITTED':
      return l10n.notifOrderSubmittedTitle;
    case 'ORDER_COMPLETED':
      if (notification.title == 'Reward diterima') {
        return l10n.notifRewardTitle;
      }
      return l10n.notifOrderCompletedTitle;
    case 'ORDER_RATED':
      return l10n.notifOrderRatedTitle;
    default:
      return _exactZh[notification.title] ?? notification.title;
  }
}

String localizeNotificationContent(AppLocalizations l10n, AppNotification notification) {
  if (!_isZh(l10n)) return notification.content;

  final content = notification.content.trim();

  final taken = RegExp(r'^Tugas "(.+)" telah diambil pelaksana\.?$').firstMatch(content);
  if (taken != null) {
    return l10n.notifOrderTakenContent(taken.group(1)!);
  }

  final submitted = RegExp(
    r'^Pelaksana mengajukan penyelesaian tugas "(.+)"\. Silakan konfirmasi\.?$',
  ).firstMatch(content);
  if (submitted != null) {
    return l10n.notifOrderSubmittedContent(submitted.group(1)!);
  }

  final completed = RegExp(r'^Tugas "(.+)" selesai\. Silakan beri penilaian\.?$').firstMatch(content);
  if (completed != null) {
    return l10n.notifOrderCompletedContent(completed.group(1)!);
  }

  final reward = RegExp(
    r'Anda mendapat \+(\d+) koin(?: tembaga)? dan \+(\d+) reputasi',
  ).firstMatch(content);
  if (reward != null) {
    return l10n.notifRewardContent(
      int.parse(reward.group(1)!),
      int.parse(reward.group(2)!),
    );
  }

  final rated = RegExp(
    r'^Pembuat tugas memberi skor (\d+)/5 untuk tugas "(.+)"\.?$',
  ).firstMatch(content);
  if (rated != null) {
    return l10n.notifOrderRatedContent(rated.group(2)!, int.parse(rated.group(1)!));
  }

  return content;
}

String localizedTxType(AppLocalizations l10n, String txType) {
  switch (txType) {
    case 'REGISTER_BONUS':
      return l10n.txRegisterBonus;
    case 'DAILY_CHECKIN':
      return l10n.txDailyCheckin;
    case 'PUBLISH_FEE':
      return l10n.txPublishFee;
    case 'TASK_REWARD':
      return l10n.txTaskReward;
    case 'ADMIN_ADJUST':
      return l10n.txAdminAdjust;
    default:
      return txType;
  }
}

class _PatternRule {
  const _PatternRule(this.pattern, this.translate);
  final RegExp pattern;
  final String Function(RegExpMatch match) translate;
}

const _exactZh = <String, String>{
  'Sesi login habis, silakan masuk kembali': '登录已过期，请重新登录',
  'Respons server tidak valid': '服务器响应无效',
  'Permintaan gagal': '请求失败',
  'Token login tidak ditemukan': '未找到登录令牌',
  'Data user tidak ditemukan': '未找到用户数据',
  'Pesanan respons tidak valid': '订单响应无效',
  'Data respons tidak valid': '数据响应无效',
  'Anda sudah check-in hari ini': '您今天已经签到过了',
  'Gagal memotong koin tembaga untuk publikasi': '扣除发布费用失败',
  'Gagal membuat pesanan': '创建任务失败',
  'Pesanan tidak ditemukan': '未找到订单',
  'Hanya pembuat tugas yang dapat mempublikasikan pesanan': '只有发布者可以发布任务',
  'Hanya pesanan berstatus DRAFT yang dapat dipublikasikan': '只有草稿状态的任务可以发布',
  'Gagal mempublikasikan pesanan': '发布任务失败',
  'Anda tidak dapat mengambil tugas buatan sendiri': '不能接取自己发布的任务',
  'Tugas tidak tersedia atau sudah diambil': '任务不可用或已被接单',
  'Tugas sudah diambil pengguna lain': '任务已被其他用户接单',
  'Gagal memulai pengerjaan tugas': '开始执行任务失败',
  'Gagal menyelesaikan tugas': '完成任务失败',
  'Hanya pembuat tugas yang dapat membatalkan pesanan': '只有发布者可以取消订单',
  'Pesanan tidak dapat dibatalkan pada status ini': '当前状态下无法取消订单',
  'Gagal membatalkan pesanan': '取消订单失败',
  'Hanya pelaksana yang dapat melepaskan tugas': '只有执行者可以放弃任务',
  'Tugas tidak dapat dilepas pada status ini': '当前状态下无法放弃任务',
  'Gagal melepaskan tugas': '放弃任务失败',
  'Skor penilaian harus antara 1 hingga 5': '评分必须在 1 到 5 之间',
  'Hanya pembuat tugas yang dapat memberi penilaian': '只有发布者可以评价',
  'Hanya tugas selesai yang dapat dinilai': '只能评价已完成的任务',
  'Tugas tidak memiliki pelaksana': '任务没有执行者',
  'Tugas ini sudah dinilai': '该任务已经评价过了',
  'Gagal menyimpan penilaian': '保存评价失败',
  'Status pesanan tidak valid untuk aksi ini': '当前订单状态无法执行此操作',
  'Scope tidak valid. Gunakan: created, executing, atau all': '筛选范围无效。请使用：created、executing 或 all',
  'Penilaian berhasil disimpan': '评价已保存',
  'Pesanan berhasil dibuat': '任务创建成功',
  'Pesanan berhasil dipublikasikan': '任务发布成功',
  'Tugas berhasil diambil': '接单成功',
  'Tugas mulai dikerjakan': '任务已开始执行',
  'Pengajuan selesai terkirim': '完成申请已提交',
  'Tugas dikonfirmasi selesai': '任务已确认完成',
  'Gagal mengajukan penyelesaian tugas': '提交完成申请失败',
  'Gagal mengonfirmasi penyelesaian tugas': '确认完成失败',
  'Hanya pelaksana dapat mengajukan penyelesaian tugas': '只有执行者可以提交完成申请',
  'Status pesanan tidak valid untuk pengajuan selesai': '当前状态无法提交完成申请',
  'Hanya pembuat tugas yang dapat mengonfirmasi penyelesaian': '只有发布者可以确认完成',
  'Hanya tugas yang diajukan selesai yang dapat dikonfirmasi': '只能确认已提交完成的申请',
  'Pengajuan selesai': '完成申请',
  'Tugas berhasil diselesaikan': '任务已完成',
  'Pesanan berhasil dibatalkan': '订单已取消',
  'Tugas berhasil dilepas': '任务已放弃',
  'Semua notifikasi ditandai sudah dibaca': '所有通知已标记为已读',
  'Draft tugas berhasil diperbarui': '草稿已更新',
  'Anda tidak memiliki akses ke pesanan ini': '您无权访问此订单',
  'Tugas diambil': '任务已被接单',
  'Tugas selesai': '任务已完成',
  'Reward diterima': '奖励已到账',
  'Penilaian diterima': '收到评价',
};

const _coinRemarkZh = <String, String>{
  'Check-in harian': '每日签到',
  'Bonus registrasi backpacker': 'Backpacker 注册奖励',
  'Biaya publikasi tugas': '任务发布费用',
  'Reward menyelesaikan tugas': '完成任务奖励',
  'Tugas berhasil diselesaikan': '任务成功完成',
  'Penilaian buruk dari pembuat tugas': '发布者给出差评',
  'Penilaian bagus dari pembuat tugas': '发布者给出好评',
  'Tugas dilepas oleh pelaksana': '执行者放弃了任务',
};

final _patternZh = <_PatternRule>[
  _PatternRule(
    RegExp(r'^Koin tembaga tidak cukup\. Biaya publikasi: (\d+) koin, saldo Anda: (\d+) koin$'),
    (m) => '铜币不足。发布费用：${m.group(1)} 铜币，当前余额：${m.group(2)} 铜币',
  ),
  _PatternRule(
    RegExp(r'^Reputasi Anda terlalu rendah \((\d+)\)\. Minimum (\d+) poin untuk mengambil tugas\.$'),
    (m) => '您的信誉 (${m.group(1)}) 过低。接单最低要求 ${m.group(2)} 分。',
  ),
  _PatternRule(
    RegExp(r'^Check-in berhasil! \+(\d+) koin(?: tembaga)?$'),
    (m) => '签到成功！+${m.group(1)} 铜币',
  ),
  _PatternRule(
    RegExp(r'^(Hanya pelaksana dapat .+)$'),
    (m) => _translateExecutorOnly(m.group(1)!),
  ),
  _PatternRule(
    RegExp(r'^(Hanya pembuat tugas yang .+)$'),
    (m) => _translateCreatorOnly(m.group(1)!),
  ),
];

String _translateExecutorOnly(String message) {
  if (message.contains('menyelesaikan tugas yang sedang dikerjakan')) {
    return '只有执行者可以完成正在执行中的任务';
  }
  if (message.contains('memulai tugas yang sudah diambil')) {
    return '只有执行者可以开始已接单的任务';
  }
  return message;
}

String _translateCreatorOnly(String message) {
  return message;
}
