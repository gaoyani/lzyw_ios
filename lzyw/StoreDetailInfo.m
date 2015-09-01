//
//  StoreDetailInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/23.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreDetailInfo.h"
#import "AppDelegate.h"
#import "NewsInfo.h"
#import "RoomInfo.h"
#import "Utils.h"
#import "Constants.h"
#import "UrlConstants.h"

@implementation StoreDetailInfo

-(StoreDetailInfo*)init {
    self = [super init];
    if (self) {
        self.picUrlArray = [NSMutableArray array];
        self.newsArray = [NSMutableArray array];
        self.roomArray = [NSMutableArray array];
        
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    return  self;
}

-(void)getNetData:(NSString*)storeID startIndex:(int)startIndex serviceType:(int)type {
    self.isCollectResult = NO;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:storeID forKey:@"business_id"];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[appDelegate.memberInfo getLocation] forKey:@"location"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:[NSNumber numberWithInt:startIndex] forKey:@"p"];
    NSLog(@"StoreDetailInfo:%@", [[UIDevice currentDevice].identifierForVendor UUIDString]);
    
    [self.netConnection startConnect:storeInfoUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSString* errMsg = (self.isCollectResult ? [self parseCollectResult:output] : [self parseJson: output]);
        if ([errMsg isEqualToString:@""]) {
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:errMsg forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:(self.isCollectResult ? @"collectResult" : @"updateInfo") object:self userInfo:userInfoDic];
}


-(NSString*)parseJson:(NSString*)jsonString {
    
    NSData *data= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDictionary != nil && error == nil) {
        int errorCode = (int)[[jsonDictionary objectForKey:@"error"] integerValue];
        if (errorCode != 0) {
            return [jsonDictionary objectForKey:@"message"];
        }
        
        NSDictionary* contentDic = [jsonDictionary objectForKey:@"content"];
        self.storeID = [contentDic objectForKey:@"business_id"];
        self.name = [contentDic objectForKey:@"name"];
        self.address = [contentDic objectForKey:@"address"];
        self.iconUrl = [contentDic objectForKey:@"iconUrl"];
        self.stars = [[contentDic objectForKey:@"recommend"] integerValue];
        self.cpp = [contentDic objectForKey:@"cpp"];
        self.service = [contentDic objectForKey:@"service"];
        self.phoneNumber = [contentDic objectForKey:@"phoneNumber"];
        self.distance = [contentDic objectForKey:@"distance"];
        self.time = [contentDic objectForKey:@"time"];
        self.recommend = [contentDic objectForKey:@"food"];
        self.consumeTitle = [contentDic objectForKey:@"feildname"];
        self.consumeValue = [contentDic objectForKey:@"consumption"];
        self.storeTips = [contentDic objectForKey:@"merchantTips"];
        self.roomNum = [contentDic objectForKey:@"room_numb"];
        self.serviceNum = [contentDic objectForKey:@"serviceNumber"];
        self.favorite = [[contentDic objectForKey:@"favorite"] boolValue];
        
        self.favoriteNum = (int)[[contentDic objectForKey:@"favoriteNum"] integerValue];
        self.isOrdered = [contentDic objectForKey:@"is_order"];
        self.isCommented = [contentDic objectForKey:@"is_comment"];
        self.isComplainted = [contentDic objectForKey:@"is_complain"];
        
        NSString* location = [contentDic objectForKey:@"map_label"];
        NSArray *coordinate = [location componentsSeparatedByString:@","];
        self.longitude = [((NSString*)[coordinate objectAtIndex:0]) doubleValue];
        self.latitude = [((NSString*)[coordinate objectAtIndex:1]) doubleValue];
        
        self.picture360Url = [contentDic objectForKey:@"picture360Url"];
        NSArray* picArray = [contentDic objectForKey:@"common_pic"];
        for(int i = 0; i<picArray.count; i++){
            [self.picUrlArray addObject:[picArray objectAtIndex:i]];
        }
        [self.picUrlArray addObject:@"http://i0.sinaimg.cn/ent/v/m/2013-03-06/U1584P28T3D3870792F326DT20130306113039.jpg"];
        [self.picUrlArray addObject:@"http://fd.topit.me/d/f6/39/118271509435639f6dl.jpg"];
        [self.picUrlArray addObject:@"http://i3.cqnews.net/ent/attachement/jpg/site82/2012-06-01/4203302175931412548.jpg"];
        [self.picUrlArray addObject:@"http://www.cnnb.com.cn/pic/0/00/68/30/683066_483723.jpg"];
        [self.picUrlArray addObject:@"http://news.xinhuanet.com/ent/2011-01/27/121031526_31n.jpg"];
        
        NSArray* newsArray = [contentDic objectForKey:@"news_list"];
        for(NSDictionary *newsDictionary in newsArray){
            NewsInfo* newsInfo = [NewsInfo alloc];
            newsInfo.newsID = [newsDictionary objectForKey:@"id"];
            newsInfo.title = [newsDictionary objectForKey:@"title"];
            [self.newsArray addObject:newsInfo];
        }
        
        NSArray* roomArray = [contentDic objectForKey:@"room_list"];
        for(NSDictionary *roomDic in roomArray) {
            RoomInfo* roomInfo = [[RoomInfo alloc] init];
            [roomInfo parseJson:roomDic];
            [self.roomArray addObject:roomInfo];
        }
        
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDictionary objectForKey:@"is_login" ] boolValue]];
    }
    
    return @"";
}

-(void)clearData {
    [self.newsArray removeAllObjects];
    [self.picUrlArray removeAllObjects];
}

@end
