package cn.mryt.sxws.mryt_share_plugin

import android.annotation.SuppressLint
import android.app.Activity
import cn.mryt.sxws.mryt_share_plugin.enumerate.ShareMethodEnum
import cn.mryt.sxws.mryt_share_plugin.manager.PermissionManager
import cn.mryt.sxws.mryt_share_plugin.manager.ShareSdkManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

@SuppressLint("StaticFieldLeak")

class MrytSharePlugin : MethodCallHandler {


    companion object {

        var mActivity: Activity? = null
        var mChannel: MethodChannel? = null
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            mChannel = MethodChannel(registrar.messenger(), "mryt_share_plugin")
            mChannel?.setMethodCallHandler(MrytSharePlugin())
            mActivity = registrar.activity()
            // onActivityResult
            ShareSdkManager.instance.setActivityResultListener(mActivity,registrar)

            // onRequestPermissionsResult
            PermissionManager.instance.setRequestPermissionsResultListener(mActivity,registrar)

        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        when (call.method) {
            ShareMethodEnum.METHOD_INIT_SHARESDK -> {

                val appId: String? = call.argument("appId")
                ShareSdkManager.instance.initShareSdk(appId, result)

            }
            ShareMethodEnum.METHOD_SET_SHARE_PLATFORM -> {

                val platform: String? = call.argument("platform")
                val appKey: String? = call.argument("appKey")
                val appSecret: String? = call.argument("appSecret")
                val callBackUrl: String? = call.argument("callBackUrl")
                ShareSdkManager.instance.setSharePlatform(platform, appKey, appSecret, callBackUrl, result)
            }
            ShareMethodEnum.METHOD_SET_MINPROGRAMID -> {

                val platform: String? = call.argument("platform")
                val minProgramId: String? = call.argument("minProgramId")
                ShareSdkManager.instance.setMinProgramId(platform, minProgramId, result)

            }
            ShareMethodEnum.METHOD_SHARE_TEXT -> {

                val platform: String? = call.argument("platform")
                val text: String? = call.argument("text")
                ShareSdkManager.instance.shareText(mActivity, platform, text, result, mChannel)

            }
            ShareMethodEnum.METHOD_SHARE_ONEIMAGE -> {

                val platform: String? = call.argument("platform")
                val imgUrl: String? = call.argument("imgUrl")
                val description: String? = call.argument("description")
                ShareSdkManager.instance.shareOneImage(mActivity, platform, imgUrl, description, result, mChannel)

            }
            ShareMethodEnum.METHOD_SHARE_IMAGELIST -> {

                val platform: String? = call.argument("platform")
                val imgListUrl: ArrayList<String>? = call.argument("imgListUrl")
                val description: String? = call.argument("description")
                ShareSdkManager.instance.shareImageList(mActivity, platform, imgListUrl, description, result, mChannel)

            }
            ShareMethodEnum.METHOD_SHARE_WEB -> {

                val platform: String? = call.argument("platform")
                val webUrl: String? = call.argument("webUrl")
                val webTitle: String? = call.argument("webTitle")
                val webDes: String? = call.argument("webDes")
                val webThumb: String? = call.argument("webThumb")
                ShareSdkManager.instance.shareWeb(mActivity, platform, webUrl, webTitle, webDes, webThumb, result, mChannel)

            }
            ShareMethodEnum.METHOD_SHARE_VIDEO -> {

                val platform: String? = call.argument("platform")
                val videoUrl: String? = call.argument("videoUrl")
                val videoTitle: String? = call.argument("videoTitle")
                val videoDes: String? = call.argument("videoDes")
                val videoThumb: String? = call.argument("videoThumb")
                ShareSdkManager.instance.shareVideo(mActivity, platform, videoUrl, videoTitle, videoDes, videoThumb, result, mChannel)

            }
            ShareMethodEnum.METHOD_SHARE_MINPROGRAM -> {

                val platform: String? = call.argument("platform")
                val miniWebUrl: String? = call.argument("miniWebUrl")
                val miniPagePath: String? = call.argument("miniPagePath")
                val miniTitle: String? = call.argument("miniTitle")
                val miniDes: String? = call.argument("miniDes")
                val miniThumb: String? = call.argument("miniThumb")
                ShareSdkManager.instance.shareMinProgram(mActivity, platform, miniWebUrl, miniPagePath, miniTitle, miniDes, miniThumb, result, mChannel)

            }
            else -> {
                result.notImplemented()
            }
        }

    }
}
