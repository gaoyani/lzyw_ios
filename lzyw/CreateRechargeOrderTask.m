//
//  CreateRechargeOrder.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "CreateRechargeOrderTask.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation CreateRechargeOrderTask

-(CreateRechargeOrderTask*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return self;
}


-(void)createRechargeOrder{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    
    [self.netConnection startConnect:createRechargeUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSData* jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (jsonDic != nil && error == nil) {
            int errorCode = [[jsonDic objectForKey:@"error"] integerValue];
            if (errorCode != 0) {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:errorMessage];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:message];
            }
            
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) autoLogout:[[jsonDic objectForKey:@"is_login"] boolValue]];
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"创建充值订单失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createRechargeOrderResult" object:self userInfo:userInfoDic];
}

@end
