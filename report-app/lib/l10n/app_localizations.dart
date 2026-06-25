import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_id.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('id'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In id, this message translates to:
  /// **'Backpacker'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Marketplace Jasa On-Demand'**
  String get appSubtitle;

  /// No description provided for @appConcept.
  ///
  /// In id, this message translates to:
  /// **'Platform penghubung pembuat tugas dan pelaksana jasa mikro'**
  String get appConcept;

  /// No description provided for @welcomeHello.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}!'**
  String welcomeHello(String name);

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Backpacker'**
  String get loginTitle;

  /// No description provided for @loginTagline.
  ///
  /// In id, this message translates to:
  /// **'Marketplace Jasa On-Demand'**
  String get loginTagline;

  /// No description provided for @loginDescription.
  ///
  /// In id, this message translates to:
  /// **'Masuk untuk melihat tugas backpacker lain, mempublikasikan tugas sendiri, mengelola koin tembaga, dan memantau reputasi Anda.'**
  String get loginDescription;

  /// No description provided for @captchaHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode verifikasi pada gambar untuk keamanan akun.'**
  String get captchaHint;

  /// No description provided for @username.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get username;

  /// No description provided for @password.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi'**
  String get password;

  /// No description provided for @captcha.
  ///
  /// In id, this message translates to:
  /// **'Kode verifikasi'**
  String get captcha;

  /// No description provided for @remember.
  ///
  /// In id, this message translates to:
  /// **'Ingat kata sandi'**
  String get remember;

  /// No description provided for @submit.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get submit;

  /// No description provided for @submitting.
  ///
  /// In id, this message translates to:
  /// **'Masuk...'**
  String get submitting;

  /// No description provided for @registerLink.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? Daftar sekarang'**
  String get registerLink;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In id, this message translates to:
  /// **'Lupa password?'**
  String get forgotPasswordLink;

  /// No description provided for @usernameRequired.
  ///
  /// In id, this message translates to:
  /// **'Masukkan akun Anda'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi Anda'**
  String get passwordRequired;

  /// No description provided for @captchaRequired.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode verifikasi'**
  String get captchaRequired;

  /// No description provided for @captchaLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat kode verifikasi. Pastikan backend berjalan, lalu ketuk gambar untuk coba lagi.'**
  String get captchaLoadFailed;

  /// No description provided for @captchaNotReady.
  ///
  /// In id, this message translates to:
  /// **'Kode verifikasi belum siap. Ketuk gambar untuk memuat ulang.'**
  String get captchaNotReady;

  /// No description provided for @registerTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar Backpacker'**
  String get registerTitle;

  /// No description provided for @registerTagline.
  ///
  /// In id, this message translates to:
  /// **'Gabung marketplace jasa on-demand'**
  String get registerTagline;

  /// No description provided for @registerDescription.
  ///
  /// In id, this message translates to:
  /// **'Daftar sebagai backpacker untuk melihat dan menerima tugas, serta mempublikasikan tugas sendiri dengan koin tembaga.'**
  String get registerDescription;

  /// No description provided for @registerSubmit.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerSubmit;

  /// No description provided for @registerSuccess.
  ///
  /// In id, this message translates to:
  /// **'Registrasi berhasil. Silakan masuk.'**
  String get registerSuccess;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? Masuk'**
  String get alreadyHaveAccount;

  /// No description provided for @displayName.
  ///
  /// In id, this message translates to:
  /// **'Nama tampilan'**
  String get displayName;

  /// No description provided for @phoneOptional.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon (opsional)'**
  String get phoneOptional;

  /// No description provided for @minChars2.
  ///
  /// In id, this message translates to:
  /// **'Minimal 2 karakter'**
  String get minChars2;

  /// No description provided for @minChars5.
  ///
  /// In id, this message translates to:
  /// **'Minimal 5 karakter'**
  String get minChars5;

  /// No description provided for @maxChars20.
  ///
  /// In id, this message translates to:
  /// **'Maksimal 20 karakter'**
  String get maxChars20;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In id, this message translates to:
  /// **'Lupa Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordTagline.
  ///
  /// In id, this message translates to:
  /// **'Backpacker'**
  String get forgotPasswordTagline;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi dengan username dan nomor telepon yang terdaftar.'**
  String get forgotPasswordDescription;

  /// No description provided for @registeredPhone.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon terdaftar'**
  String get registeredPhone;

  /// No description provided for @newPassword.
  ///
  /// In id, this message translates to:
  /// **'Password baru'**
  String get newPassword;

  /// No description provided for @resetPassword.
  ///
  /// In id, this message translates to:
  /// **'Atur Ulang Password'**
  String get resetPassword;

  /// No description provided for @backToLogin.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke login'**
  String get backToLogin;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In id, this message translates to:
  /// **'Password berhasil diatur ulang. Silakan masuk.'**
  String get passwordResetSuccess;

  /// No description provided for @footer.
  ///
  /// In id, this message translates to:
  /// **'Copyright © 2026 Backpacker. All Rights Reserved.'**
  String get footer;

  /// No description provided for @tabAvailable.
  ///
  /// In id, this message translates to:
  /// **'Ambil'**
  String get tabAvailable;

  /// No description provided for @tabMine.
  ///
  /// In id, this message translates to:
  /// **'Saya'**
  String get tabMine;

  /// No description provided for @tabCreate.
  ///
  /// In id, this message translates to:
  /// **'Buat'**
  String get tabCreate;

  /// No description provided for @tabProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get tabProfile;

  /// No description provided for @roleOverviewTitle.
  ///
  /// In id, this message translates to:
  /// **'Dua Peran di Backpacker'**
  String get roleOverviewTitle;

  /// No description provided for @roleCreatorTitle.
  ///
  /// In id, this message translates to:
  /// **'Pembuat Tugas'**
  String get roleCreatorTitle;

  /// No description provided for @roleCreatorDesc.
  ///
  /// In id, this message translates to:
  /// **'Buat tugas, berikan ke marketplace, dan pantau pelaksana.'**
  String get roleCreatorDesc;

  /// No description provided for @roleExecutorTitle.
  ///
  /// In id, this message translates to:
  /// **'Pelaksana Tugas'**
  String get roleExecutorTitle;

  /// No description provided for @roleExecutorDesc.
  ///
  /// In id, this message translates to:
  /// **'Ambil tugas orang lain, kerjakan, dan dapat koin & reputasi.'**
  String get roleExecutorDesc;

  /// No description provided for @takeTabHeader.
  ///
  /// In id, this message translates to:
  /// **'Marketplace Tugas'**
  String get takeTabHeader;

  /// No description provided for @takeTabSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Sebagai pelaksana — ambil tugas yang dibuat pembuat lain.'**
  String get takeTabSubtitle;

  /// No description provided for @createTabHeader.
  ///
  /// In id, this message translates to:
  /// **'Buat & Berikan Tugas'**
  String get createTabHeader;

  /// No description provided for @createTabSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Sebagai pembuat — isi detail tugas lalu publikasikan ke marketplace.'**
  String get createTabSubtitle;

  /// No description provided for @myTasksHeader.
  ///
  /// In id, this message translates to:
  /// **'Tugas Saya'**
  String get myTasksHeader;

  /// No description provided for @myTasksSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tugas yang Anda buat (pembuat) dan yang Anda kerjakan (pelaksana).'**
  String get myTasksSubtitle;

  /// No description provided for @flowStepCreate.
  ///
  /// In id, this message translates to:
  /// **'1. Buat tugas'**
  String get flowStepCreate;

  /// No description provided for @flowStepGive.
  ///
  /// In id, this message translates to:
  /// **'2. Berikan ke marketplace'**
  String get flowStepGive;

  /// No description provided for @flowStepTake.
  ///
  /// In id, this message translates to:
  /// **'3. Pelaksana ambil tugas'**
  String get flowStepTake;

  /// No description provided for @flowStepComplete.
  ///
  /// In id, this message translates to:
  /// **'4. Selesai & dapat reward'**
  String get flowStepComplete;

  /// No description provided for @giveTaskAction.
  ///
  /// In id, this message translates to:
  /// **'Berikan Tugas'**
  String get giveTaskAction;

  /// No description provided for @takeTaskAction.
  ///
  /// In id, this message translates to:
  /// **'Ambil Tugas'**
  String get takeTaskAction;

  /// No description provided for @copperCoins.
  ///
  /// In id, this message translates to:
  /// **'Koin Tembaga'**
  String get copperCoins;

  /// No description provided for @checkin.
  ///
  /// In id, this message translates to:
  /// **'Check-in'**
  String get checkin;

  /// No description provided for @checkinDone.
  ///
  /// In id, this message translates to:
  /// **'Sudah check-in'**
  String get checkinDone;

  /// No description provided for @checkinScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Check-in Harian'**
  String get checkinScreenTitle;

  /// No description provided for @checkinScreenSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Dapatkan {coins} koin tembaga setiap hari saat check-in'**
  String checkinScreenSubtitle(int coins);

  /// No description provided for @checkinScreenPrompt.
  ///
  /// In id, this message translates to:
  /// **'Ketuk tombol di bawah untuk check-in hari ini. Check-in berikutnya tersedia besok.'**
  String get checkinScreenPrompt;

  /// No description provided for @checkinScreenAction.
  ///
  /// In id, this message translates to:
  /// **'Check-in Sekarang'**
  String get checkinScreenAction;

  /// No description provided for @checkinScreenRewardHint.
  ///
  /// In id, this message translates to:
  /// **'Reward hari ini: +{coins} koin tembaga'**
  String checkinScreenRewardHint(int coins);

  /// No description provided for @checkinScreenAlreadyDone.
  ///
  /// In id, this message translates to:
  /// **'Anda sudah check-in hari ini. Kembali besok untuk check-in berikutnya.'**
  String get checkinScreenAlreadyDone;

  /// No description provided for @checkinScreenSuccessHint.
  ///
  /// In id, this message translates to:
  /// **'Check-in berhasil untuk hari ini. Kembali besok untuk check-in berikutnya.'**
  String get checkinScreenSuccessHint;

  /// No description provided for @checkinContinueHome.
  ///
  /// In id, this message translates to:
  /// **'Lanjut ke Beranda'**
  String get checkinContinueHome;

  /// No description provided for @publishFeeHint.
  ///
  /// In id, this message translates to:
  /// **'Biaya publikasi: {fee} koin tembaga'**
  String publishFeeHint(int fee);

  /// No description provided for @publishInsufficient.
  ///
  /// In id, this message translates to:
  /// **'Koin tidak cukup. Dapatkan koin lewat check-in harian atau menyelesaikan tugas.'**
  String get publishInsufficient;

  /// No description provided for @reputation.
  ///
  /// In id, this message translates to:
  /// **'Reputasi'**
  String get reputation;

  /// No description provided for @reputationMinHint.
  ///
  /// In id, this message translates to:
  /// **'Minimum reputasi untuk ambil tugas: {min} poin'**
  String reputationMinHint(int min);

  /// No description provided for @rateTask.
  ///
  /// In id, this message translates to:
  /// **'Beri Penilaian'**
  String get rateTask;

  /// No description provided for @rateSubmitted.
  ///
  /// In id, this message translates to:
  /// **'Penilaian berhasil disimpan'**
  String get rateSubmitted;

  /// No description provided for @ratePrompt.
  ///
  /// In id, this message translates to:
  /// **'Pelaksana sudah menyelesaikan tugas ini. Beri penilaian 1–5 bintang untuk hasil kerjanya.'**
  String get ratePrompt;

  /// No description provided for @rateNow.
  ///
  /// In id, this message translates to:
  /// **'Nilai Sekarang'**
  String get rateNow;

  /// No description provided for @rateExecutorHint.
  ///
  /// In id, this message translates to:
  /// **'Penilaian mempengaruhi reputasi pelaksana.'**
  String get rateExecutorHint;

  /// No description provided for @ratingLabel.
  ///
  /// In id, this message translates to:
  /// **'Penilaian Pelaksana'**
  String get ratingLabel;

  /// No description provided for @needsRating.
  ///
  /// In id, this message translates to:
  /// **'Perlu dinilai'**
  String get needsRating;

  /// No description provided for @filterAllStatus.
  ///
  /// In id, this message translates to:
  /// **'Semua status'**
  String get filterAllStatus;

  /// No description provided for @filterNeedsRating.
  ///
  /// In id, this message translates to:
  /// **'Perlu dinilai'**
  String get filterNeedsRating;

  /// No description provided for @filterDraft.
  ///
  /// In id, this message translates to:
  /// **'Draft'**
  String get filterDraft;

  /// No description provided for @filterActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get filterActive;

  /// No description provided for @filterCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get filterCompleted;

  /// No description provided for @timelineTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Status'**
  String get timelineTitle;

  /// No description provided for @timelineEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada riwayat status.'**
  String get timelineEmpty;

  /// No description provided for @timelineCreated.
  ///
  /// In id, this message translates to:
  /// **'Tugas dibuat'**
  String get timelineCreated;

  /// No description provided for @editDraft.
  ///
  /// In id, this message translates to:
  /// **'Edit Draft'**
  String get editDraft;

  /// No description provided for @draftUpdated.
  ///
  /// In id, this message translates to:
  /// **'Draft tugas berhasil diperbarui'**
  String get draftUpdated;

  /// No description provided for @reputationHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Reputasi'**
  String get reputationHistory;

  /// No description provided for @reputationHistoryEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada perubahan reputasi.'**
  String get reputationHistoryEmpty;

  /// No description provided for @markAllRead.
  ///
  /// In id, this message translates to:
  /// **'Tandai semua dibaca'**
  String get markAllRead;

  /// No description provided for @repTaskComplete.
  ///
  /// In id, this message translates to:
  /// **'Tugas diselesaikan'**
  String get repTaskComplete;

  /// No description provided for @repGoodRating.
  ///
  /// In id, this message translates to:
  /// **'Penilaian bagus'**
  String get repGoodRating;

  /// No description provided for @repBadRating.
  ///
  /// In id, this message translates to:
  /// **'Penilaian buruk'**
  String get repBadRating;

  /// No description provided for @repTaskFailed.
  ///
  /// In id, this message translates to:
  /// **'Tugas gagal / dilepas'**
  String get repTaskFailed;

  /// No description provided for @repAdminAdjust.
  ///
  /// In id, this message translates to:
  /// **'Penyesuaian admin'**
  String get repAdminAdjust;

  /// No description provided for @rulesTitle.
  ///
  /// In id, this message translates to:
  /// **'Alur Pembuatan & Pemberian Tugas'**
  String get rulesTitle;

  /// No description provided for @rulesCoins.
  ///
  /// In id, this message translates to:
  /// **'Pembuat tugas: gunakan koin tembaga untuk mempublikasikan tugas. Pelaksana: dapat koin dari check-in harian dan menyelesaikan tugas.'**
  String get rulesCoins;

  /// No description provided for @rulesReputation.
  ///
  /// In id, this message translates to:
  /// **'Pelaksana mendapat reputasi saat menyelesaikan tugas. Reputasi turun jika gagal/lepas tugas atau dapat penilaian buruk.'**
  String get rulesReputation;

  /// No description provided for @rulesBlock.
  ///
  /// In id, this message translates to:
  /// **'Pelaksana dengan reputasi di bawah batas minimum tidak bisa mengambil tugas baru.'**
  String get rulesBlock;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @refresh.
  ///
  /// In id, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @understand.
  ///
  /// In id, this message translates to:
  /// **'Mengerti'**
  String get understand;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get loading;

  /// No description provided for @loadCoinsFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data koin: {error}'**
  String loadCoinsFailed(String error);

  /// No description provided for @checkinSuccess.
  ///
  /// In id, this message translates to:
  /// **'Check-in berhasil! +{coins} koin'**
  String checkinSuccess(int coins);

  /// No description provided for @loadAvailableTasksFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat tugas tersedia'**
  String get loadAvailableTasksFailed;

  /// No description provided for @loadingAvailableTasks.
  ///
  /// In id, this message translates to:
  /// **'Memuat tugas tersedia...'**
  String get loadingAvailableTasks;

  /// No description provided for @searchTaskHint.
  ///
  /// In id, this message translates to:
  /// **'Cari judul tugas...'**
  String get searchTaskHint;

  /// No description provided for @category.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @all.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get all;

  /// No description provided for @statusDraft.
  ///
  /// In id, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusPublished.
  ///
  /// In id, this message translates to:
  /// **'Dipublikasikan'**
  String get statusPublished;

  /// No description provided for @statusTaken.
  ///
  /// In id, this message translates to:
  /// **'Diambil'**
  String get statusTaken;

  /// No description provided for @statusInProgress.
  ///
  /// In id, this message translates to:
  /// **'Dikerjakan'**
  String get statusInProgress;

  /// No description provided for @statusSubmitted.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Konfirmasi'**
  String get statusSubmitted;

  /// No description provided for @statusCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get statusCancelled;

  /// No description provided for @statusExpired.
  ///
  /// In id, this message translates to:
  /// **'Kedaluwarsa'**
  String get statusExpired;

  /// No description provided for @categoryGeneral.
  ///
  /// In id, this message translates to:
  /// **'Umum'**
  String get categoryGeneral;

  /// No description provided for @categoryDelivery.
  ///
  /// In id, this message translates to:
  /// **'Antar Barang'**
  String get categoryDelivery;

  /// No description provided for @categoryDeliveryShort.
  ///
  /// In id, this message translates to:
  /// **'Antar'**
  String get categoryDeliveryShort;

  /// No description provided for @categoryHelper.
  ///
  /// In id, this message translates to:
  /// **'Bantuan'**
  String get categoryHelper;

  /// No description provided for @categoryTech.
  ///
  /// In id, this message translates to:
  /// **'Teknisi'**
  String get categoryTech;

  /// No description provided for @categoryErrands.
  ///
  /// In id, this message translates to:
  /// **'Belanja / Errands'**
  String get categoryErrands;

  /// No description provided for @noAvailableTasks.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tugas tersedia'**
  String get noAvailableTasks;

  /// No description provided for @noAvailableTasksSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pembuat tugas lain belum mempublikasikan tugas. Coba buat & berikan tugas sendiri.'**
  String get noAvailableTasksSubtitle;

  /// No description provided for @scopeAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get scopeAll;

  /// No description provided for @scopeCreated.
  ///
  /// In id, this message translates to:
  /// **'Tugas Saya Buat'**
  String get scopeCreated;

  /// No description provided for @scopeExecuting.
  ///
  /// In id, this message translates to:
  /// **'Tugas Saya Kerjakan'**
  String get scopeExecuting;

  /// No description provided for @needsRatingBanner.
  ///
  /// In id, this message translates to:
  /// **'{count} tugas selesai perlu dinilai. Penilaian buruk menurunkan reputasi pelaksana.'**
  String needsRatingBanner(int count);

  /// No description provided for @loadingOrders.
  ///
  /// In id, this message translates to:
  /// **'Memuat pesanan...'**
  String get loadingOrders;

  /// No description provided for @noOrders.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pesanan'**
  String get noOrders;

  /// No description provided for @noOrdersSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tugas yang Anda buat atau kerjakan sebagai pelaksana akan muncul di sini.'**
  String get noOrdersSubtitle;

  /// No description provided for @taskCreatedPublished.
  ///
  /// In id, this message translates to:
  /// **'Tugas berhasil dibuat dan dipublikasikan'**
  String get taskCreatedPublished;

  /// No description provided for @taskDraftSaved.
  ///
  /// In id, this message translates to:
  /// **'Draft tugas berhasil disimpan'**
  String get taskDraftSaved;

  /// No description provided for @createTaskFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat tugas'**
  String get createTaskFailed;

  /// No description provided for @taskInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi Tugas'**
  String get taskInfo;

  /// No description provided for @taskTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tugas'**
  String get taskTitle;

  /// No description provided for @description.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get description;

  /// No description provided for @requiredField.
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In id, this message translates to:
  /// **'Angka tidak valid'**
  String get invalidNumber;

  /// No description provided for @serviceDetails.
  ///
  /// In id, this message translates to:
  /// **'Detail Layanan'**
  String get serviceDetails;

  /// No description provided for @rewardLabel.
  ///
  /// In id, this message translates to:
  /// **'Imbalan (Rp)'**
  String get rewardLabel;

  /// No description provided for @location.
  ///
  /// In id, this message translates to:
  /// **'Lokasi'**
  String get location;

  /// No description provided for @publication.
  ///
  /// In id, this message translates to:
  /// **'Publikasi'**
  String get publication;

  /// No description provided for @publishImmediately.
  ///
  /// In id, this message translates to:
  /// **'Langsung publikasikan'**
  String get publishImmediately;

  /// No description provided for @publishImmediatelyHint.
  ///
  /// In id, this message translates to:
  /// **'Nonaktifkan untuk simpan sebagai draft dulu'**
  String get publishImmediatelyHint;

  /// No description provided for @createAndPublish.
  ///
  /// In id, this message translates to:
  /// **'Buat & Publish'**
  String get createAndPublish;

  /// No description provided for @saveDraft.
  ///
  /// In id, this message translates to:
  /// **'Simpan Draft'**
  String get saveDraft;

  /// No description provided for @orderDetail.
  ///
  /// In id, this message translates to:
  /// **'Detail Pesanan'**
  String get orderDetail;

  /// No description provided for @loadingOrderDetail.
  ///
  /// In id, this message translates to:
  /// **'Memuat detail pesanan...'**
  String get loadingOrderDetail;

  /// No description provided for @orderNotFound.
  ///
  /// In id, this message translates to:
  /// **'Pesanan tidak ditemukan'**
  String get orderNotFound;

  /// No description provided for @openChat.
  ///
  /// In id, this message translates to:
  /// **'Chat dengan Lawan Tugas'**
  String get openChat;

  /// No description provided for @orderChatTitle.
  ///
  /// In id, this message translates to:
  /// **'Chat Pesanan'**
  String get orderChatTitle;

  /// No description provided for @loadingChat.
  ///
  /// In id, this message translates to:
  /// **'Memuat chat...'**
  String get loadingChat;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pesan'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Mulai percakapan dengan pembuat atau pelaksana tugas.'**
  String get chatEmptySubtitle;

  /// No description provided for @chatInputHint.
  ///
  /// In id, this message translates to:
  /// **'Tulis pesan...'**
  String get chatInputHint;

  /// No description provided for @chatAttachImage.
  ///
  /// In id, this message translates to:
  /// **'Kirim gambar'**
  String get chatAttachImage;

  /// No description provided for @chatImageFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim gambar'**
  String get chatImageFailed;

  /// No description provided for @chatMonitorTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Chat'**
  String get chatMonitorTitle;

  /// No description provided for @chatMonitorEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pesan chat untuk pesanan ini.'**
  String get chatMonitorEmpty;

  /// No description provided for @chatMessageImage.
  ///
  /// In id, this message translates to:
  /// **'[Gambar]'**
  String get chatMessageImage;

  /// No description provided for @chatSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Komunikasi'**
  String get chatSectionTitle;

  /// No description provided for @chatUnavailableDraft.
  ///
  /// In id, this message translates to:
  /// **'Chat tersedia setelah tugas dipublikasikan dan diambil pelaksana.'**
  String get chatUnavailableDraft;

  /// No description provided for @chatUnavailablePublished.
  ///
  /// In id, this message translates to:
  /// **'Chat tersedia setelah pelaksana mengambil tugas ini.'**
  String get chatUnavailablePublished;

  /// No description provided for @chatUnavailableCancelled.
  ///
  /// In id, this message translates to:
  /// **'Chat tidak tersedia karena pesanan dibatalkan.'**
  String get chatUnavailableCancelled;

  /// No description provided for @chatUnavailableExpired.
  ///
  /// In id, this message translates to:
  /// **'Chat tidak tersedia karena pesanan kedaluwarsa.'**
  String get chatUnavailableExpired;

  /// No description provided for @orderNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor'**
  String get orderNumber;

  /// No description provided for @title.
  ///
  /// In id, this message translates to:
  /// **'Judul'**
  String get title;

  /// No description provided for @reward.
  ///
  /// In id, this message translates to:
  /// **'Imbalan'**
  String get reward;

  /// No description provided for @rewardAmountValue.
  ///
  /// In id, this message translates to:
  /// **'Rp {amount}'**
  String rewardAmountValue(String amount);

  /// No description provided for @involvedParties.
  ///
  /// In id, this message translates to:
  /// **'Pihak Terlibat'**
  String get involvedParties;

  /// No description provided for @creator.
  ///
  /// In id, this message translates to:
  /// **'Pembuat'**
  String get creator;

  /// No description provided for @executor.
  ///
  /// In id, this message translates to:
  /// **'Pelaksana'**
  String get executor;

  /// No description provided for @noExecutorYet.
  ///
  /// In id, this message translates to:
  /// **'Belum ada'**
  String get noExecutorYet;

  /// No description provided for @yourRole.
  ///
  /// In id, this message translates to:
  /// **'Peran Anda'**
  String get yourRole;

  /// No description provided for @cancelReason.
  ///
  /// In id, this message translates to:
  /// **'Alasan Batal'**
  String get cancelReason;

  /// No description provided for @commentOptional.
  ///
  /// In id, this message translates to:
  /// **'Komentar (opsional)'**
  String get commentOptional;

  /// No description provided for @submitRating.
  ///
  /// In id, this message translates to:
  /// **'Kirim Penilaian'**
  String get submitRating;

  /// No description provided for @loadingProfile.
  ///
  /// In id, this message translates to:
  /// **'Memuat profil...'**
  String get loadingProfile;

  /// No description provided for @editProfile.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get editProfile;

  /// No description provided for @phoneNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon'**
  String get phoneNumber;

  /// No description provided for @profileUpdated.
  ///
  /// In id, this message translates to:
  /// **'Profil berhasil diperbarui'**
  String get profileUpdated;

  /// No description provided for @myAccount.
  ///
  /// In id, this message translates to:
  /// **'Akun Saya'**
  String get myAccount;

  /// No description provided for @statistics.
  ///
  /// In id, this message translates to:
  /// **'Statistik'**
  String get statistics;

  /// No description provided for @publishFeeStat.
  ///
  /// In id, this message translates to:
  /// **'Biaya publikasi: {fee} koin'**
  String publishFeeStat(int fee);

  /// No description provided for @taskRewardStat.
  ///
  /// In id, this message translates to:
  /// **'Reward selesai tugas: +{coins} koin'**
  String taskRewardStat(int coins);

  /// No description provided for @reputationPerTask.
  ///
  /// In id, this message translates to:
  /// **'Reputasi per tugas: +{points} poin'**
  String reputationPerTask(int points);

  /// No description provided for @completedTasksStat.
  ///
  /// In id, this message translates to:
  /// **'Tugas selesai: {count}'**
  String completedTasksStat(int count);

  /// No description provided for @lastCheckinStat.
  ///
  /// In id, this message translates to:
  /// **'Check-in terakhir: {date}'**
  String lastCheckinStat(String date);

  /// No description provided for @coinHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Koin'**
  String get coinHistory;

  /// No description provided for @noTransactions.
  ///
  /// In id, this message translates to:
  /// **'Belum ada transaksi'**
  String get noTransactions;

  /// No description provided for @notifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notifications;

  /// No description provided for @markRead.
  ///
  /// In id, this message translates to:
  /// **'Tandai dibaca ({count})'**
  String markRead(int count);

  /// No description provided for @noNotifications.
  ///
  /// In id, this message translates to:
  /// **'Belum ada notifikasi'**
  String get noNotifications;

  /// No description provided for @loadCoinsProfileFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat koin: {error}'**
  String loadCoinsProfileFailed(String error);

  /// No description provided for @serverConnectFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal terhubung ke server. Pastikan backend berjalan.'**
  String get serverConnectFailed;

  /// No description provided for @loadingCoinsReputation.
  ///
  /// In id, this message translates to:
  /// **'Memuat koin & reputasi...'**
  String get loadingCoinsReputation;

  /// No description provided for @lowReputationTitle.
  ///
  /// In id, this message translates to:
  /// **'Reputasi Terlalu Rendah'**
  String get lowReputationTitle;

  /// No description provided for @abandonTask.
  ///
  /// In id, this message translates to:
  /// **'Lepas tugas'**
  String get abandonTask;

  /// No description provided for @cancelOrder.
  ///
  /// In id, this message translates to:
  /// **'Batalkan pesanan'**
  String get cancelOrder;

  /// No description provided for @abandonWarning.
  ///
  /// In id, this message translates to:
  /// **'Melepas tugas akan menurunkan reputasi Anda.'**
  String get abandonWarning;

  /// No description provided for @abandonReasonOptional.
  ///
  /// In id, this message translates to:
  /// **'Alasan melepas tugas (opsional)'**
  String get abandonReasonOptional;

  /// No description provided for @cancelReasonOptional.
  ///
  /// In id, this message translates to:
  /// **'Alasan pembatalan (opsional)'**
  String get cancelReasonOptional;

  /// No description provided for @actionPublish.
  ///
  /// In id, this message translates to:
  /// **'Publikasikan'**
  String get actionPublish;

  /// No description provided for @actionCancel.
  ///
  /// In id, this message translates to:
  /// **'Batalkan'**
  String get actionCancel;

  /// No description provided for @actionTake.
  ///
  /// In id, this message translates to:
  /// **'Ambil Tugas'**
  String get actionTake;

  /// No description provided for @actionStart.
  ///
  /// In id, this message translates to:
  /// **'Mulai Kerjakan'**
  String get actionStart;

  /// No description provided for @actionSubmit.
  ///
  /// In id, this message translates to:
  /// **'Ajukan Selesai'**
  String get actionSubmit;

  /// No description provided for @actionConfirm.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Selesai'**
  String get actionConfirm;

  /// No description provided for @actionAbandon.
  ///
  /// In id, this message translates to:
  /// **'Lepas Tugas'**
  String get actionAbandon;

  /// No description provided for @actionPublishMessage.
  ///
  /// In id, this message translates to:
  /// **'Publikasikan tugas ke marketplace? Biaya publikasi: {fee} koin tembaga.'**
  String actionPublishMessage(int fee);

  /// No description provided for @actionCancelMessage.
  ///
  /// In id, this message translates to:
  /// **'Batalkan pesanan ini?'**
  String get actionCancelMessage;

  /// No description provided for @actionTakeMessage.
  ///
  /// In id, this message translates to:
  /// **'Ambil tugas ini dan kerjakan sebagai pelaksana?'**
  String get actionTakeMessage;

  /// No description provided for @actionStartMessage.
  ///
  /// In id, this message translates to:
  /// **'Mulai mengerjakan tugas ini?'**
  String get actionStartMessage;

  /// No description provided for @actionSubmitMessage.
  ///
  /// In id, this message translates to:
  /// **'Ajukan tugas selesai? Pembuat tugas perlu mengonfirmasi sebelum reward diberikan.'**
  String get actionSubmitMessage;

  /// No description provided for @actionConfirmMessage.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi tugas selesai? Pelaksana mendapat +{coins} koin dan +{rep} reputasi.'**
  String actionConfirmMessage(int coins, int rep);

  /// No description provided for @actionAbandonMessage.
  ///
  /// In id, this message translates to:
  /// **'Lepas tugas ini? Reputasi Anda akan menurun.'**
  String get actionAbandonMessage;

  /// No description provided for @successPublished.
  ///
  /// In id, this message translates to:
  /// **'Tugas \"{title}\" dipublikasikan (-{fee} koin)'**
  String successPublished(String title, int fee);

  /// No description provided for @successCancelled.
  ///
  /// In id, this message translates to:
  /// **'Pesanan dibatalkan'**
  String get successCancelled;

  /// No description provided for @successTaken.
  ///
  /// In id, this message translates to:
  /// **'Tugas \"{title}\" berhasil diambil'**
  String successTaken(String title);

  /// No description provided for @successStarted.
  ///
  /// In id, this message translates to:
  /// **'Tugas mulai dikerjakan'**
  String get successStarted;

  /// No description provided for @successSubmitted.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan selesai terkirim. Menunggu konfirmasi pembuat tugas.'**
  String get successSubmitted;

  /// No description provided for @successConfirmed.
  ///
  /// In id, this message translates to:
  /// **'Tugas dikonfirmasi selesai. Reward diberikan ke pelaksana.'**
  String get successConfirmed;

  /// No description provided for @successCompleted.
  ///
  /// In id, this message translates to:
  /// **'Tugas selesai! +{coins} koin, +{rep} reputasi'**
  String successCompleted(int coins, int rep);

  /// No description provided for @successAbandoned.
  ///
  /// In id, this message translates to:
  /// **'Tugas dilepas. Reputasi berkurang.'**
  String get successAbandoned;

  /// No description provided for @reputationBlockedMessage.
  ///
  /// In id, this message translates to:
  /// **'Reputasi Anda ({score}) di bawah minimum {min} poin. Selesaikan tugas dengan baik atau check-in harian untuk memulihkan reputasi.'**
  String reputationBlockedMessage(int score, int min);

  /// No description provided for @publishBlockedMessage.
  ///
  /// In id, this message translates to:
  /// **'Koin tembaga tidak cukup ({current}/{fee}). Check-in harian (+{dailyReward} koin) atau selesaikan tugas (+{taskReward} koin).'**
  String publishBlockedMessage(
    int current,
    int fee,
    int dailyReward,
    int taskReward,
  );

  /// No description provided for @roleCreatorAndExecutor.
  ///
  /// In id, this message translates to:
  /// **'Pembuat & Pelaksana'**
  String get roleCreatorAndExecutor;

  /// No description provided for @roleCreator.
  ///
  /// In id, this message translates to:
  /// **'Pembuat tugas'**
  String get roleCreator;

  /// No description provided for @roleExecutor.
  ///
  /// In id, this message translates to:
  /// **'Pelaksana'**
  String get roleExecutor;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @languageId.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageId;

  /// No description provided for @languageZh.
  ///
  /// In id, this message translates to:
  /// **'中文 (简体)'**
  String get languageZh;

  /// No description provided for @appearance.
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In id, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeModeHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih mode terang, gelap, atau ikuti pengaturan perangkat.'**
  String get themeModeHint;

  /// No description provided for @txRegisterBonus.
  ///
  /// In id, this message translates to:
  /// **'Bonus Registrasi'**
  String get txRegisterBonus;

  /// No description provided for @txDailyCheckin.
  ///
  /// In id, this message translates to:
  /// **'Check-in Harian'**
  String get txDailyCheckin;

  /// No description provided for @txPublishFee.
  ///
  /// In id, this message translates to:
  /// **'Biaya Publikasi Tugas'**
  String get txPublishFee;

  /// No description provided for @txTaskReward.
  ///
  /// In id, this message translates to:
  /// **'Reward Menyelesaikan Tugas'**
  String get txTaskReward;

  /// No description provided for @txAdminAdjust.
  ///
  /// In id, this message translates to:
  /// **'Penyesuaian Admin'**
  String get txAdminAdjust;

  /// No description provided for @notifOrderTakenTitle.
  ///
  /// In id, this message translates to:
  /// **'Tugas diambil'**
  String get notifOrderTakenTitle;

  /// No description provided for @notifOrderSubmittedTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengajuan selesai'**
  String get notifOrderSubmittedTitle;

  /// No description provided for @notifOrderCompletedTitle.
  ///
  /// In id, this message translates to:
  /// **'Tugas selesai'**
  String get notifOrderCompletedTitle;

  /// No description provided for @notifRewardTitle.
  ///
  /// In id, this message translates to:
  /// **'Reward diterima'**
  String get notifRewardTitle;

  /// No description provided for @notifOrderRatedTitle.
  ///
  /// In id, this message translates to:
  /// **'Penilaian diterima'**
  String get notifOrderRatedTitle;

  /// No description provided for @notifOrderTakenContent.
  ///
  /// In id, this message translates to:
  /// **'Tugas \"{title}\" telah diambil pelaksana.'**
  String notifOrderTakenContent(String title);

  /// No description provided for @notifOrderSubmittedContent.
  ///
  /// In id, this message translates to:
  /// **'Pelaksana mengajukan penyelesaian tugas \"{title}\". Silakan konfirmasi.'**
  String notifOrderSubmittedContent(String title);

  /// No description provided for @notifOrderCompletedContent.
  ///
  /// In id, this message translates to:
  /// **'Tugas \"{title}\" selesai. Silakan beri penilaian.'**
  String notifOrderCompletedContent(String title);

  /// No description provided for @notifRewardContent.
  ///
  /// In id, this message translates to:
  /// **'Anda mendapat +{coins} koin dan +{rep} reputasi.'**
  String notifRewardContent(int coins, int rep);

  /// No description provided for @notifOrderRatedContent.
  ///
  /// In id, this message translates to:
  /// **'Pembuat tugas memberi skor {score}/5 untuk tugas \"{title}\".'**
  String notifOrderRatedContent(String title, int score);

  /// No description provided for @sessionExpired.
  ///
  /// In id, this message translates to:
  /// **'Sesi login habis, silakan masuk kembali'**
  String get sessionExpired;

  /// No description provided for @invalidResponse.
  ///
  /// In id, this message translates to:
  /// **'Respons server tidak valid'**
  String get invalidResponse;

  /// No description provided for @requestFailed.
  ///
  /// In id, this message translates to:
  /// **'Permintaan gagal'**
  String get requestFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['id', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'id':
      return AppLocalizationsId();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
