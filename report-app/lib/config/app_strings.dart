/// Teks tampilan selaras konsep sistem Backpacker.
class AppStrings {
  static const appName = 'Backpacker';
  static const appSubtitle = 'Marketplace Jasa On-Demand';
  static const appConcept =
      'Platform penghubung pembuat tugas dan pelaksana jasa mikro';

  static const welcomeHello = 'Halo, {name}!';

  static const loginTitle = 'Backpacker';
  static const loginTagline = 'Marketplace Jasa On-Demand';
  static const loginDescription =
      'Masuk untuk melihat tugas backpacker lain, mempublikasikan tugas sendiri, '
      'mengelola koin tembaga, dan memantau reputasi Anda.';
  static const captchaHint =
      'Masukkan kode verifikasi pada gambar untuk keamanan akun.';

  static const username = 'Akun';
  static const password = 'Kata sandi';
  static const captcha = 'Kode verifikasi';
  static const remember = 'Ingat kata sandi';
  static const submit = 'Masuk';
  static const submitting = 'Masuk...';
  static const registerLink = 'Belum punya akun? Daftar sekarang';
  static const usernameRequired = 'Masukkan akun Anda';
  static const passwordRequired = 'Masukkan kata sandi Anda';
  static const captchaRequired = 'Masukkan kode verifikasi';
  static const captchaLoadFailed =
      'Gagal memuat kode verifikasi. Pastikan backend berjalan, lalu ketuk gambar untuk coba lagi.';

  static const registerTitle = 'Daftar Backpacker';
  static const registerTagline = 'Gabung marketplace jasa on-demand';
  static const registerDescription =
      'Daftar sebagai backpacker untuk melihat dan menerima tugas, '
      'serta mempublikasikan tugas sendiri dengan koin tembaga.';
  static const registerSubmit = 'Daftar';
  static const registerSuccess = 'Registrasi berhasil. Silakan masuk.';

  static const footer = 'Copyright © 2026 Backpacker. All Rights Reserved.';

  static const tabAvailable = 'Daftar Tugas';
  static const tabMine = 'Pesanan Saya';
  static const tabCreate = 'Publish Tugas';
  static const tabProfile = 'Profil';

  static const copperCoins = 'Koin Tembaga';
  static const checkin = 'Check-in';
  static const checkinDone = 'Sudah check-in';
  static const publishFeeHint = 'Biaya publikasi: {fee} koin tembaga';
  static const publishInsufficient =
      'Koin tidak cukup. Dapatkan koin lewat check-in harian atau menyelesaikan tugas.';
  static const publishConfirm =
      'Publikasikan tugas ke marketplace? Biaya: {fee} koin tembaga.';

  static const reputation = 'Reputasi';
  static const reputationLow =
      'Reputasi Anda di bawah batas minimum. Anda tidak dapat menerima tugas baru.';
  static const reputationMinHint = 'Minimum reputasi untuk ambil tugas: {min} poin';
  static const rateTask = 'Beri Penilaian';
  static const rateSubmitted = 'Penilaian berhasil disimpan';
  static const ratingLabel = 'Penilaian Pelaksana';
  static const needsRating = 'Perlu dinilai';

  static const rulesTitle = 'Cara Kerja Backpacker';
  static const rulesCoins =
      'Koin tembaga didapat dari check-in harian dan menyelesaikan tugas orang lain. '
      'Digunakan sebagai biaya publikasi tugas.';
  static const rulesReputation =
      'Reputasi naik saat menyelesaikan tugas. Turun jika gagal/lepas tugas atau dapat penilaian buruk.';
  static const rulesBlock =
      'Jika reputasi di bawah batas minimum, Anda tidak bisa menerima tugas baru.';
}
