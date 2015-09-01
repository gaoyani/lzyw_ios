//
//  NewsInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "NewsInfo.h"
#import "AppDelegate.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "Utils.h"

@implementation NewsInfo

-(NewsInfo*)init {
    self = [super init];
    if (self) {
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}

-(void)getInfo:(NSString*)newsID {
    self.newsID = newsID;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:newsID forKey:@"news_id"];
    
    [self.netConnection startConnect:newsInfoUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSString* errMsg = [self parseJson: output];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfo" object:self userInfo:userInfoDic];
}

-(NSString*)parseJson:(NSString*)jsonString {
    
    NSData *data= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (jsonDictionary != nil && error == nil) {
        NSDictionary* contentDic = [jsonDictionary objectForKey:@"content"];
        self.title = [contentDic objectForKey:@"title"];
        self.author = [contentDic objectForKey:@"author"];
        self.scanTimes = [contentDic objectForKey:@"click_count"];
        self.time = [contentDic objectForKey:@"add_time"];
        self.isCommented = [[contentDic objectForKey:@"is_comment"] boolValue];
        
        NSString* content = [contentDic objectForKey:@"content"];
        self.content = [content stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
        
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDictionary objectForKey:@"is_login" ] boolValue]];

        return @"";
    }
    
    return @"获取优惠资讯失败";
}


@end
