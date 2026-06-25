// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Backpacker';

  @override
  String get appSubtitle => '按需服务市场平台';

  @override
  String get appConcept => '连接任务发布者与微服务执行者的平台';

  @override
  String welcomeHello(String name) {
    return '你好，$name！';
  }

  @override
  String get loginTitle => 'Backpacker';

  @override
  String get loginTagline => '按需服务市场平台';

  @override
  String get loginDescription => '登录后可查看其他背包客的任务、发布自己的任务、管理铜币并跟踪信誉。';

  @override
  String get captchaHint => '请输入图片中的验证码以确保账户安全。';

  @override
  String get username => '账号';

  @override
  String get password => '密码';

  @override
  String get captcha => '验证码';

  @override
  String get remember => '记住密码';

  @override
  String get submit => '登录';

  @override
  String get submitting => '登录中...';

  @override
  String get registerLink => '还没有账号？立即注册';

  @override
  String get forgotPasswordLink => '忘记密码？';

  @override
  String get usernameRequired => '请输入账号';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get captchaRequired => '请输入验证码';

  @override
  String get captchaLoadFailed => '验证码加载失败。请确保后端已运行，然后点击图片重试。';

  @override
  String get captchaNotReady => '验证码尚未就绪，请点击图片重新加载。';

  @override
  String get registerTitle => '注册 Backpacker';

  @override
  String get registerTagline => '加入按需服务市场';

  @override
  String get registerDescription => '注册成为背包客，可查看和接受任务，并使用铜币发布自己的任务。';

  @override
  String get registerSubmit => '注册';

  @override
  String get registerSuccess => '注册成功，请登录。';

  @override
  String get alreadyHaveAccount => '已有账号？登录';

  @override
  String get displayName => '显示名称';

  @override
  String get phoneOptional => '手机号（可选）';

  @override
  String get minChars2 => '至少 2 个字符';

  @override
  String get minChars5 => '至少 5 个字符';

  @override
  String get maxChars20 => '最多 20 个字符';

  @override
  String get forgotPasswordTitle => '忘记密码';

  @override
  String get forgotPasswordTagline => 'Backpacker';

  @override
  String get forgotPasswordDescription => '使用已注册的用户名和手机号进行验证。';

  @override
  String get registeredPhone => '已注册手机号';

  @override
  String get newPassword => '新密码';

  @override
  String get resetPassword => '重置密码';

  @override
  String get backToLogin => '返回登录';

  @override
  String get passwordResetSuccess => '密码重置成功，请登录。';

  @override
  String get footer => 'Copyright © 2026 Backpacker. All Rights Reserved.';

  @override
  String get tabAvailable => '接取';

  @override
  String get tabMine => '我的';

  @override
  String get tabCreate => '创建';

  @override
  String get tabProfile => '个人资料';

  @override
  String get roleOverviewTitle => 'Backpacker 双重角色';

  @override
  String get roleCreatorTitle => '任务发布者';

  @override
  String get roleCreatorDesc => '创建任务、发布到市场，并跟踪执行者进度。';

  @override
  String get roleExecutorTitle => '任务执行者';

  @override
  String get roleExecutorDesc => '接取他人任务、完成工作，获得铜币和信誉。';

  @override
  String get takeTabHeader => '任务市场';

  @override
  String get takeTabSubtitle => '作为执行者 — 接取其他发布者创建的任务。';

  @override
  String get createTabHeader => '创建并发布任务';

  @override
  String get createTabSubtitle => '作为发布者 — 填写任务详情并发布到市场。';

  @override
  String get myTasksHeader => '我的任务';

  @override
  String get myTasksSubtitle => '您发布的任务（发布者）和您执行的任务（执行者）。';

  @override
  String get flowStepCreate => '1. 创建任务';

  @override
  String get flowStepGive => '2. 发布到市场';

  @override
  String get flowStepTake => '3. 执行者接单';

  @override
  String get flowStepComplete => '4. 完成并获得奖励';

  @override
  String get giveTaskAction => '发布任务';

  @override
  String get takeTaskAction => '接取任务';

  @override
  String get copperCoins => '铜币';

  @override
  String get checkin => '签到';

  @override
  String get checkinDone => '已签到';

  @override
  String get checkinScreenTitle => '每日签到';

  @override
  String checkinScreenSubtitle(int coins) {
    return '每日签到可获得 $coins 铜币';
  }

  @override
  String get checkinScreenPrompt => '点击下方按钮完成今日签到。下次签到请于明天进行。';

  @override
  String get checkinScreenAction => '立即签到';

  @override
  String checkinScreenRewardHint(int coins) {
    return '今日奖励：+$coins 铜币';
  }

  @override
  String get checkinScreenAlreadyDone => '您今天已经签到。请明天再来签到。';

  @override
  String get checkinScreenSuccessHint => '今日签到成功。请明天再来签到。';

  @override
  String get checkinContinueHome => '进入首页';

  @override
  String publishFeeHint(int fee) {
    return '发布费用：$fee 铜币';
  }

  @override
  String get publishInsufficient => '铜币不足。可通过每日签到或完成任务获得铜币。';

  @override
  String get reputation => '信誉';

  @override
  String reputationMinHint(int min) {
    return '接单最低信誉：$min 分';
  }

  @override
  String get rateTask => '评价任务';

  @override
  String get rateSubmitted => '评价已提交';

  @override
  String get ratePrompt => '执行者已完成此任务。请为工作成果给出 1–5 星评价。';

  @override
  String get rateNow => '立即评价';

  @override
  String get rateExecutorHint => '评价会影响执行者的信誉。';

  @override
  String get ratingLabel => '执行者评价';

  @override
  String get needsRating => '待评价';

  @override
  String get filterAllStatus => '全部状态';

  @override
  String get filterNeedsRating => '待评价';

  @override
  String get filterDraft => '草稿';

  @override
  String get filterActive => '进行中';

  @override
  String get filterCompleted => '已完成';

  @override
  String get timelineTitle => '状态记录';

  @override
  String get timelineEmpty => '暂无状态记录。';

  @override
  String get timelineCreated => '任务已创建';

  @override
  String get editDraft => '编辑草稿';

  @override
  String get draftUpdated => '草稿已更新';

  @override
  String get reputationHistory => '信誉记录';

  @override
  String get reputationHistoryEmpty => '暂无信誉变动。';

  @override
  String get markAllRead => '全部标记已读';

  @override
  String get repTaskComplete => '任务完成';

  @override
  String get repGoodRating => '好评';

  @override
  String get repBadRating => '差评';

  @override
  String get repTaskFailed => '任务失败/放弃';

  @override
  String get repAdminAdjust => '管理员调整';

  @override
  String get rulesTitle => '任务创建与发布流程';

  @override
  String get rulesCoins => '发布者：使用铜币发布任务。执行者：通过签到和完成任务获得铜币。';

  @override
  String get rulesReputation => '执行者完成任务可提升信誉；失败/放弃或收到差评会降低信誉。';

  @override
  String get rulesBlock => '信誉低于最低要求的执行者无法接取新任务。';

  @override
  String get logout => '退出';

  @override
  String get refresh => '刷新';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get understand => '知道了';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中...';

  @override
  String loadCoinsFailed(String error) {
    return '加载铜币数据失败：$error';
  }

  @override
  String checkinSuccess(int coins) {
    return '签到成功！+$coins 铜币';
  }

  @override
  String get loadAvailableTasksFailed => '加载可用任务失败';

  @override
  String get loadingAvailableTasks => '正在加载可用任务...';

  @override
  String get searchTaskHint => '搜索任务标题...';

  @override
  String get category => '类别';

  @override
  String get all => '全部';

  @override
  String get statusDraft => '草稿';

  @override
  String get statusPublished => '已发布';

  @override
  String get statusTaken => '已接单';

  @override
  String get statusInProgress => '进行中';

  @override
  String get statusSubmitted => '待确认';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusCancelled => '已取消';

  @override
  String get statusExpired => '已过期';

  @override
  String get categoryGeneral => '通用';

  @override
  String get categoryDelivery => '配送';

  @override
  String get categoryDeliveryShort => '配送';

  @override
  String get categoryHelper => '帮忙';

  @override
  String get categoryTech => '技术';

  @override
  String get categoryErrands => '代购 / 跑腿';

  @override
  String get noAvailableTasks => '暂无可用任务';

  @override
  String get noAvailableTasksSubtitle => '暂无其他发布者的任务。您可以自己创建并发布任务。';

  @override
  String get scopeAll => '全部';

  @override
  String get scopeCreated => '我发布的';

  @override
  String get scopeExecuting => '我执行的';

  @override
  String needsRatingBanner(int count) {
    return '有 $count 个已完成任务待评价。差评会降低执行者信誉。';
  }

  @override
  String get loadingOrders => '正在加载订单...';

  @override
  String get noOrders => '暂无订单';

  @override
  String get noOrdersSubtitle => '您发布或作为执行者接取的任务将显示在这里。';

  @override
  String get taskCreatedPublished => '任务已创建并发布';

  @override
  String get taskDraftSaved => '任务草稿已保存';

  @override
  String get createTaskFailed => '创建任务失败';

  @override
  String get taskInfo => '任务信息';

  @override
  String get taskTitle => '任务标题';

  @override
  String get description => '描述';

  @override
  String get requiredField => '必填项';

  @override
  String get invalidNumber => '数字无效';

  @override
  String get serviceDetails => '服务详情';

  @override
  String get rewardLabel => '报酬 (Rp)';

  @override
  String get location => '地点';

  @override
  String get publication => '发布';

  @override
  String get publishImmediately => '立即发布';

  @override
  String get publishImmediatelyHint => '关闭后将先保存为草稿';

  @override
  String get createAndPublish => '创建并发布';

  @override
  String get saveDraft => '保存草稿';

  @override
  String get orderDetail => '订单详情';

  @override
  String get loadingOrderDetail => '正在加载订单详情...';

  @override
  String get orderNotFound => '未找到订单';

  @override
  String get openChat => '与对方聊天';

  @override
  String get orderChatTitle => '订单聊天';

  @override
  String get loadingChat => '正在加载聊天...';

  @override
  String get chatEmptyTitle => '暂无消息';

  @override
  String get chatEmptySubtitle => '与发布者或执行者开始对话。';

  @override
  String get chatInputHint => '输入消息...';

  @override
  String get chatAttachImage => '发送图片';

  @override
  String get chatImageFailed => '发送图片失败';

  @override
  String get chatMonitorTitle => '聊天记录';

  @override
  String get chatMonitorEmpty => '该订单暂无聊天消息。';

  @override
  String get chatMessageImage => '[图片]';

  @override
  String get chatSectionTitle => '沟通';

  @override
  String get chatUnavailableDraft => '任务发布并被接单后可使用聊天。';

  @override
  String get chatUnavailablePublished => '执行者接单后可使用聊天。';

  @override
  String get chatUnavailableCancelled => '订单已取消，聊天不可用。';

  @override
  String get chatUnavailableExpired => '订单已过期，聊天不可用。';

  @override
  String get orderNumber => '编号';

  @override
  String get title => '标题';

  @override
  String get reward => '报酬';

  @override
  String rewardAmountValue(String amount) {
    return 'Rp $amount';
  }

  @override
  String get involvedParties => '相关方';

  @override
  String get creator => '发布者';

  @override
  String get executor => '执行者';

  @override
  String get noExecutorYet => '暂无';

  @override
  String get yourRole => '您的角色';

  @override
  String get cancelReason => '取消原因';

  @override
  String get commentOptional => '评论（可选）';

  @override
  String get submitRating => '提交评价';

  @override
  String get loadingProfile => '正在加载资料...';

  @override
  String get editProfile => '编辑资料';

  @override
  String get phoneNumber => '手机号';

  @override
  String get profileUpdated => '资料已更新';

  @override
  String get myAccount => '我的账户';

  @override
  String get statistics => '统计';

  @override
  String publishFeeStat(int fee) {
    return '发布费用：$fee 铜币';
  }

  @override
  String taskRewardStat(int coins) {
    return '完成任务奖励：+$coins 铜币';
  }

  @override
  String reputationPerTask(int points) {
    return '每任务信誉：+$points 分';
  }

  @override
  String completedTasksStat(int count) {
    return '完成任务：$count';
  }

  @override
  String lastCheckinStat(String date) {
    return '最后签到：$date';
  }

  @override
  String get coinHistory => '铜币记录';

  @override
  String get noTransactions => '暂无交易记录';

  @override
  String get notifications => '通知';

  @override
  String markRead(int count) {
    return '标记已读 ($count)';
  }

  @override
  String get noNotifications => '暂无通知';

  @override
  String loadCoinsProfileFailed(String error) {
    return '加载铜币失败：$error';
  }

  @override
  String get serverConnectFailed => '无法连接服务器，请确保后端已运行。';

  @override
  String get loadingCoinsReputation => '正在加载铜币和信誉...';

  @override
  String get lowReputationTitle => '信誉过低';

  @override
  String get abandonTask => '放弃任务';

  @override
  String get cancelOrder => '取消订单';

  @override
  String get abandonWarning => '放弃任务会降低您的信誉。';

  @override
  String get abandonReasonOptional => '放弃原因（可选）';

  @override
  String get cancelReasonOptional => '取消原因（可选）';

  @override
  String get actionPublish => '发布';

  @override
  String get actionCancel => '取消';

  @override
  String get actionTake => '接单';

  @override
  String get actionStart => '开始执行';

  @override
  String get actionSubmit => '提交完成';

  @override
  String get actionConfirm => '确认完成';

  @override
  String get actionAbandon => '放弃任务';

  @override
  String actionPublishMessage(int fee) {
    return '发布任务到市场？发布费用：$fee 铜币。';
  }

  @override
  String get actionCancelMessage => '确定取消此订单？';

  @override
  String get actionTakeMessage => '接取此任务并作为执行者完成？';

  @override
  String get actionStartMessage => '开始执行此任务？';

  @override
  String get actionSubmitMessage => '提交任务完成？需任务发布者确认后才发放奖励。';

  @override
  String actionConfirmMessage(int coins, int rep) {
    return '确认任务完成？执行者将获得 +$coins 铜币和 +$rep 信誉。';
  }

  @override
  String get actionAbandonMessage => '放弃此任务？您的信誉将下降。';

  @override
  String successPublished(String title, int fee) {
    return '任务 \"$title\" 已发布（-$fee 铜币）';
  }

  @override
  String get successCancelled => '订单已取消';

  @override
  String successTaken(String title) {
    return '任务 \"$title\" 已成功接单';
  }

  @override
  String get successStarted => '任务已开始执行';

  @override
  String get successSubmitted => '完成申请已提交，等待发布者确认。';

  @override
  String get successConfirmed => '任务已确认完成，奖励已发放给执行者。';

  @override
  String successCompleted(int coins, int rep) {
    return '任务完成！+$coins 铜币，+$rep 信誉';
  }

  @override
  String get successAbandoned => '任务已放弃，信誉已降低。';

  @override
  String reputationBlockedMessage(int score, int min) {
    return '您的信誉 ($score) 低于最低要求 $min 分。请认真完成任务或每日签到来恢复信誉。';
  }

  @override
  String publishBlockedMessage(
    int current,
    int fee,
    int dailyReward,
    int taskReward,
  ) {
    return '铜币不足 ($current/$fee)。每日签到 (+$dailyReward 铜币) 或完成任务 (+$taskReward 铜币)。';
  }

  @override
  String get roleCreatorAndExecutor => '发布者 & 执行者';

  @override
  String get roleCreator => '任务发布者';

  @override
  String get roleExecutor => '执行者';

  @override
  String get language => '语言';

  @override
  String get languageId => 'Bahasa Indonesia';

  @override
  String get languageZh => '中文 (简体)';

  @override
  String get appearance => '外观';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeModeHint => '选择浅色、深色或跟随设备系统设置。';

  @override
  String get txRegisterBonus => '注册奖励';

  @override
  String get txDailyCheckin => '每日签到';

  @override
  String get txPublishFee => '任务发布费用';

  @override
  String get txTaskReward => '完成任务奖励';

  @override
  String get txAdminAdjust => '管理员调整';

  @override
  String get notifOrderTakenTitle => '任务已被接单';

  @override
  String get notifOrderSubmittedTitle => '完成申请';

  @override
  String get notifOrderCompletedTitle => '任务已完成';

  @override
  String get notifRewardTitle => '奖励已到账';

  @override
  String get notifOrderRatedTitle => '收到评价';

  @override
  String notifOrderTakenContent(String title) {
    return '任务 \"$title\" 已被执行者接单。';
  }

  @override
  String notifOrderSubmittedContent(String title) {
    return '执行者提交了任务 \"$title\" 的完成申请，请确认。';
  }

  @override
  String notifOrderCompletedContent(String title) {
    return '任务 \"$title\" 已完成。请为执行者的工作成果评价。';
  }

  @override
  String notifRewardContent(int coins, int rep) {
    return '您获得了 +$coins 铜币和 +$rep 信誉。';
  }

  @override
  String notifOrderRatedContent(String title, int score) {
    return '发布者为任务 \"$title\" 给出了 $score/5 分评价。';
  }

  @override
  String get sessionExpired => '登录已过期，请重新登录';

  @override
  String get invalidResponse => '服务器响应无效';

  @override
  String get requestFailed => '请求失败';
}
