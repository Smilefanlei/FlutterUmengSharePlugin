//
//  MrytSharePlugin.h
//  Runner
//
//  Created by 武贤业 on 2019/10/7.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


@interface MrytSharePlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) FlutterMethodChannel *channel;

@end

