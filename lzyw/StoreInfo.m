//
//  StoreInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreInfo.h"
#import "AppDelegate.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "Utils.h"

@implementation StoreInfo

-(StoreInfo*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    self.isCollectResult = NO;
    
    return self;
}

-(void)parseJson:(NSDictionary*)dictionaryInfo {
    self.storeID = [dictionaryInfo objectForKey:@"business_id"];
    self.name = [dictionaryInfo objectForKey:@"name"];
    self.iconUrl = [dictionaryInfo objectForKey:@"iconUrl"];
    self.address = [dictionaryInfo objectForKey:@"address"];
    self.distance = [dictionaryInfo objectForKey:@"distance"];
    self.stars = [[dictionaryInfo objectForKey:@"recommend"] floatValue];
    self.cpp = [dictionaryInfo objectForKey:@"cpp"];
    self.favorite = [[dictionaryInfo objectForKey:@"favorite"] boolValue];
}

-(void)collect:(BOOL)isCollect {
    self.isCollectResult = YES;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:self.storeID forKey:@"business_id"];
    [paramsDic setValue:isCollect ? @"1" : @"0" forKey:@"collect"];
    
    [self.netConnection startConnect:collectStoreUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setValue:self.storeID forKey:@"store_id"];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSString* errMsg = [self parseCollectResult:output];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectResult" object:self userInfo:userInfoDic];
}

-(NSString*)parseCollectResult:(NSString*)result {
    NSData *data= [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (jsonDictionary != nil && error == nil) {
        int errorCode = (int)[[jsonDictionary objectForKey:@"error"] integerValue];
        if (errorCode == 0) {
            return @"";
        } else {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDictionary objectForKey:@"is_login" ] boolValue]];
            return [jsonDictionary objectForKey:message];
        }
    }

    return @"收藏商户失败";
}


@end
