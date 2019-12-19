package cn.mryt.sxws.mryt_share_plugin.manager

import android.app.Activity
import android.util.Log
import cn.mryt.sxws.mryt_share_plugin.MrytSharePlugin
import cn.mryt.sxws.mryt_share_plugin.bean.ResultInfoBean
import cn.mryt.sxws.mryt_share_plugin.callback.UMShareListenerImpl
import cn.mryt.sxws.mryt_share_plugin.enumerate.ShareMethodEnum
import cn.mryt.sxws.mryt_share_plugin.enumerate.SharePlatformEnum
import com.umeng.commonsdk.UMConfigure
import com.umeng.socialize.PlatformConfig
import com.umeng.socialize.ShareAction
import com.umeng.socialize.UMShareAPI
import com.umeng.socialize.bean.SHARE_MEDIA
import com.umeng.socialize.media.UMImage
import com.umeng.socialize.media.UMMin
import com.umeng.socialize.media.UMVideo
import com.umeng.socialize.media.UMWeb
import io.flutter.BuildConfig
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File


/**
 *
 * @ Description: 分享SDK的工具类
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-18 18:45
 */
class ShareSdkManager {

    private val TAG: String = "mryt_share_plugin"
    // 小程序原始ID
    private var mOriginalId: String? = null

    companion object {
        val instance = ShareSdkManagerHolder.holder
    }

    private object ShareSdkManagerHolder {
        val holder = ShareSdkManager()
    }

    /**
     * 设置分享的回调
     */
    fun setActivityResultListener(activity: Activity?, registrar: PluginRegistry.Registrar) {
        registrar.addActivityResultListener { p0, p1, p2 ->
            UMShareAPI.get(activity).onActivityResult(p0, p1, p2)
            true
        }
    }

    /**
     * 初始化UmengSDk
     */
    fun initShareSdk(umengKey: String?, result: MethodChannel.Result) {
        if (umengKey.isNullOrEmpty()) {
            debugErrorPrint(TAG, "Umeng Key不能为'空'")
            return
        }
        UMConfigure.init(MrytSharePlugin.mActivity, umengKey, "sxws", UMConfigure.DEVICE_TYPE_PHONE, "")
        returnResult(true, ShareMethodEnum.METHOD_INIT_SHARESDK, ShareMethodEnum.METHOD_INIT_SHARESDK, "初始化Umeng SDK 成功", result)
    }


    /**
     * 设置分享的平台
     */
    fun setSharePlatform(platform: String?, appKey: String?, appSecret: String?, callbackUrl: String?, result: MethodChannel.Result?) {

        if (appKey.isNullOrEmpty()) {
            debugErrorPrint(TAG, "appKey 不能为 '空'")
            return
        }

        if (appSecret.isNullOrEmpty()) {
            debugErrorPrint(TAG, "appSecret 不能为 '空'")
            return
        }

        when (platform) {
            SharePlatformEnum.PLATFORM_QQ, SharePlatformEnum.PLATFORM_QZONE -> {
                PlatformConfig.setQQZone(appKey, appSecret)
                returnResult(true, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, "设置-QQ-平台成功", result)
            }
            SharePlatformEnum.PLATFORM_WEIXIN_FRIEND, SharePlatformEnum.PLATFORM_WEIXIN_CIRCLE -> {
                PlatformConfig.setWeixin(appKey, appSecret)
                returnResult(true, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, "设置-WeiXin-平台成功", result)
            }
            SharePlatformEnum.PLATFORM_SINA -> {
                PlatformConfig.setSinaWeibo(appKey, appSecret, callbackUrl)
                returnResult(true, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, "设置-Sina-平台成功", result)
            }
            else -> {
                returnResult(false, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, ShareMethodEnum.METHOD_SET_SHARE_PLATFORM, "暂不支持该平台", result)
            }
        }
    }

    /**
     * 设置小程序原始id
     */
    fun setMinProgramId(platform: String?, originalId: String?, result: MethodChannel.Result?) {
        if (originalId.isNullOrEmpty()) {
            debugErrorPrint(TAG, "originalId 不能为 '空'")
            returnResult(false, ShareMethodEnum.METHOD_SET_MINPROGRAMID, ShareMethodEnum.METHOD_SET_MINPROGRAMID, "小程序ID不能为'空'", result)
            return
        }
        if (platform.equals(SharePlatformEnum.PLATFORM_WEIXIN_FRIEND)
                || platform.equals(SharePlatformEnum.PLATFORM_WEIXIN_CIRCLE)) {
            mOriginalId = originalId
            returnResult(true, ShareMethodEnum.METHOD_SET_MINPROGRAMID, ShareMethodEnum.METHOD_SET_MINPROGRAMID, "小程序ID设置成功", result)
        } else {
            debugErrorPrint(TAG, "仅支持微信小程序")
            returnResult(false, ShareMethodEnum.METHOD_SET_MINPROGRAMID, ShareMethodEnum.METHOD_SET_MINPROGRAMID, "仅支持微信小程序", result)
        }
    }

    /**
     * 分享文本
     */
    fun shareText(activity: Activity?, platform: String?, text: String?, result: MethodChannel.Result?, channel: MethodChannel?) {
        if (text.isNullOrEmpty()) {
            debugErrorPrint(TAG, "text 不能为 '空'")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_TEXT, ShareMethodEnum.METHOD_SHARE_TEXT, "text 不能为 '空'", result)
            return
        }

        // 申请权限
        if (!PermissionManager.instance.requestReadAndWritePermission(activity)) {
            return
        }

        ShareAction(activity)
                .setPlatform(getUmengSharePlatformByMe(platform))//传入平台
                .withText(text)//分享内容
                .setCallback(UMShareListenerImpl(ShareMethodEnum.METHOD_SHARE_TEXT, result, channel))//回调监听器
                .share()
    }

    /**
     * 分享单图
     */
    fun shareOneImage(activity: Activity?, platform: String?, imgUrl: String?, description: String?, result: MethodChannel.Result?, channel: MethodChannel?) {
        if (imgUrl.isNullOrEmpty()) {
            debugErrorPrint(TAG, "imgUrl 不能为 '空'")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_ONEIMAGE, ShareMethodEnum.METHOD_SHARE_ONEIMAGE, "imgUrl 不能为 '空'", result)
            return
        }
        // 分享图
        val shareImg = if (checkImgIsNetImg(imgUrl)) {
            UMImage(activity, imgUrl)
        } else {
            UMImage(activity, File(imgUrl))
        }
        // 缩略图
        val thumb = if (checkImgIsNetImg(imgUrl)) {
            UMImage(activity, imgUrl)
        } else {
            UMImage(activity, File(imgUrl))
        }
        thumb.compressStyle = UMImage.CompressStyle.SCALE
        // 设置缩略图
        shareImg.setThumb(thumb)

        // 申请权限
        if (!PermissionManager.instance.requestReadAndWritePermission(activity)) {
            return
        }

        //  开始分享
        ShareAction(activity)
                .setPlatform(getUmengSharePlatformByMe(platform))//传入平台
                .withText(description)//分享内容
                .withMedia(shareImg)
                .setCallback(UMShareListenerImpl(ShareMethodEnum.METHOD_SHARE_ONEIMAGE, result, channel))//回调监听器
                .share()

    }

    /**
     * 分享多图(目前仅支持QQ空间和新浪微博)
     */
    fun shareImageList(activity: Activity?, platform: String?, imgListUrl: List<String>?, description: String?, result: MethodChannel.Result?, channel: MethodChannel?) {
        if (imgListUrl.isNullOrEmpty()) {
            debugErrorPrint(TAG, "imgListUrl 不能为 '空'")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_IMAGELIST, ShareMethodEnum.METHOD_SHARE_IMAGELIST, "imgListUrl 不能为 '空'", result)
            return
        }
        if (imgListUrl.size > 9) {
            debugErrorPrint(TAG, "分享的图片不能超过9张")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_IMAGELIST, ShareMethodEnum.METHOD_SHARE_IMAGELIST, "分享图片最多9张", result)
            return
        }

        // 创建图片列表
        val shareImgList = ArrayList<UMImage>()
        imgListUrl.forEach {
            // 分析昂图
            val shareImg = if (checkImgIsNetImg(it)) {
                UMImage(activity, it)
            } else {
                UMImage(activity, File(it))
            }
            shareImgList.add(shareImg)
        }

        // 申请权限
        if (!PermissionManager.instance.requestReadAndWritePermission(activity)) {
            return
        }

        // 分享
        ShareAction(activity)
                .withMedias(*(shareImgList.toTypedArray()))
                .setPlatform(getUmengSharePlatformByMe(platform))
                .withText(description)
                .setCallback(UMShareListenerImpl(ShareMethodEnum.METHOD_SHARE_IMAGELIST, result, channel))//回调监听器
                .share()
    }

    /**
     * 分享Web
     */
    fun shareWeb(activity: Activity?, platform: String?, webUrl: String?, webTitle: String?, webDes: String?, webThumb: String?, result: MethodChannel.Result?, channel: MethodChannel?) {
        if (webUrl.isNullOrEmpty()) {
            debugErrorPrint(TAG, "webUrl 不能为 '空'")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_WEB, ShareMethodEnum.METHOD_SHARE_WEB, "webUrl不能为'空'", result)
            return
        }
        // 创建Web
        val umWeb = UMWeb(webUrl)
        umWeb.title = webTitle
        umWeb.description = webDes
        var thumb: UMImage? = null
        // 缩略图
        webThumb?.let {
            thumb = if (checkImgIsNetImg(it)) {
                UMImage(activity, it)
            } else {
                UMImage(activity, File(it))
            }
        }
        thumb?.compressStyle = UMImage.CompressStyle.SCALE
        umWeb.setThumb(thumb)

        // 申请权限
        if (!PermissionManager.instance.requestReadAndWritePermission(activity)) {
            return
        }

        // 开始分享
        ShareAction(activity)
                .withMedia(umWeb)
                .setPlatform(getUmengSharePlatformByMe(platform))
                .setCallback(UMShareListenerImpl(ShareMethodEnum.METHOD_SHARE_WEB, result, channel))//回调监听器
                .share()
    }

    /**
     * 分享视频
     */
    fun shareVideo(activity: Activity?, platform: String?, videoUrl: String?, videoTitle: String?, videoDes: String?, videoThumb: String?, result: MethodChannel.Result?, channel: MethodChannel?) {
        if (videoUrl.isNullOrEmpty()) {
            debugErrorPrint(TAG, "videoUrl 不能为 '空'")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_VIDEO, ShareMethodEnum.METHOD_SHARE_VIDEO, "videoUrl不能为'空'", result)
            return
        }

        val video = UMVideo(videoUrl)
        video.title = videoTitle //视频的标题
        video.description = videoDes //视频的描述
        var thumb: UMImage? = null
        // 缩略图
        videoThumb?.let {
            thumb = if (checkImgIsNetImg(it)) {
                UMImage(activity, it)
            } else {
                UMImage(activity, File(it))
            }
        }
        thumb?.compressStyle = UMImage.CompressStyle.SCALE
        video.setThumb(thumb)//视频的缩略图

        // 申请权限
        if (!PermissionManager.instance.requestReadAndWritePermission(activity)) {
            return
        }

        // 开始分享
        ShareAction(activity)
                .withMedia(video)
                .setPlatform(getUmengSharePlatformByMe(platform))
                .setCallback(UMShareListenerImpl(ShareMethodEnum.METHOD_SHARE_VIDEO, result, channel))//回调监听器
                .share()
    }

    /**
     * 分享小程序
     */
    fun shareMinProgram(activity: Activity?, platform: String?, miniWebUrl: String?, miniPagePath: String?, miniTitle: String?, miniDes: String?, miniThumb: String?, result: MethodChannel.Result?, channel: MethodChannel?) {
        if (miniWebUrl.isNullOrEmpty()) {
            /* miniWebUrl为null */
            debugErrorPrint(TAG, "miniWebUrl 不能为 '空'")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_MINPROGRAM, ShareMethodEnum.METHOD_SHARE_MINPROGRAM, "miniWebUrl不能为'空'", result)
            return
        }

        if (mOriginalId.isNullOrEmpty()) {
            /* 小程序原始ID未设置 */
            debugErrorPrint(TAG, "小程序ID未设置")
//            returnResult(false, ShareMethodEnum.METHOD_SHARE_MINPROGRAM, ShareMethodEnum.METHOD_SHARE_MINPROGRAM, "小程序ID未设置", result)
            return
        }

        val umMin = UMMin(miniWebUrl)//兼容低版本的网页链接

        var thumb: UMImage? = null // 缩略图
        miniThumb?.let {
            thumb = if (checkImgIsNetImg(it)) {
                UMImage(activity, it)
            } else {
                UMImage(activity, File(it))
            }
        }
        thumb?.compressStyle = UMImage.CompressStyle.SCALE
        umMin.setThumb(thumb) // 小程序消息封面图片

        umMin.title = miniTitle // 小程序消息title
        umMin.description = miniDes // 小程序消息描述
        umMin.path = miniPagePath //小程序页面路径
        umMin.userName = mOriginalId // 小程序原始id,在微信平台查询

        // 申请权限
        if (!PermissionManager.instance.requestReadAndWritePermission(activity)) {
            return
        }

        // 开始分享
        ShareAction(activity)
                .withMedia(umMin)
                .setPlatform(getUmengSharePlatformByMe(platform))
                .setCallback(UMShareListenerImpl(ShareMethodEnum.METHOD_SHARE_MINPROGRAM, result, channel))//回调监听器
                .share()
    }


    // 根据平台获取友盟的分享平台
    private fun getUmengSharePlatformByMe(platform: String?): SHARE_MEDIA {
        when (platform) {
            SharePlatformEnum.PLATFORM_QQ -> {
                return SHARE_MEDIA.QQ
            }
            SharePlatformEnum.PLATFORM_QZONE -> {
                return SHARE_MEDIA.QZONE
            }
            SharePlatformEnum.PLATFORM_WEIXIN_FRIEND -> {
                return SHARE_MEDIA.WEIXIN
            }
            SharePlatformEnum.PLATFORM_WEIXIN_CIRCLE -> {
                return SHARE_MEDIA.WEIXIN_CIRCLE
            }
            SharePlatformEnum.PLATFORM_SINA -> {
                return SHARE_MEDIA.SINA
            }
            else -> {
                return SHARE_MEDIA.WEIXIN_CIRCLE
            }
        }
    }

    // 判断图片是网络图片还是本地图片
    private fun checkImgIsNetImg(imgUrl: String?): Boolean {
        if (imgUrl.isNullOrEmpty()) {
            return false
        }
        return imgUrl.startsWith("http://") || imgUrl.startsWith("https://")
    }

    // 返回结果
    private fun returnResult(success: Boolean = true, method: String? = "", operational: String? = "", msg: String? = "", methodResult: MethodChannel.Result?) {
        val resultInfoBean = ResultInfoBean(success, method, operational, msg)
        methodResult?.success(resultInfoBean.toString())
    }


    // 打印日志
    private fun debugErrorPrint(tag: String?, msg: String?) {
        if (BuildConfig.DEBUG) {
            Log.d(tag, msg)
        }
    }
}






