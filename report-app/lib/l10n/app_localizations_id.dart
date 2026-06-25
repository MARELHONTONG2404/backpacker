// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Backpacker';

  @override
  String get appSubtitle => 'Marketplace Jasa On-Demand';

  @override
  String get appConcept =>
      'Platform penghubung pembuat tugas dan pelaksana jasa mikro';

  @override
  String welcomeHello(String name) {
    return 'Halo, $name!';
  }

  @override
  String get loginTitle => 'Backpacker';

  @override
  String get loginTagline => 'Marketplace Jasa On-Demand';

  @override
  String get loginDescription =>
      'Masuk untuk melihat tugas backpacker lain, mempublikasikan tugas sendiri, mengelola koin tembaga, dan memantau reputasi Anda.';

  @override
  String get captchaHint =>
      'Masukkan kode verifikasi pada gambar untuk keamanan akun.';

  @override
  String get username => 'Akun';

  @override
  String get password => 'Kata sandi';

  @override
  String get captcha => 'Kode verifikasi';

  @override
  String get remember => 'Ingat kata sandi';

  @override
  String get submit => 'Masuk';

  @override
  String get submitting => 'Masuk...';

  @override
  String get registerLink => 'Belum punya akun? Daftar sekarang';

  @override
  String get forgotPasswordLink => 'Lupa password?';

  @override
  String get usernameRequired => 'Masukkan akun Anda';

  @override
  String get passwordRequired => 'Masukkan kata sandi Anda';

  @override
  String get captchaRequired => 'Masukkan kode verifikasi';

  @override
  String get captchaLoadFailed =>
      'Gagal memuat kode verifikasi. Pastikan backend berjalan, lalu ketuk gambar untuk coba lagi.';

  @override
  String get captchaNotReady =>
      'Kode verifikasi belum siap. Ketuk gambar untuk memuat ulang.';

  @override
  String get registerTitle => 'Daftar Backpacker';

  @override
  String get registerTagline => 'Gabung marketplace jasa on-demand';

  @override
  String get registerDescription =>
      'Daftar sebagai backpacker untuk melihat dan menerima tugas, serta mempublikasikan tugas sendiri dengan koin tembaga.';

  @override
  String get registerSubmit => 'Daftar';

  @override
  String get registerSuccess => 'Registrasi berhasil. Silakan masuk.';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun? Masuk';

  @override
  String get displayName => 'Nama tampilan';

  @override
  String get phoneOptional => 'Nomor telepon (opsional)';

  @override
  String get minChars2 => 'Minimal 2 karakter';

  @override
  String get minChars5 => 'Minimal 5 karakter';

  @override
  String get maxChars20 => 'Maksimal 20 karakter';

  @override
  String get forgotPasswordTitle => 'Lupa Password';

  @override
  String get forgotPasswordTagline => 'Backpacker';

  @override
  String get forgotPasswordDescription =>
      'Verifikasi dengan username dan nomor telepon yang terdaftar.';

  @override
  String get registeredPhone => 'Nomor telepon terdaftar';

  @override
  String get newPassword => 'Password baru';

  @override
  String get resetPassword => 'Atur Ulang Password';

  @override
  String get backToLogin => 'Kembali ke login';

  @override
  String get passwordResetSuccess =>
      'Password berhasil diatur ulang. Silakan masuk.';

  @override
  String get footer => 'Copyright © 2026 Backpacker. All Rights Reserved.';

  @override
  String get tabAvailable => 'Ambil';

  @override
  String get tabMine => 'Saya';

  @override
  String get tabCreate => 'Buat';

  @override
  String get tabProfile => 'Profil';

  @override
  String get roleOverviewTitle => 'Dua Peran di Backpacker';

  @override
  String get roleCreatorTitle => 'Pembuat Tugas';

  @override
  String get roleCreatorDesc =>
      'Buat tugas, berikan ke marketplace, dan pantau pelaksana.';

  @override
  String get roleExecutorTitle => 'Pelaksana Tugas';

  @override
  String get roleExecutorDesc =>
      'Ambil tugas orang lain, kerjakan, dan dapat koin & reputasi.';

  @override
  String get takeTabHeader => 'Marketplace Tugas';

  @override
  String get takeTabSubtitle =>
      'Sebagai pelaksana — ambil tugas yang dibuat pembuat lain.';

  @override
  String get createTabHeader => 'Buat & Berikan Tugas';

  @override
  String get createTabSubtitle =>
      'Sebagai pembuat — isi detail tugas lalu publikasikan ke marketplace.';

  @override
  String get myTasksHeader => 'Tugas Saya';

  @override
  String get myTasksSubtitle =>
      'Tugas yang Anda buat (pembuat) dan yang Anda kerjakan (pelaksana).';

  @override
  String get flowStepCreate => '1. Buat tugas';

  @override
  String get flowStepGive => '2. Berikan ke marketplace';

  @override
  String get flowStepTake => '3. Pelaksana ambil tugas';

  @override
  String get flowStepComplete => '4. Selesai & dapat reward';

  @override
  String get giveTaskAction => 'Berikan Tugas';

  @override
  String get takeTaskAction => 'Ambil Tugas';

  @override
  String get copperCoins => 'Koin Tembaga';

  @override
  String get checkin => 'Check-in';

  @override
  String get checkinDone => 'Sudah check-in';

  @override
  String get checkinScreenTitle => 'Check-in Harian';

  @override
  String checkinScreenSubtitle(int coins) {
    return 'Dapatkan $coins koin tembaga setiap hari saat check-in';
  }

  @override
  String get checkinScreenPrompt =>
      'Ketuk tombol di bawah untuk check-in hari ini. Check-in berikutnya tersedia besok.';

  @override
  String get checkinScreenAction => 'Check-in Sekarang';

  @override
  String checkinScreenRewardHint(int coins) {
    return 'Reward hari ini: +$coins koin tembaga';
  }

  @override
  String get checkinScreenAlreadyDone =>
      'Anda sudah check-in hari ini. Kembali besok untuk check-in berikutnya.';

  @override
  String get checkinScreenSuccessHint =>
      'Check-in berhasil untuk hari ini. Kembali besok untuk check-in berikutnya.';

  @override
  String get checkinContinueHome => 'Lanjut ke Beranda';

  @override
  String publishFeeHint(int fee) {
    return 'Biaya publikasi: $fee koin tembaga';
  }

  @override
  String get publishInsufficient =>
      'Koin tidak cukup. Dapatkan koin lewat check-in harian atau menyelesaikan tugas.';

  @override
  String get reputation => 'Reputasi';

  @override
  String reputationMinHint(int min) {
    return 'Minimum reputasi untuk ambil tugas: $min poin';
  }

  @override
  String get rateTask => 'Beri Penilaian';

  @override
  String get rateSubmitted => 'Penilaian berhasil disimpan';

  @override
  String get ratePrompt =>
      'Pelaksana sudah menyelesaikan tugas ini. Beri penilaian 1–5 bintang untuk hasil kerjanya.';

  @override
  String get rateNow => 'Nilai Sekarang';

  @override
  String get rateExecutorHint => 'Penilaian mempengaruhi reputasi pelaksana.';

  @override
  String get ratingLabel => 'Penilaian Pelaksana';

  @override
  String get needsRating => 'Perlu dinilai';

  @override
  String get filterAllStatus => 'Semua status';

  @override
  String get filterNeedsRating => 'Perlu dinilai';

  @override
  String get filterDraft => 'Draft';

  @override
  String get filterActive => 'Aktif';

  @override
  String get filterCompleted => 'Selesai';

  @override
  String get timelineTitle => 'Riwayat Status';

  @override
  String get timelineEmpty => 'Belum ada riwayat status.';

  @override
  String get timelineCreated => 'Tugas dibuat';

  @override
  String get editDraft => 'Edit Draft';

  @override
  String get draftUpdated => 'Draft tugas berhasil diperbarui';

  @override
  String get reputationHistory => 'Riwayat Reputasi';

  @override
  String get reputationHistoryEmpty => 'Belum ada perubahan reputasi.';

  @override
  String get markAllRead => 'Tandai semua dibaca';

  @override
  String get repTaskComplete => 'Tugas diselesaikan';

  @override
  String get repGoodRating => 'Penilaian bagus';

  @override
  String get repBadRating => 'Penilaian buruk';

  @override
  String get repTaskFailed => 'Tugas gagal / dilepas';

  @override
  String get repAdminAdjust => 'Penyesuaian admin';

  @override
  String get rulesTitle => 'Alur Pembuatan & Pemberian Tugas';

  @override
  String get rulesCoins =>
      'Pembuat tugas: gunakan koin tembaga untuk mempublikasikan tugas. Pelaksana: dapat koin dari check-in harian dan menyelesaikan tugas.';

  @override
  String get rulesReputation =>
      'Pelaksana mendapat reputasi saat menyelesaikan tugas. Reputasi turun jika gagal/lepas tugas atau dapat penilaian buruk.';

  @override
  String get rulesBlock =>
      'Pelaksana dengan reputasi di bawah batas minimum tidak bisa mengambil tugas baru.';

  @override
  String get logout => 'Keluar';

  @override
  String get refresh => 'Refresh';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get understand => 'Mengerti';

  @override
  String get retry => 'Coba lagi';

  @override
  String get loading => 'Memuat...';

  @override
  String loadCoinsFailed(String error) {
    return 'Gagal memuat data koin: $error';
  }

  @override
  String checkinSuccess(int coins) {
    return 'Check-in berhasil! +$coins koin';
  }

  @override
  String get loadAvailableTasksFailed => 'Gagal memuat tugas tersedia';

  @override
  String get loadingAvailableTasks => 'Memuat tugas tersedia...';

  @override
  String get searchTaskHint => 'Cari judul tugas...';

  @override
  String get category => 'Kategori';

  @override
  String get all => 'Semua';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusPublished => 'Dipublikasikan';

  @override
  String get statusTaken => 'Diambil';

  @override
  String get statusInProgress => 'Dikerjakan';

  @override
  String get statusSubmitted => 'Menunggu Konfirmasi';

  @override
  String get statusCompleted => 'Selesai';

  @override
  String get statusCancelled => 'Dibatalkan';

  @override
  String get statusExpired => 'Kedaluwarsa';

  @override
  String get categoryGeneral => 'Umum';

  @override
  String get categoryDelivery => 'Antar Barang';

  @override
  String get categoryDeliveryShort => 'Antar';

  @override
  String get categoryHelper => 'Bantuan';

  @override
  String get categoryTech => 'Teknisi';

  @override
  String get categoryErrands => 'Belanja / Errands';

  @override
  String get noAvailableTasks => 'Belum ada tugas tersedia';

  @override
  String get noAvailableTasksSubtitle =>
      'Pembuat tugas lain belum mempublikasikan tugas. Coba buat & berikan tugas sendiri.';

  @override
  String get scopeAll => 'Semua';

  @override
  String get scopeCreated => 'Tugas Saya Buat';

  @override
  String get scopeExecuting => 'Tugas Saya Kerjakan';

  @override
  String needsRatingBanner(int count) {
    return '$count tugas selesai perlu dinilai. Penilaian buruk menurunkan reputasi pelaksana.';
  }

  @override
  String get loadingOrders => 'Memuat pesanan...';

  @override
  String get noOrders => 'Belum ada pesanan';

  @override
  String get noOrdersSubtitle =>
      'Tugas yang Anda buat atau kerjakan sebagai pelaksana akan muncul di sini.';

  @override
  String get taskCreatedPublished => 'Tugas berhasil dibuat dan dipublikasikan';

  @override
  String get taskDraftSaved => 'Draft tugas berhasil disimpan';

  @override
  String get createTaskFailed => 'Gagal membuat tugas';

  @override
  String get taskInfo => 'Informasi Tugas';

  @override
  String get taskTitle => 'Judul tugas';

  @override
  String get description => 'Deskripsi';

  @override
  String get requiredField => 'Wajib diisi';

  @override
  String get invalidNumber => 'Angka tidak valid';

  @override
  String get serviceDetails => 'Detail Layanan';

  @override
  String get rewardLabel => 'Imbalan (Rp)';

  @override
  String get location => 'Lokasi';

  @override
  String get publication => 'Publikasi';

  @override
  String get publishImmediately => 'Langsung publikasikan';

  @override
  String get publishImmediatelyHint =>
      'Nonaktifkan untuk simpan sebagai draft dulu';

  @override
  String get createAndPublish => 'Buat & Publish';

  @override
  String get saveDraft => 'Simpan Draft';

  @override
  String get orderDetail => 'Detail Pesanan';

  @override
  String get loadingOrderDetail => 'Memuat detail pesanan...';

  @override
  String get orderNotFound => 'Pesanan tidak ditemukan';

  @override
  String get openChat => 'Chat dengan Lawan Tugas';

  @override
  String get orderChatTitle => 'Chat Pesanan';

  @override
  String get loadingChat => 'Memuat chat...';

  @override
  String get chatEmptyTitle => 'Belum ada pesan';

  @override
  String get chatEmptySubtitle =>
      'Mulai percakapan dengan pembuat atau pelaksana tugas.';

  @override
  String get chatInputHint => 'Tulis pesan...';

  @override
  String get chatAttachImage => 'Kirim gambar';

  @override
  String get chatImageFailed => 'Gagal mengirim gambar';

  @override
  String get chatMonitorTitle => 'Riwayat Chat';

  @override
  String get chatMonitorEmpty => 'Belum ada pesan chat untuk pesanan ini.';

  @override
  String get chatMessageImage => '[Gambar]';

  @override
  String get chatSectionTitle => 'Komunikasi';

  @override
  String get chatUnavailableDraft =>
      'Chat tersedia setelah tugas dipublikasikan dan diambil pelaksana.';

  @override
  String get chatUnavailablePublished =>
      'Chat tersedia setelah pelaksana mengambil tugas ini.';

  @override
  String get chatUnavailableCancelled =>
      'Chat tidak tersedia karena pesanan dibatalkan.';

  @override
  String get chatUnavailableExpired =>
      'Chat tidak tersedia karena pesanan kedaluwarsa.';

  @override
  String get orderNumber => 'Nomor';

  @override
  String get title => 'Judul';

  @override
  String get reward => 'Imbalan';

  @override
  String rewardAmountValue(String amount) {
    return 'Rp $amount';
  }

  @override
  String get involvedParties => 'Pihak Terlibat';

  @override
  String get creator => 'Pembuat';

  @override
  String get executor => 'Pelaksana';

  @override
  String get noExecutorYet => 'Belum ada';

  @override
  String get yourRole => 'Peran Anda';

  @override
  String get cancelReason => 'Alasan Batal';

  @override
  String get commentOptional => 'Komentar (opsional)';

  @override
  String get submitRating => 'Kirim Penilaian';

  @override
  String get loadingProfile => 'Memuat profil...';

  @override
  String get editProfile => 'Edit Profil';

  @override
  String get phoneNumber => 'Nomor telepon';

  @override
  String get profileUpdated => 'Profil berhasil diperbarui';

  @override
  String get myAccount => 'Akun Saya';

  @override
  String get statistics => 'Statistik';

  @override
  String publishFeeStat(int fee) {
    return 'Biaya publikasi: $fee koin';
  }

  @override
  String taskRewardStat(int coins) {
    return 'Reward selesai tugas: +$coins koin';
  }

  @override
  String reputationPerTask(int points) {
    return 'Reputasi per tugas: +$points poin';
  }

  @override
  String completedTasksStat(int count) {
    return 'Tugas selesai: $count';
  }

  @override
  String lastCheckinStat(String date) {
    return 'Check-in terakhir: $date';
  }

  @override
  String get coinHistory => 'Riwayat Koin';

  @override
  String get noTransactions => 'Belum ada transaksi';

  @override
  String get notifications => 'Notifikasi';

  @override
  String markRead(int count) {
    return 'Tandai dibaca ($count)';
  }

  @override
  String get noNotifications => 'Belum ada notifikasi';

  @override
  String loadCoinsProfileFailed(String error) {
    return 'Gagal memuat koin: $error';
  }

  @override
  String get serverConnectFailed =>
      'Gagal terhubung ke server. Pastikan backend berjalan.';

  @override
  String get loadingCoinsReputation => 'Memuat koin & reputasi...';

  @override
  String get lowReputationTitle => 'Reputasi Terlalu Rendah';

  @override
  String get abandonTask => 'Lepas tugas';

  @override
  String get cancelOrder => 'Batalkan pesanan';

  @override
  String get abandonWarning => 'Melepas tugas akan menurunkan reputasi Anda.';

  @override
  String get abandonReasonOptional => 'Alasan melepas tugas (opsional)';

  @override
  String get cancelReasonOptional => 'Alasan pembatalan (opsional)';

  @override
  String get actionPublish => 'Publikasikan';

  @override
  String get actionCancel => 'Batalkan';

  @override
  String get actionTake => 'Ambil Tugas';

  @override
  String get actionStart => 'Mulai Kerjakan';

  @override
  String get actionSubmit => 'Ajukan Selesai';

  @override
  String get actionConfirm => 'Konfirmasi Selesai';

  @override
  String get actionAbandon => 'Lepas Tugas';

  @override
  String actionPublishMessage(int fee) {
    return 'Publikasikan tugas ke marketplace? Biaya publikasi: $fee koin tembaga.';
  }

  @override
  String get actionCancelMessage => 'Batalkan pesanan ini?';

  @override
  String get actionTakeMessage =>
      'Ambil tugas ini dan kerjakan sebagai pelaksana?';

  @override
  String get actionStartMessage => 'Mulai mengerjakan tugas ini?';

  @override
  String get actionSubmitMessage =>
      'Ajukan tugas selesai? Pembuat tugas perlu mengonfirmasi sebelum reward diberikan.';

  @override
  String actionConfirmMessage(int coins, int rep) {
    return 'Konfirmasi tugas selesai? Pelaksana mendapat +$coins koin dan +$rep reputasi.';
  }

  @override
  String get actionAbandonMessage =>
      'Lepas tugas ini? Reputasi Anda akan menurun.';

  @override
  String successPublished(String title, int fee) {
    return 'Tugas \"$title\" dipublikasikan (-$fee koin)';
  }

  @override
  String get successCancelled => 'Pesanan dibatalkan';

  @override
  String successTaken(String title) {
    return 'Tugas \"$title\" berhasil diambil';
  }

  @override
  String get successStarted => 'Tugas mulai dikerjakan';

  @override
  String get successSubmitted =>
      'Pengajuan selesai terkirim. Menunggu konfirmasi pembuat tugas.';

  @override
  String get successConfirmed =>
      'Tugas dikonfirmasi selesai. Reward diberikan ke pelaksana.';

  @override
  String successCompleted(int coins, int rep) {
    return 'Tugas selesai! +$coins koin, +$rep reputasi';
  }

  @override
  String get successAbandoned => 'Tugas dilepas. Reputasi berkurang.';

  @override
  String reputationBlockedMessage(int score, int min) {
    return 'Reputasi Anda ($score) di bawah minimum $min poin. Selesaikan tugas dengan baik atau check-in harian untuk memulihkan reputasi.';
  }

  @override
  String publishBlockedMessage(
    int current,
    int fee,
    int dailyReward,
    int taskReward,
  ) {
    return 'Koin tembaga tidak cukup ($current/$fee). Check-in harian (+$dailyReward koin) atau selesaikan tugas (+$taskReward koin).';
  }

  @override
  String get roleCreatorAndExecutor => 'Pembuat & Pelaksana';

  @override
  String get roleCreator => 'Pembuat tugas';

  @override
  String get roleExecutor => 'Pelaksana';

  @override
  String get language => 'Bahasa';

  @override
  String get languageId => 'Bahasa Indonesia';

  @override
  String get languageZh => '中文 (简体)';

  @override
  String get appearance => 'Tampilan';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeModeHint =>
      'Pilih mode terang, gelap, atau ikuti pengaturan perangkat.';

  @override
  String get txRegisterBonus => 'Bonus Registrasi';

  @override
  String get txDailyCheckin => 'Check-in Harian';

  @override
  String get txPublishFee => 'Biaya Publikasi Tugas';

  @override
  String get txTaskReward => 'Reward Menyelesaikan Tugas';

  @override
  String get txAdminAdjust => 'Penyesuaian Admin';

  @override
  String get notifOrderTakenTitle => 'Tugas diambil';

  @override
  String get notifOrderSubmittedTitle => 'Pengajuan selesai';

  @override
  String get notifOrderCompletedTitle => 'Tugas selesai';

  @override
  String get notifRewardTitle => 'Reward diterima';

  @override
  String get notifOrderRatedTitle => 'Penilaian diterima';

  @override
  String notifOrderTakenContent(String title) {
    return 'Tugas \"$title\" telah diambil pelaksana.';
  }

  @override
  String notifOrderSubmittedContent(String title) {
    return 'Pelaksana mengajukan penyelesaian tugas \"$title\". Silakan konfirmasi.';
  }

  @override
  String notifOrderCompletedContent(String title) {
    return 'Tugas \"$title\" selesai. Silakan beri penilaian.';
  }

  @override
  String notifRewardContent(int coins, int rep) {
    return 'Anda mendapat +$coins koin dan +$rep reputasi.';
  }

  @override
  String notifOrderRatedContent(String title, int score) {
    return 'Pembuat tugas memberi skor $score/5 untuk tugas \"$title\".';
  }

  @override
  String get sessionExpired => 'Sesi login habis, silakan masuk kembali';

  @override
  String get invalidResponse => 'Respons server tidak valid';

  @override
  String get requestFailed => 'Permintaan gagal';
}
