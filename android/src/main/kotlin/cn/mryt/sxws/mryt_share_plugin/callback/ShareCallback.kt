package cn.mryt.sxws.mryt_share_plugin.callback

import android.util.Log
import cn.mryt.sxws.mryt_share_plugin.MrytSharePlugin
import cn.mryt.sxws.mryt_share_plugin.bean.ResultInfoBean
import cn.mryt.sxws.mryt_share_plugin.enumerate.ShareResultEnum
import cn.mryt.sxws.mryt_share_plugin.manager.ShareSdkManager
import com.umeng.socialize.UMShareListener
import com.umeng.socialize.bean.SHARE_MEDIA
import io.flutter.plugin.common.MethodChannel

/**
 *
 * @ Description:回调接口
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-19 15:47
 */
/**
 * 操作结果类
 */
class UMShareListenerImpl(val method: String?, val result: MethodChannel.Result?, private val channel: MethodChannel?) : UMShareListener {

    override fun onResult(p0: SHARE_MEDIA?) {

        val resultInfoBean = ResultInfoBean(true, method, ShareResultEnum.RESULT_SUCCESS, "分享成功")
        channel?.invokeMethod(ShareResultEnum.RESULT_SUCCESS, resultInfoBean.toString())
        Log.d("mryt_share_plugin", "分享 --- onResult")
    }

    override fun onCancel(p0: SHARE_MEDIA?) {
        val resultInfoBean = ResultInfoBean(true, method, ShareResultEnum.RESULT_CANCEL, "分享取消")
        channel?.invokeMethod(ShareResultEnum.RESULT_CANCEL, resultInfoBean.toString())
        Log.d("mryt_share_plugin", "分享 --- onCancel")
    }

    override fun onError(p0: SHARE_MEDIA?, p1: Throwable?) {
        val resultInfoBean = ResultInfoBean(true, method, ShareResultEnum.RESULT_ERROR, p1?.localizedMessage)
        channel?.invokeMethod(ShareResultEnum.RESULT_ERROR, resultInfoBean.toString())
        Log.d("mryt_share_plugin", "分享 --- onError")
    }

    override fun onStart(p0: SHARE_MEDIA?) {
        val resultInfoBean = ResultInfoBean(true, method, ShareResultEnum.RESULT_START, "分享开始")
        channel?.invokeMethod(ShareResultEnum.RESULT_START,resultInfoBean.toString())
        Log.d("mryt_share_plugin", "分享 --- onStart")
    }

}