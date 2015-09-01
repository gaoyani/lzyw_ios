//
//  OrderDetialInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "OrderDetailInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation SubOrderInfo

-(SubOrderInfo*)init {
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
    
    [self.netConnection startConnect:operateSubOrderUrl paramsDictionary:paramsDic];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfo" object:self userInfo:userInfoDic];
}


@end

@implementation OrderDetailInfo

-(OrderDetailInfo*)init {
    self = [super init];
    if (self) {
        self.subOrderList = [NSMutableArray array];
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}

-(void)copy:(OrderInfo*)orderInfo {
    self.ID = orderInfo.ID;
    self.orderID = orderInfo.orderID;
    self.storeName = orderInfo.storeName;
    self.storeID = orderInfo.storeID;
    self.roomID = orderInfo.roomID;
    self.time = orderInfo.time;
    self.price = orderInfo.price;
    self.info = orderInfo.info;
    self.state = orderInfo.state;
    self.phoneNumber = orderInfo.phoneNumber;
    self.isCommented = orderInfo.isCommented;
    self.orderType = orderInfo.orderType;
    
    [self.operations removeAllObjects];
    [self.operations addObjectsFromArray:orderInfo.operations];
}

-(void)clearData {
    [self.subOrderList removeAllObjects];
}

-(void)setSubOrderInfo:(NSString*)ID time:(NSString*)time state:(NSString*)state operations:(NSMutableArray*)operations {
    for (SubOrderInfo *subOrderInfo in self.subOrderList) {
        if ([subOrderInfo.ID isEqualToString:ID]) {
            subOrderInfo.info = time;
            subOrderInfo.state = state;
            subOrderInfo.operations = operations;
        }
    }
}

-(BOOL)isNoPayment {
    for (int i=0; i<self.operations.count; i++) {
        NSInteger operation = (NSInteger)[self.operations objectAtIndex:i];
        if (operation == OrderOperationPay) {
            return YES;
        }
    }
    
    return NO;
}

-(void)getInfo:(NSString*)orderID {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: orderID forKey:@"order_id"];
    
    [self.netConnection startConnect:orderDetailUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSString* errMsg = [self parseDetailJson: output];
        if ([errMsg isEqualToString:succeed]) {
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:errMsg forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfo" object:self userInfo:userInfoDic];
}

-(NSString*)parseDetailJson:(NSString*)jsonString {
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDic != nil && error == nil) {
        NSDictionary* contentDic = [jsonDic objectForKey:@"content"];
        if (contentDic != nil && contentDic.count != 0) {
            self.ID = [contentDic objectForKey:@"order_id"];
            self.orderID = [contentDic objectForKey:@"order_sn"];
            self.storeName = [contentDic objectForKey:@"business_name"];
            self.storeID = [contentDic objectForKey:@"business_id"];
            self.roomID = [contentDic objectForKey:@"room_id"];
            self.phoneNumber = [contentDic objectForKey:@"mobile"];
            self.price = [contentDic objectForKey:@"room_amount"];
            self.time = [contentDic objectForKey:@"add_time"];
            self.state = [contentDic objectForKey:@"status"];
            self.address = [contentDic objectForKey:@"address"];
            
            NSArray* subOrderArray = [contentDic objectForKey:@"calendar_list"];
            for (int i = 0; i < subOrderArray.count; i++) {
                NSDictionary* subOrderDic = [subOrderArray objectAtIndex:i];
                SubOrderInfo* info = [[SubOrderInfo alloc] init];
                info.ID = [subOrderDic objectForKey:@"id"];
                info.orderID = [subOrderDic objectForKey:@"calendar_sn"];
                info.state = [subOrderDic objectForKey:@"status"];
                info.info = [subOrderDic objectForKey:@"time"];
                info.price = [subOrderDic objectForKey:@"price"];
                NSArray* operationArray = [subOrderDic objectForKey:@"operable_list"];
                for (int j = 0; j < operationArray.count; j++) {
                    [info.operations addObject:[[operationArray objectAtIndex:i] stringValue]];
                }
                
                [self.subOrderList addObject:info];
            }
        
            return succeed;
        } else {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDic objectForKey:@"is_login" ] boolValue]];
        }
    }
    
    return @"获取订单详情失败";
}

@end
