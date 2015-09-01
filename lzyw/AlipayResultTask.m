//
//  AlipayResultTask.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/23.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "AlipayResultTask.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation AlipayResultTask

-(AlipayResultTask*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}


-(void)getPayResult:(NSString*)orderID isRecharge:(BOOL)isRecharge {
    NSString * urlString = [NSString stringWithFormat:@"%@order_sn/%@/order_type/%d",getPayResultUrl,orderID,(isRecharge ? 1 : 0)];
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
            [userInfoDic setValue:@"获取支付结果失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPayResult" object:self userInfo:userInfoDic];
}


@end
