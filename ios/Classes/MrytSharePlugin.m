//
//  MrytSharePlugin.m
//  Runner
//
//  Created by 武贤业 on 2019/10/7.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "MrytSharePlugin.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/UMConfigure.h>

static NSString *initShareSdk = @"initShareSdk";
static NSString *setSharePlatform = @"setSharePlatform";
static NSString *shareText = @"shareText";
static NSString *shareImageList = @"shareImageList";
static NSString *shareWeb = @"shareWeb";
static NSString *shareVideo = @"shareVideo";
static NSString *shareMinProgram = @"shareMinProgram";
static NSString *shareOneImage = @"shareOneImage";
static NSString *onShareStart = @"onShareStart";
static NSString *onShareSuccess = @"onShareSuccess";
static NSString *onShareError = @"onShareError";
static NSString *onShareCancel = @"onShareCancel";


@interface NSError (MrytSharePlugin)

@property (nonatomic, readonly) FlutterError *flutterError;

@end

@implementation NSError (MrytSharePlugin)

- (FlutterError *)flutterError {
    return [FlutterError errorWithCode:[NSString
                                        stringWithFormat:@"Error %d", (int)self.code]
                               message:self.domain
                               details:self.localizedRecoverySuggestion];
}

@end


@implementation MrytSharePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"mryt_share_plugin" binaryMessenger:[registrar messenger]];
    MrytSharePlugin *plugin = [[MrytSharePlugin alloc] init];
    plugin.channel = channel;
    
    [registrar addApplicationDelegate:plugin];
    [registrar addMethodCallDelegate:plugin channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    NSString *method = call.method;
    if ([method isEqualToString:initShareSdk]) {
        [self initShareSdk:call result:result];
    } else if ([method isEqualToString:setSharePlatform]) {
        [self setSharePlatform:call result:result];
    } else if ([method isEqualToString:shareText]) {
        [self shareText:call result:result];
    } else if ([method isEqualToString:shareImageList]) {
        [self shareImageList:call result:result];
    } else if ([method isEqualToString:shareWeb]) {
        [self shareWeb:call result:result];
    } else if ([method isEqualToString:shareVideo]) {
        [self shareVideo:call result:result];
    } else if ([method isEqualToString:shareMinProgram]) {
        [self shareMinProgram:call result:result];
    } else if ([method isEqualToString:shareOneImage]) {
        [self shareOneImage:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - dart调用

- (void)initShareSdk:(FlutterMethodCall *)call
              result:(FlutterResult)result  {
    NSDictionary *dic = call.arguments;
    NSString *appId = dic[@"appId"];
    if (appId == nil) {
        result([self normalFlutterError]);
        return;
    }
    
    NSString *channel = dic[@"channel"];
    [UMConfigure initWithAppkey:appId
                        channel:channel ?: @""];
}

- (void)setSharePlatform:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSString *appKey = dic[@"appKey"];
    NSString *platform = dic[@"platform"];
    NSString *appSecret = dic[@"appSecret"];

    if (appKey == nil ||
        platform == nil ||
        appSecret == nil) {
        result([self normalFlutterError]);
        return;
    }
    
    NSString *callBackUrl = dic[@"callBackUrl"];
    
    BOOL success = [[UMSocialManager defaultManager] setPlaform:[self getSharePlatformType:platform]
                                                         appKey:appKey
                                                      appSecret:appSecret
                                                    redirectURL:callBackUrl];
    result(@{@"success": @(success)});
}

- (void)shareText:(FlutterMethodCall *)call
           result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSString *platform = dic[@"platform"];
    NSString *text = dic[@"text"];
    
    if (platform == nil || text == nil) {
        [self shareParameterError];
        return;
    }
    
    UMShareObject *shareObjc = [UMShareObject new];
    shareObjc.title = text;
    
    [self shareWithPlatform:platform
                shareObject:shareObjc
                     result:result];
}

- (void)shareOneImage:(FlutterMethodCall *)call
               result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSString *platform = dic[@"platform"];
    NSString *imgUrl = dic[@"imgUrl"];
    
    if (platform == nil || imgUrl == nil) {
        [self shareParameterError];
        return;
    }
    
    NSString *desc = dic[@"desc"];
    
    UMShareImageObject *shareObjc = [UMShareImageObject new];
    shareObjc.shareImage = imgUrl;
    shareObjc.descr = desc;
    
    [self shareWithPlatform:platform
                shareObject:shareObjc
                     result:result];
}

- (void)shareImageList:(FlutterMethodCall *)call
                result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSString *platform = dic[@"platform"];
    NSArray<FlutterStandardTypedData *> *imgDataList = dic[@"imgDataList"];
    NSMutableArray *arr = [NSMutableArray array];
    [imgDataList enumerateObjectsUsingBlock:^(FlutterStandardTypedData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.data != nil) {
            [arr addObject:obj.data];
        }
    }];
    if (platform == nil || arr == nil || arr.count <= 0) {
        [self shareParameterError];
        return;
    }
    
    NSString *desc = dic[@"desc"];
    
    UMShareImageObject *shareObjc = [UMShareImageObject new];
    shareObjc.shareImageArray = [arr copy];
    shareObjc.descr = desc;

    
    [self shareWithPlatform:platform
                shareObject:shareObjc
                     result:result];

}

- (void)shareWeb:(FlutterMethodCall *)call
          result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSString *platform = dic[@"platform"];
    NSString *webUrl = dic[@"webUrl"];
    
    if (platform == nil || webUrl == nil) {
        [self shareParameterError];
        return;
    }
    
    
    UMShareWebpageObject *shareObjc = [UMShareWebpageObject new];
    shareObjc.webpageUrl = webUrl;
    shareObjc.descr = dic[@"webDes"];
    shareObjc.title = dic[@"webTitle"];
    shareObjc.thumbImage = dic[@"webThumb"];

    
    [self shareWithPlatform:platform
                shareObject:shareObjc
                     result:result];

}

- (void)shareVideo:(FlutterMethodCall *)call
            result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSString *platform = dic[@"platform"];
    NSString *videoUrl = dic[@"videoUrl"];
    
    if (platform == nil || videoUrl == nil) {
        [self shareParameterError];
        return;
    }
    
    
    UMShareVideoObject *shareObjc = [UMShareVideoObject new];
    shareObjc.videoUrl = videoUrl;
    shareObjc.descr = dic[@"videoDes"];
    shareObjc.title = dic[@"videoTitle"];
    shareObjc.thumbImage = dic[@"videoThumb"];

    
    [self shareWithPlatform:platform
                shareObject:shareObjc
                     result:result];
}

- (void)shareMinProgram:(FlutterMethodCall *)call
                 result:(FlutterResult)result {
    NSDictionary *dic = call.arguments;
    NSString *platform = dic[@"platform"];
    NSString *miniWebUrl = dic[@"miniWebUrl"];
    NSString *userName = dic[@"userName"];

    if (platform == nil ||
        userName == nil ||
        miniWebUrl) {
        [self shareParameterError];
        return;
    }
    
    NSNumber *miniProgramType = dic[@"miniProgramType"];
    NSNumber *withShareTicket = dic[@"withShareTicket"];
    
    UMShareMiniProgramObject *shareObjc = [UMShareMiniProgramObject new];
    shareObjc.miniProgramType = [miniProgramType integerValue];
    shareObjc.userName = userName;
    shareObjc.webpageUrl = miniWebUrl;
    
    shareObjc.descr = dic[@"miniDes"];
    shareObjc.title = dic[@"miniTitle"];
    shareObjc.thumbImage = dic[@"miniThumb"];
    
    shareObjc.withShareTicket = [withShareTicket boolValue];
    shareObjc.path = dic[@"miniPagePath"];

    
    [self shareWithPlatform:platform
                shareObject:shareObjc
                     result:result];

}


#pragma mark - FlutterApplicationLifeCycleDelegate


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[UMSocialManager defaultManager] handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [[UMSocialManager defaultManager] handleOpenURL:url
                                  sourceApplication:sourceApplication
                                         annotation:annotation];
    return YES;
}

#pragma mark - private

- (void)shareWithPlatform:(NSString *)platformStr
              shareObject:(UMShareObject *)shareObject
                   result:(FlutterResult)result {
    UIViewController *vc = [self getCurrentViewController];
    if (vc == nil) {
        [self shareParameterError];
        return;
    }
    
    UMSocialMessageObject *messageObjc = [UMSocialMessageObject new];
    if ([shareObject isMemberOfClass:[UMShareObject class]]) {
        messageObjc.text = shareObject.title;
    } else {
        messageObjc.shareObject = shareObject;
    }
    NSString *startJsonStr = [self dictionaryToJson:@{@"method": onShareStart}];
    [self.channel invokeMethod:onShareStart arguments:startJsonStr];
    
    [[UMSocialManager defaultManager] shareToPlatform:[self getSharePlatformType:platformStr]
                                        messageObject:messageObjc
                                currentViewController:vc
                                           completion:^(id shareResponse, NSError *error) {
        if (error != nil) {
            if (error.code == UMSocialPlatformErrorType_Cancel) {
                NSString *jsonStr = [self dictionaryToJson:@{@"method": onShareCancel}];
                [self.channel invokeMethod:onShareCancel
                                 arguments:jsonStr];
            } else {
                NSString *jsonStr = [self dictionaryToJson:@{
                    @"success": @NO,
                    @"method": onShareError,
                    @"msg": [NSString stringWithFormat:@"Error %ld", error.code]
                }];

                [self.channel invokeMethod:onShareError
                                 arguments:jsonStr];
            }
            
        } else {
            NSString *jsonStr = [self dictionaryToJson:@{
                @"success": @YES,
                @"method": onShareSuccess
            }];
            [self.channel invokeMethod:onShareSuccess
                             arguments:jsonStr];
        }
    
    }];
}

- (void)shareParameterError {
    NSString *jsonStr = [self dictionaryToJson:@{
        @"success": @NO,
        @"method": onShareError,
        @"msg": @"缺少必要参数"
    }];
    
    [self.channel invokeMethod:onShareError arguments:jsonStr];
}

- (UMSocialPlatformType)getSharePlatformType:(NSString *)platformStr {
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    if ([platformStr isEqualToString:@"QQ"]) {
        type = UMSocialPlatformType_QQ;
    } else if ([platformStr isEqualToString:@"QZONE"]) {
        type = UMSocialPlatformType_Qzone;
    } else if ([platformStr isEqualToString:@"WEIXIN_FRIEND"]) {
        type = UMSocialPlatformType_WechatSession;
    } else if ([platformStr isEqualToString:@"WEIXIN_CIRCLE"]) {
        type = UMSocialPlatformType_WechatTimeLine;
    } else if ([platformStr isEqualToString:@"SINA"]) {
        type = UMSocialPlatformType_Sina;
    }
    return type;
}

- (UIViewController *)getCurrentViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}



- (FlutterError *)normalFlutterError {
    return [FlutterError errorWithCode:@"Error -10000001"
                               message:@"MrytSharePlugin 普通缺少参数错误"
                               details:nil];
}

- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    if (parseError == nil) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return @"";
    }
    
}


@end
