//
//  ModifyMemberInfoTask.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/5.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ModifyMemberInfoTask.h"
#import "AppDelegate.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "Utils.h"

@implementation ModifyMemberInfoTask

-(ModifyMemberInfoTask*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}

-(void)modifyUserInfo:(UIImage*)picImage picFileName:(NSString*)picFileName {
    MemberInfo* memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: memberInfo.userName forKey:@"user_name"];
    [paramsDic setValue: memberInfo.nickName forKey:@"nickname"];
    [paramsDic setValue: memberInfo.realName forKey:@"name"];
    [paramsDic setValue: [NSString stringWithFormat:@"%d", memberInfo.sex] forKey:@"sex"];
    
    [self.netConnection startConnectWithImage:editUserInfoUrl paramsDictionary:paramsDic picImage:picImage picFileName:picFileName];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSData* jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        id jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (jsonDic != nil && error == nil) {
            int errorCode = (int)[[jsonDic objectForKey:@"error"] integerValue];
            if (errorCode == 0) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
                
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:errorMessage];
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) autoLogout:[[jsonDic objectForKey:@"is_login"] boolValue]];
            }
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"修改信息失败" forKey:errorMessage];
        }
        
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyResult" object:self userInfo:userInfoDic];
}

@end
