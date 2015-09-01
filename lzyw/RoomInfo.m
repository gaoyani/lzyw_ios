//
//  RoomInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "RoomInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Constants.h"
#import "UrlConstants.h"

@implementation RoomInfo

-(RoomInfo*)init {
    self = [super init];
    if (self) {
        self.todayTimeArray = [NSMutableArray array];
    }
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}

-(void)getNetData:(NSString*)roomID {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:roomID forKey:@"room_id"];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    
    [self.netConnection startConnect:roomInfoUrl paramsDictionary:paramsDic];
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

-(void)parseJson:(NSDictionary*)jsonDic {
    self.serviceID = [jsonDic objectForKey:@"room_id"];
    self.name = [jsonDic objectForKey:@"room_name"];
    self.nameTitle = [jsonDic objectForKey:@"nameTitle"];
    self.priceType = [jsonDic objectForKey:@"price_name"];
    self.price = [jsonDic objectForKey:@"price"];
    self.otherInfo = [jsonDic objectForKey:@"otherInfo"];
    self.otherTitle = [jsonDic objectForKey:@"otherTitle"];
    self.iconUrl = [jsonDic objectForKey:@"iconUrl"];
    self.feature = [jsonDic objectForKey:@"special"];
    self.consumeTitle = [jsonDic objectForKey:@"feildname"];
    self.consumeValue = [jsonDic objectForKey:@"consumption"];
    self.bookable = [jsonDic objectForKey:@"noreserv"];
}

-(NSString*)parseDetailJson:(NSString*)jsonString {
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDic != nil && error == nil) {
        NSDictionary* contentDic = [jsonDic objectForKey:@"content"];
        if (contentDic != nil && contentDic.count != 0) {
            [self clearData];
            
            [self parseJson:contentDic];
            self.recommend = [contentDic objectForKey:@"recommend"];
            self.picture360Url = [contentDic objectForKey:@"picture360Url"];
            self.roomClassify = [contentDic objectForKey:@"cat_name"];
            self.isOrdered = [[contentDic objectForKey:@"is_order"] boolValue];
            self.isCommented = [[contentDic objectForKey:@"is_comment"] boolValue];
            self.isComplainted = [[contentDic objectForKey:@"is_complain"] boolValue];
            self.hot = [[contentDic objectForKey:@"room_hot"] integerValue];
            
            NSDictionary* privilegeDic = [contentDic objectForKey:@"privilege"];
            if (privilegeDic == nil || privilegeDic.count == 0) {
                self.privilegeID = @"0";
                self.privilegeTitle = @"";
            } else {
                self.privilegeID = [privilegeDic objectForKey:@"id"];
                self.privilegeTitle = [privilegeDic objectForKey:@"title"];
            }
            
            NSArray* picArray = [contentDic objectForKey:@"common_pic"];
            for (int i=0; i<picArray.count; i++) {
                [self.picUrlArray addObject:[picArray objectAtIndex:i]];
            }
            
            NSArray* timeArray = [contentDic objectForKey:@"calendar_list"];
            for (NSDictionary* timeDic in timeArray) {
                TimeSlotInfo* info = [[TimeSlotInfo alloc] init];
                info.ID = [timeDic objectForKey:@"id"];
                info.time = [timeDic objectForKey:@"time"];
                info.isBookable = [[timeDic objectForKey:@"disable"] boolValue];
                [self.todayTimeArray addObject:info];
            }
            
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDic objectForKey:@"is_login" ] boolValue]];
            
            return succeed;
        }
    }
    
    return @"获取包间详情失败";
}

-(void)clearData {
    [super clearData];
}

@end
