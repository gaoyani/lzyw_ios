//
//  CommentInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "CommentInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation CommentInfo

-(CommentInfo*)init {
    self = [super init];
    if (self) {
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}

-(void)submit:(enum CommentTarget)commentTarget {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:[NSString stringWithFormat:@"%f",self.stars] forKey:@"rank"];
    [paramsDic setValue:self.comment forKey:@"content"];
    
    switch (commentTarget) {
        case CommentTargetStore:
            [paramsDic setValue:appDelegate.storeDetailInfo.storeID forKey:@"business_id"];
            break;
            
        case CommentTargetRoom:
            [paramsDic setValue:appDelegate.storeDetailInfo.storeID forKey:@"business_id"];
            [paramsDic setValue:appDelegate.roomInfo.serviceID forKey:@"room_id"];
            break;
            
        case CommentTargetService:
            [paramsDic setValue:appDelegate.storeDetailInfo.storeID forKey:@"business_id"];
//            param.put("sid", Data.serviceInfo.id);
            break;
            
        case CommentTargetNews:
//            param.put("news_id", info.newsID);
            break;
            
        case CommentTargetOrder:
            [paramsDic setValue:self.storeID forKey:@"business_id"];
            [paramsDic setValue:self.orderID forKey:@"order_id"];
            break;
            
        default:
            break;
    }
    
    [self.netConnection startConnect:submitCommentUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setValue:self.orderID forKey:@"order_id"];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSData* jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (jsonDic != nil && error == nil) {
            int errorCode = [[jsonDic objectForKey:@"error"] integerValue];
            if (errorCode == 0) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:errorMessage];
                [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDic objectForKey:@"is_login" ] boolValue]];
            }
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"提交评价失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"submitResult" object:self userInfo:userInfoDic];
}


-(void)parseJson:(NSDictionary*)jsonDic {
    self.comment = [jsonDic objectForKey:@"comment"];
    self.name = [jsonDic objectForKey:@"name"];
    self.orderID = [jsonDic objectForKey:@"order_id"];
    self.storeID = [jsonDic objectForKey:@"business_id"];
    self.info = [jsonDic objectForKey:@"info"];
    self.isComment = [[jsonDic objectForKey:@"is_comment"] boolValue];
    self.stars = [[jsonDic objectForKey:@"stars"] floatValue];
}

@end
