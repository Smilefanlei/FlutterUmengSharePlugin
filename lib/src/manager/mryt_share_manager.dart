import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mryt_share_plugin/src/bean/mryt_share_result_info_bean.dart';
import 'package:mryt_share_plugin/src/callback/mryt_share_callback.dart';
import 'package:mryt_share_plugin/src/enumerate/mryt_share_enum.dart';

class ShareManager {
  // 单例公开访问点
  factory ShareManager() => sharedInstance();

  // 静态私有成员，没有初始化
  static ShareManager _instance;

  // 私有构造函数
  ShareManager._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static ShareManager sharedInstance() {
    if (_instance == null) {
      _instance = ShareManager._();
    }
    return _instance;
  }

  // ============================== 临时变量 =============================//

  MrytShareResultInfoBean _shareResultInfoBean;
  String _platform;
  OnShareResultListener _onShareStart;
  OnShareResultListener _onShareSuccess;
  OnShareResultListener _onShareError;
  OnShareResultListener _onShareCancel;

  // ============================== 分享的方法 ============================//

  void handleShareCallBack(
    String platform,
    OnShareResultListener onShareStart,
    OnShareResultListener onShareSuccess,
    OnShareResultListener onShareError,
    OnShareResultListener onShareCancel,
  ) {
    _platform = platform;
    _onShareStart = onShareStart;
    _onShareSuccess = onShareSuccess;
    _onShareCancel = onShareCancel;
    _onShareError = onShareError;
  }

  // 处理原生回调Flutter的方法
  Future<dynamic> handlerMethodCall(MethodCall call) async {
    // 处理返回结果
    String resultJson = call.arguments;
    if (resultJson == null || resultJson.isEmpty) {
      _shareResultInfoBean = MrytShareResultInfoBean.fromJson({
        'success': true,
        'method': call.method,
        'operational': 'share',
        'msg': '分享错误'
      });

      if (_onShareError != null) {
        _onShareError(_platform, _shareResultInfoBean.msg);
      }
      _onShareError = null;
      removeVariable();
      return Future.value(true);
    }

    debugPrint("mryt_share_plugin -> $resultJson");

    _shareResultInfoBean =
        MrytShareResultInfoBean.fromJson(jsonDecode(resultJson));

    switch (call.method) {
      case ShareResultEnum.RESULT_START:
        if (_onShareStart != null) {
          _onShareStart(_platform, _shareResultInfoBean.msg);
        }
        _onShareStart = null;
        debugPrint("mryt_share_plugin -> ${ShareResultEnum.RESULT_START}");
        break;
      case ShareResultEnum.RESULT_SUCCESS:
        if (_onShareSuccess != null) {
          _onShareSuccess(_platform, _shareResultInfoBean.msg);
        }
        _onShareSuccess = null;
        removeVariable();
        debugPrint("mryt_share_plugin -> ${ShareResultEnum.RESULT_SUCCESS}");
        break;
      case ShareResultEnum.RESULT_CANCEL:
        if (_onShareCancel != null) {
          _onShareCancel(_platform, _shareResultInfoBean.msg);
        }
        _onShareCancel = null;
        removeVariable();
        debugPrint("mryt_share_plugin -> ${ShareResultEnum.RESULT_CANCEL}");
        break;
      case ShareResultEnum.RESULT_ERROR:
        if (_onShareError != null) {
          _onShareError(_platform, _shareResultInfoBean.msg);
        }
        _onShareError = null;
        removeVariable();
        debugPrint("mryt_share_plugin -> ${ShareResultEnum.RESULT_ERROR}");
        break;
      default:
        if (_onShareError != null) {
          _onShareError(_platform, _shareResultInfoBean.msg);
        }
        _onShareError = null;
        debugPrint("mryt_share_plugin -> ${ShareResultEnum.RESULT_ERROR}");
        break;
    }
    return Future.value(true);
  }

  // 移除变量
  void removeVariable() {
    _platform = null;
    _shareResultInfoBean = null;
  }
}
