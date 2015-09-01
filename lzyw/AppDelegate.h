//
//  AppDelegate.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

#import "MemberInfo.h"
#import "PublicInfo.h"
#import "StoreDetailInfo.h"
#import "RoomInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BMKMapManager* mapManager;
@property CLLocationManager *locationManager;

@property NSString* domainNameUrl;
@property MemberInfo* memberInfo;
@property PublicInfo* publicInfo;
@property StoreDetailInfo* storeDetailInfo;
@property RoomInfo* roomInfo;

-(void)autoLogout:(BOOL)isLogin;


@end

