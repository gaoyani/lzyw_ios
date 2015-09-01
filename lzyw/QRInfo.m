//
//  QRInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "QRInfo.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation QRInfo

-(QRInfo*)init {
    self = [super init];
    if (self) {
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}


-(void)getInfo {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    NSLog(@"StoreDetailInfo:%@", [[UIDevice currentDevice].identifierForVendor UUIDString]);
    
    [self.netConnection startConnect:qrInfoUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSData *data= [output dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (jsonDic != nil && error == nil) {
            self.qrUrl = [jsonDic objectForKey:@"pic"];
            self.note = [jsonDic objectForKey:@"note"];
            self.shareInfo = [jsonDic objectForKey:@"url"];
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDic objectForKey:@"is_login" ] boolValue]];
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"获取数据失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"qrInfoResult" object:self userInfo:userInfoDic];
}


@end
