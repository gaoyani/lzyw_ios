//
//  PaymentTask.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/15.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "PaymentTask.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "UrlConstants.h"

@implementation PaymentTask

-(PaymentTask*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}

-(void)payOrder:(NSString*)orderID paymentType:(enum PaymentType)type password:(NSString*)password payNum:(int)payNum {
    paymentType = type;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: orderID forKey:@"order_id"];
    [paramsDic setValue: [Utils md5:password] forKey:@"payment_password"];
    [paramsDic setValue: [NSString stringWithFormat:@"%d", paymentType] forKey:@"pay_id"];
    [paramsDic setValue: [NSString stringWithFormat:@"%d", payNum] forKey:@"error_numb"];
    
    [self.netConnection startConnect:paymentUrl paramsDictionary:paramsDic];
}

-(void)confirmRechargeOrder:(NSString*)orderID paymentType:(enum PaymentType)type price:(NSString*)price {
    paymentType = type;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: orderID forKey:@"order_sn"];
    [paramsDic setValue: price forKey:@"price"];
    [paramsDic setValue: [NSString stringWithFormat:@"%d", paymentType] forKey:@"pay_id"];
    
    [self.netConnection startConnect:confirmRechargeUrl paramsDictionary:paramsDic];
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
            int errorCode = [[jsonDic objectForKey:@"error"] integerValue];
            if (errorCode == 0) {
                NSMutableArray* contentArray = [jsonDic objectForKey:@"content"];
                NSString* content = @"";
                for (int i=0; i<contentArray.count; i++) {
                    content = [content stringByAppendingString:[contentArray objectAtIndex:i]];
                }
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
                [userInfoDic setValue:[content stringByReplacingOccurrencesOfString:@"\'" withString:@"\""] forKey:message];
                
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:errorMessage];
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) autoLogout:[[jsonDic objectForKey:@"is_login"] boolValue]];
            }
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"支付失败" forKey:errorMessage];
        }

    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    NSString* resultSelector = @"payOrderResult";
    if (paymentType == PaymentTypeAli) {
        resultSelector = @"submitResult";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:resultSelector object:self userInfo:userInfoDic];
}

@end
