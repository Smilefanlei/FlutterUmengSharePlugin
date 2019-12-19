import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mryt_share_plugin/src/callback/mryt_share_callback.dart';
import 'package:mryt_share_plugin/src/enumerate/mryt_share_enum.dart';
import 'package:mryt_share_plugin/src/manager/mryt_share_manager.dart';

enum YTSharePlatorm {
  qq, //QQ
  qqZone, //QQ空间
  wxChat, //微信聊天
  wxTimeline, //微信朋友圈
  sina, //新浪微博
}

class MrytSharePlugin {
  static const MethodChannel _channel =
      const MethodChannel('mryt_share_plugin');

  static Future<void> initShareSdk(String androidUmengKey, String iosUmengKey,
      [String channel]) async {
    _channel
        .setMethodCallHandler(ShareManager.sharedInstance().handlerMethodCall);
    debugPrint(
        "mryt_share_plugin -> MrytSharePlugin -> setMethodCallHandler（）");

    String json = await _channel.invokeMethod('initShareSdk', {
      'appId': Platform.isAndroid ? androidUmengKey : iosUmengKey,
      'channel': channel ?? 'mryt_share_flutter',
    });

    debugPrint("mryt_share_plugin -> initShareSdk -> " + json.toString());
  }

  // 设置分享平台
  static Future<void> setSharePlatform({
    @required YTSharePlatorm platform,
    @required String appKey,
    @required String appSecret,
    String callBackUrl,
  }) async {
    dynamic json = await _channel.invokeMethod('setSharePlatform', {
      'platform': _getPlatformString(platform),
      'appKey': appKey,
      'appSecret': appSecret,
      'callBackUrl': callBackUrl,
    });
    debugPrint("mryt_share_plugin -> setSharePlatform -> " + json.toString());
  }

  // 设置小程序ID
  static Future<void> setMinProgramId(
    YTSharePlatorm platform,
    String minProgramId,
  ) async {
    String json = await _channel.invokeMethod("setMinProgramId", {
      'platform': _getPlatformString(platform),
      'minProgramId': minProgramId,
    });
    debugPrint("mryt_share_plugin -> setMinProgramId -> " + json.toString());
  }

  // 分享文本
  static Future<void> shareText({
    @required YTSharePlatorm platform,
    @required String text,
    OnShareResultListener onShareStart,
    OnShareResultListener onShareSuccess,
    OnShareResultListener onShareError,
    OnShareResultListener onShareCancel,
  }) async {
    _channel.invokeMethod('shareText', {
      'platform': _getPlatformString(platform),
      'text': text,
    });
    ShareManager.sharedInstance().handleShareCallBack(
      _getPlatformString(platform),
      onShareStart,
      onShareSuccess,
      onShareError,
      onShareCancel,
    );
  }

  // 分享图文
  static Future<void> shareOneImage({
    @required YTSharePlatorm platform,
    @required String imgUrl,
    String description,
    OnShareResultListener onShareStart,
    OnShareResultListener onShareSuccess,
    OnShareResultListener onShareError,
    OnShareResultListener onShareCancel,
  }) async {
    _channel.invokeMethod('shareOneImage', {
      'platform': _getPlatformString(platform),
      'imgUrl': imgUrl,
      'description': description,
    });
    ShareManager.sharedInstance().handleShareCallBack(
      _getPlatformString(platform),
      onShareStart,
      onShareSuccess,
      onShareError,
      onShareCancel,
    );
  }

  // 分享多图
  static Future<void> shareImageList({
    @required YTSharePlatorm platform,
    @required List<String> imgListUrl,
    String description,
    OnShareResultListener onShareStart,
    OnShareResultListener onShareSuccess,
    OnShareResultListener onShareError,
    OnShareResultListener onShareCancel,
  }) async {
    try {
      /* 受Umeng API 和微信的限制 微信不支持分享多图,android和ios会有细微差别 */
      if (Platform.isAndroid) {
        _channel.invokeMethod('shareImageList', {
          'platform': _getPlatformString(platform),
          'imgDataList': imgListUrl,
          'description': description,
        });
      } else if (Platform.isIOS) {
        List<Uint8List> imgDataList = await _downloadImage(imgListUrl);
        _channel.invokeMethod('shareImageList', {
          'platform': _getPlatformString(platform),
          'imgDataList': imgDataList,
          'description': description,
        });
      }

      ShareManager.sharedInstance().handleShareCallBack(
        _getPlatformString(platform),
        onShareStart,
        onShareSuccess,
        onShareError,
        onShareCancel,
      );
    } catch (e) {}
  }

  // 分享web
  static Future<void> shareWeb({
    @required YTSharePlatorm platform,
    @required String webUrl,
    @required String webTitle,
    @required String webDes,
    @required String webThumb,
    OnShareResultListener onShareStart,
    OnShareResultListener onShareSuccess,
    OnShareResultListener onShareError,
    OnShareResultListener onShareCancel,
  }) async {
    _channel.invokeMethod('shareWeb', {
      'platform': _getPlatformString(platform),
      'webUrl': webUrl,
      'webTitle': webTitle,
      'webDes': webDes,
      'webThumb': webThumb,
    });
    ShareManager.sharedInstance().handleShareCallBack(
      _getPlatformString(platform),
      onShareStart,
      onShareSuccess,
      onShareError,
      onShareCancel,
    );
  }

  // 分享视频
  static Future<void> shareVideo({
    @required YTSharePlatorm platform,
    @required String videoUrl,
    @required String videoTitle,
    @required String videoDes,
    @required String videoThumb,
    OnShareResultListener onShareStart,
    OnShareResultListener onShareSuccess,
    OnShareResultListener onShareError,
    OnShareResultListener onShareCancel,
  }) async {
    _channel.invokeMethod('shareVideo', {
      'platform': _getPlatformString(platform),
      'videoUrl': videoUrl,
      'videoTitle': videoTitle,
      'videoDes': videoDes,
      'videoThumb': videoThumb,
    });
    ShareManager.sharedInstance().handleShareCallBack(
      _getPlatformString(platform),
      onShareStart,
      onShareSuccess,
      onShareError,
      onShareCancel,
    );
  }

  //
  // 分享小程序
  // platform  => 目前只支持微信聊天wxChat
  // miniWebUrl => 低版本微信网页链接
  // userName  => 小程序username
  // miniPagePath => 小程序页面的路径
  // miniTitle => 分享标题
  // miniDes => 分享描述
  // miniThumb => 小程序新版本的预览图 128k
  // miniProgramType => 分享小程序的版本（正式 0，开发 1，体验  2）
  //                    正式版 尾巴正常显示
  //                    开发版 尾巴显示“未发布的小程序·开发版”
  //                    体验版 尾巴显示“未发布的小程序·体验版”
  //withShareTicket =>  是否使用带 shareTicket 的转发
  //
  static Future<void> shareMinProgram({
    @required YTSharePlatorm platform,
    @required String miniWebUrl,
    @required String userName,
    @required String miniPagePath,
    @required String miniTitle,
    @required String miniDes,
    @required String miniThumb,
    int miniProgramType = 0,
    bool withShareTicket = false,
    OnShareResultListener onShareStart,
    OnShareResultListener onShareSuccess,
    OnShareResultListener onShareError,
    OnShareResultListener onShareCancel,
  }) async {
    _channel.invokeMethod('shareMinProgram', {
      'platform': _getPlatformString(platform),
      'miniWebUrl': miniWebUrl,
      'miniPagePath': miniPagePath,
      'miniTitle': miniTitle,
      'miniDes': miniDes,
      'miniThumb': miniThumb,
      'userName': userName,
      'miniProgramType': miniProgramType,
      'withShareTicket': withShareTicket,
    });
    ShareManager.sharedInstance().handleShareCallBack(
      _getPlatformString(platform),
      onShareStart,
      onShareSuccess,
      onShareError,
      onShareCancel,
    );
  }

  static String _getPlatformString(YTSharePlatorm platform) {
    String platformStr = '';
    switch (platform) {
      case YTSharePlatorm.qq:
        platformStr = SharePlatformEnum.PLATFORM_QQ;
        break;
      case YTSharePlatorm.qqZone:
        platformStr = SharePlatformEnum.PLATFORM_QZONE;
        break;
      case YTSharePlatorm.wxChat:
        platformStr = SharePlatformEnum.PLATFORM_WEIXIN_FRIEND;
        break;
      case YTSharePlatorm.wxTimeline:
        platformStr = SharePlatformEnum.PLATFORM_WEIXIN_CIRCLE;
        break;
      case YTSharePlatorm.sina:
        platformStr = SharePlatformEnum.PLATFORM_SINA;
        break;
      default:
        platformStr = SharePlatformEnum.PLATFORM_WEIXIN_FRIEND;
    }
    return platformStr;
  }

  static Future<List<Uint8List>> _downloadImage(List<String> urlList) async {
    List<Uint8List> list = [];
    for (var url in urlList) {
      Response response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      list.add(Uint8List.fromList(response.data));
      // String imageId = await ImageDownloader.downloadImage(url, );
      // String filePath = await ImageDownloader.findPath(imageId);
      // Uint8List uint8list = await File(filePath).readAsBytes();
      // list.add(uint8list);
    }
    return list;
  }
}
