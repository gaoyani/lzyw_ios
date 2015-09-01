//
//  ReservationInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/3.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ReservationInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "UrlConstants.h"

@implementation ReservationInfo

-(ReservationInfo*)init {
    self = [super init];
    if (self) {
        self.timeList = [NSMutableArray array];
        self.isSubmit = NO;
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}

-(void)getInfo:(NSString*)orderID subOrderID:(NSString*)subOrderID {
    self.isSubmit = NO;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: orderID forKey:@"order_id"];
    [paramsDic setValue: subOrderID forKey:@"calendar_id"];
    
    [self.netConnection startConnect:reservationDetailUrl paramsDictionary:paramsDic];
}

-(void)submitRoomReservationInfo {
    self.isSubmit = YES;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue: appDelegate.roomInfo.serviceID forKey:@"room_id"];
    [paramsDic setValue: self.time forKey:@"time"];
    [paramsDic setValue: self.contacts forKey:@"contact"];
    [paramsDic setValue: self.phoneNum forKey:@"phone_number"];
    [paramsDic setValue: [NSNumber numberWithInt:self.sex] forKey:@"order_call"];
    [paramsDic setValue: [NSNumber numberWithInt:self.peopleNum] forKey:@"man_num"];
    [paramsDic setValue: self.type forKey:@"type"];
    [paramsDic setValue: self.otherInfo forKey:@"other_info"];
    
    NSMutableArray* timeArray = [NSMutableArray array];
    for (NSString* timeSlotID in self.timeList) {
        [timeArray addObject:timeSlotID];
    }
    [paramsDic setValue: timeArray forKey:@"time_list"];

    [self.netConnection startConnect:addRoomOrderUrl paramsDictionary:paramsDic];
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
                if (self.isSubmit) {
                    NSMutableArray* infoArray = [NSMutableArray array];
                    [infoArray addObject:[[contentDic objectForKey:@"order_id"] stringValue]];
                    [infoArray addObject:[contentDic objectForKey:@"order_sn"]];
                    [infoArray addObject:[[contentDic objectForKey:@"price"] stringValue]];
                    
                    [userInfoDic setValue:infoArray forKey:message];

                } else {
                    [self parseJson:contentDic];
                }
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:errorMessage];
            }
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:(self.isSubmit ? @"提交订单失败" : @"获取预定信息失败") forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.isSubmit ? @"submitReservationResult" : @"updateInfo" object:self userInfo:userInfoDic];
}

-(void)parseJson:(NSDictionary*)contentDic {
    self.storeName = [contentDic objectForKey:@"storeName"];
    self.storeIconUrl = [contentDic objectForKey:@"storeIconUrl"];
    self.priceType = [contentDic objectForKey:@"price_name"];
    self.price = [contentDic objectForKey:@"price"];
    self.storePhone = [contentDic objectForKey:@"storePhone"];
    self.roomName = [contentDic objectForKey:@"roomName"];
    self.storeTips = [contentDic objectForKey:@"storeTips"];
    self.orderID = [contentDic objectForKey:@"orderID"];
    self.contacts = [contentDic objectForKey:@"contacts"];
    self.phoneNum = [contentDic objectForKey:@"phoneNum"];
    self.type = [contentDic objectForKey:@"type"];
    self.otherInfo = [contentDic objectForKey:@"otherInfo"];
    self.time = [contentDic objectForKey:@"time"];
    self.roomInfo = [contentDic objectForKey:@"roomInfo"];
    
    NSArray* timeArray = [contentDic objectForKey:@"timeList"];
    for (int i = 0; i < timeArray.count; i++) {
        [self.timeList addObject:[[timeArray objectAtIndex:i] stringValue]];
    }
}

@end
