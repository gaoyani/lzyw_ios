//
//  OrderInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "OrderInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation OrderInfo

-(OrderInfo*)init {
    self = [super init];
    if (self) {
        self.operations = [NSMutableArray array];
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}

-(void)operationOrder:(int)operation {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: self.ID forKey:@"calendar_id"];
    [paramsDic setValue: [NSString stringWithFormat:@"%d", operation] forKey:@"operation_type"];
    
    [self.netConnection startConnect:operateOrderUrl paramsDictionary:paramsDic];
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
            int errorCode = (int)[[jsonDic objectForKey:@"error"] integerValue];
            if (errorCode == 0) {
                NSDictionary* contentDic = [jsonDic objectForKey:@"content"];
                self.state = [contentDic objectForKey:@"status"];
                [self.operations removeAllObjects];
                NSArray* operationArray = [contentDic objectForKey:@"operable_list"];
                for (int i=0; i<operationArray.count; i++) {
                    [self.operations addObject:[[operationArray objectAtIndex:i] stringValue]];
                }
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:errorMessage];
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDic objectForKey:@"is_login" ] boolValue]];
            }
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"操作订单失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"operateResult" object:self userInfo:userInfoDic];
}


-(void)parseJson:(NSDictionary*)jsonDic {
    self.ID = [jsonDic objectForKey:@"order_id"];
    self.orderID = [jsonDic objectForKey:@"order_sn"];
    self.storeName = [jsonDic objectForKey:@"business_name"];
    self.storeID = [jsonDic objectForKey:@"business_id"];
    self.roomID = [jsonDic objectForKey:@"room_id"];
    self.phoneNumber = [jsonDic objectForKey:@"mobile"];
    self.price = [jsonDic objectForKey:@"room_amount"];
    self.info = [jsonDic objectForKey:@"order_info"];
    self.time = [jsonDic objectForKey:@"add_time"];
    self.state = [jsonDic objectForKey:@"status"];
    self.orderType = [[jsonDic objectForKey:@"order_matter"] integerValue];
    self.isCommented = [[jsonDic objectForKey:@"is_comment"] boolValue];
    
    
    NSArray* operationArray = [jsonDic objectForKey:@"operable_list"];
    for (int i=0; i<operationArray.count; i++) {
        [self.operations addObject:[[operationArray objectAtIndex:i] stringValue]];
    }
}

@end
