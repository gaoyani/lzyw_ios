//
//  AuthCodeManager.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/28.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "AuthCodeTask.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation AuthCodeTask

-(AuthCodeTask*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}


-(void)getAuthCode:(NSString*)phoneNumber autoCodeUrl:(NSString*)autoCodeUrl{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString * urlString = [NSString stringWithFormat:@"%@mobile_phone/%@/user_id/%@",autoCodeUrl,phoneNumber,appDelegate.memberInfo.memberID];
    
    [self.netConnection startConnect:urlString paramsDictionary:nil];
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
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            }
            [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:message];
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"获取验证码失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"authCodeResult" object:self userInfo:userInfoDic];
}

@end
