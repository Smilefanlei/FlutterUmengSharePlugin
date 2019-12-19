import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mryt_share_plugin/mryt_share_plugin.dart';

// 友盟key 5d8339874ca357696b000862

// 微信 AppID：wx7762d1ff9ff71eb2

// 微信Screate 914b097c49fe979d5a8fd590a11e9d56

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _androidUmengAppId = '5d8339874ca357696b000862';
  String _iosuUmengAppId = '5d8339874ca357696b000862';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[],
        ),
        body: Container(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  MrytSharePlugin.initShareSdk(
                      _androidUmengAppId, _iosuUmengAppId);
                },
                textColor: Colors.black87,
                child: Text("初始化友盟"),
              ),
              RaisedButton(
                onPressed: () {
                  MrytSharePlugin.setSharePlatform(
                    platform: YTSharePlatorm.wxChat,
                    appKey: 'wx7762d1ff9ff71eb2',
                    appSecret: '914b097c49fe979d5a8fd590a11e9d56',
                    callBackUrl: 'https://www.mryitao.cn/', // 仅微博使用
                  );
                },
                textColor: Colors.black87,
                child: Text("设置分享平台"),
              ),
              RaisedButton(
                onPressed: () {
                  MrytSharePlugin.shareText(
                    platform: YTSharePlatorm.wxChat,
                    text: '测试分享文本',
                    onShareStart: (String platform, String msg) {},
                    onShareSuccess: (String platform, String msg) {},
                    onShareError: (String platform, String msg) {},
                    onShareCancel: (String platform, String msg) {},
                  );
                },
                textColor: Colors.black87,
                child: Text("分享文本"),
              ),
              RaisedButton(
                onPressed: () {
                  MrytSharePlugin.shareOneImage(
                    platform: YTSharePlatorm.wxChat,
                    imgUrl:
                        'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3389683750,3564498893&fm=26&gp=0.jpg',
                    description: '描述描述描述描述描述描述',
                    onShareStart: (String platform, String msg) {},
                    onShareSuccess: (String platform, String msg) {},
                    onShareError: (String platform, String msg) {},
                    onShareCancel: (String platform, String msg) {},
                  );
                },
                textColor: Colors.black87,
                child: Text("分享单图"),
              ),
              RaisedButton(
                onPressed: () {
                  List imgListUrl = new List<String>();
                  imgListUrl.add(
                      'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3638429004,1717840478&fm=26&gp=0.jpg');
                  imgListUrl.add(
                      'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3925233323,1705701801&fm=26&gp=0.jpg');
                  imgListUrl.add(
                      'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3389683750,3564498893&fm=26&gp=0.jpg');
                  imgListUrl.add(
                      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3213883136,1405912109&fm=26&gp=0.jpg');
                  imgListUrl.add(
                      'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1499844476,2082399552&fm=26&gp=0.jpg');
                  imgListUrl.add(
                      'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3833338484,1302327586&fm=26&gp=0.jpg');
                  MrytSharePlugin.shareImageList(
                    platform: YTSharePlatorm.wxChat,
                    imgListUrl: imgListUrl,
                    description: '描述描述描述描述描述描述',
                    onShareStart: (String platform, String msg) {},
                    onShareSuccess: (String platform, String msg) {},
                    onShareError: (String platform, String msg) {},
                    onShareCancel: (String platform, String msg) {},
                  );
                },
                textColor: Colors.black87,
                child: Text("分享多张图片"),
              ),
              RaisedButton(
                onPressed: () {
                  MrytSharePlugin.shareWeb(
                    platform: YTSharePlatorm.wxChat,
                    webUrl: 'https://www.mryitao.cn/',
                    webTitle: 'web标题',
                    webDes: 'web描述',
                    webThumb:
                        'https://gss0.bdstatic.com/-4o3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=2c8532a740086e067ea5371963611091/6c224f4a20a446239deb0bf49422720e0cf3d707.jpg',
                    onShareStart: (String platform, String msg) {},
                    onShareSuccess: (String platform, String msg) {},
                    onShareError: (String platform, String msg) {},
                    onShareCancel: (String platform, String msg) {},
                  );
                },
                textColor: Colors.black87,
                child: Text("分享web"),
              ),
              RaisedButton(
                onPressed: () {
                  MrytSharePlugin.shareVideo(
                    platform: YTSharePlatorm.wxChat,
                    videoUrl:
                        'http://vd3.bdstatic.com/mda-jfmkwm9biipr6p32/sc/mda-jfmkwm9biipr6p32.mp4',
                    videoTitle: 'video标题',
                    videoDes: 'video描述',
                    videoThumb:
                        'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3213883136,1405912109&fm=26&gp=0.jpg',
                    onShareStart: (String platform, String msg) {},
                    onShareSuccess: (String platform, String msg) {},
                    onShareError: (String platform, String msg) {},
                    onShareCancel: (String platform, String msg) {},
                  );
                },
                textColor: Colors.black87,
                child: Text("分享视频"),
              ),
              RaisedButton(
                onPressed: () {
                  MrytSharePlugin.shareMinProgram(
                    platform: YTSharePlatorm.wxChat,
                    miniWebUrl: 'https://www.mryitao.cn/',
                    miniPagePath: '/page/page/page',
                    miniTitle: '小程序标题',
                    miniDes: '小程序描述',
                    miniThumb:
                        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3638429004,1717840478&fm=26&gp=0.jpg',
                    onShareStart: (String platform, String msg) {},
                    onShareSuccess: (String platform, String msg) {},
                    onShareError: (String platform, String msg) {},
                    onShareCancel: (String platform, String msg) {},
                  );
                },
                textColor: Colors.black87,
                child: Text("分享微信小程序"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
