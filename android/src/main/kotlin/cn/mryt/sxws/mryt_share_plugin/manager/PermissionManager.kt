package cn.mryt.sxws.mryt_share_plugin.manager

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.PluginRegistry


/**
 *
 * @ Description:
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-26 13:48
 */

class PermissionManager {
    private val TAG: String = "mryt_share_plugin"

    companion object {
        val instance = PermissionManagerHolder.holder
    }

    private object PermissionManagerHolder {
        val holder = PermissionManager()
    }

    /**
     * 监听权限申请的结果
     */
    fun setRequestPermissionsResultListener(activity: Activity?, registrar: PluginRegistry.Registrar) {
        registrar.addRequestPermissionsResultListener(object : PluginRegistry.RequestPermissionsResultListener {
            override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {
                grantResults?.let {
                    if (it[0] == PackageManager.PERMISSION_DENIED) {
                        Toast.makeText(activity, "请同意权限才能继续分享", Toast.LENGTH_SHORT).show()
                    }
                }
                return true
            }
        })
    }

    /**
     * 申请读写权限
     */
    fun requestReadAndWritePermission(activity: Activity?): Boolean {
        if (activity == null) {
            return false
        }

        /* 未授予权限 */
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

            /* 点击了拒绝且不再提示 */
            if (ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

                // 申请权限
                val permissionArray = arrayListOf<String>()
                permissionArray.add(Manifest.permission.READ_EXTERNAL_STORAGE)
                permissionArray.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)

                ActivityCompat.requestPermissions(activity, permissionArray.toTypedArray(), 1)

            } else {

                val localIntent = Intent()
                localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                localIntent.action = "android.settings.APPLICATION_DETAILS_SETTINGS"
                localIntent.data = Uri.fromParts("package", activity.packageName, null)
                activity.startActivity(localIntent)

            }
            return false

        } else {
            /* 已申请权限 */
            return true
        }

    }


}