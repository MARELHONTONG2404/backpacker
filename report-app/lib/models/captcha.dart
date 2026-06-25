class CaptchaInfo {
  const CaptchaInfo({
    required this.enabled,
    this.uuid,
    this.base64Image,
  });

  final bool enabled;
  final String? uuid;
  final String? base64Image;
}
