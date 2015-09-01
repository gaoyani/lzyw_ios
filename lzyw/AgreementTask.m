//
//  AgreementTask.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/11.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "AgreementTask.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation AgreementTask

-(AgreementTask*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}

-(void)getAgreement:(int)agreementType {
    [self.netConnection startConnectGet:[NSString stringWithFormat:@"%@user_id/%d", agreementUrl, agreementType]];
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
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"获取协议失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"agreementResult" object:self userInfo:userInfoDic];
}


@end
