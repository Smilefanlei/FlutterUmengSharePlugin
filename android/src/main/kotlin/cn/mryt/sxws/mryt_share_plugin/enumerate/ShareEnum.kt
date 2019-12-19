package cn.mryt.sxws.mryt_share_plugin.enumerate

/**
 * 平台信息
 */
object SharePlatformEnum {
    val PLATFORM_QQ = "QQ"
    val PLATFORM_QZONE = "QZONE"
    val PLATFORM_WEIXIN_FRIEND = "WEIXIN_FRIEND"
    val PLATFORM_WEIXIN_CIRCLE = "WEIXIN_CIRCLE"
    val PLATFORM_SINA = "SINA"
}

/**
 * 返回结果操作类
 */
object ShareResultEnum {
    val RESULT_START: String = "onShareStart"
    val RESULT_SUCCESS: String = "onShareSuccess"
    val RESULT_ERROR: String = "onShareError"
    val RESULT_CANCEL: String = "onShareCancel"
}


object ShareMethodEnum {
    val METHOD_INIT_SHARESDK = "initShareSdk"
    val METHOD_SET_SHARE_PLATFORM = "setSharePlatform"
    val METHOD_SET_MINPROGRAMID = "setMinProgramId"
    val METHOD_SHARE_TEXT = "shareText"
    val METHOD_SHARE_ONEIMAGE = "shareOneImage"
    val METHOD_SHARE_IMAGELIST = "shareImageList"
    val METHOD_SHARE_WEB = "shareWeb"
    val METHOD_SHARE_VIDEO = "shareVideo"
    val METHOD_SHARE_MINPROGRAM = "shareMinProgram"
}