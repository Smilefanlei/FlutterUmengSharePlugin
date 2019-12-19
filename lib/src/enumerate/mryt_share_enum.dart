/**
 * 平台枚举类型
 */
class SharePlatformEnum {
  static const String PLATFORM_QQ = 'QQ';
  static const String PLATFORM_QZONE = 'QZONE';
  static const String PLATFORM_WEIXIN_FRIEND = 'WEIXIN_FRIEND';
  static const String PLATFORM_WEIXIN_CIRCLE = 'WEIXIN_CIRCLE';
  static const String PLATFORM_SINA = 'SINA';
}

/**
 * 操作枚举类型
 */
class ShareResultEnum {
  static const String RESULT_START = 'onShareStart';
  static const String RESULT_SUCCESS = 'onShareSuccess';
  static const String RESULT_ERROR = 'onShareError';
  static const String RESULT_CANCEL = 'onShareCancel';
}
