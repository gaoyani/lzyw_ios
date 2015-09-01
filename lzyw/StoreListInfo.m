//
//  StoreListInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "StoreListInfo.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "StoreInfo.h"

@implementation StoreListInfo

-(StoreListInfo*)init {
    self = [super init];
    if (self) {
        self.recommendStoreArray = [NSMutableArray array];
        self.aroundStoreArray = [NSMutableArray array];
        self.favoriteStoreArray = [NSMutableArray array];
        
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}

-(void)resetCollect:(StoreDetailInfo*)storeInfo {
//    StoreDetailInfo* storeInfo = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).storeDetailInfo;
    if (![storeInfo.storeID isEqualToString:@""]) {
        for (StoreInfo* info in self.recommendStoreArray) {
            if ([info.storeID isEqualToString:storeInfo.storeID]) {
                info.favorite = storeInfo.favorite;
            }
        }
        
        for (StoreInfo* info in self.aroundStoreArray) {
            if ([info.storeID isEqualToString:storeInfo.storeID]) {
                info.favorite = storeInfo.favorite;
            }
        }
        
        StoreInfo* selStoreInfo = nil;
        for (StoreInfo* info in self.favoriteStoreArray) {
            if ([info.storeID isEqualToString:storeInfo.storeID]) {
                selStoreInfo = info;
            }
        }
        
        if (selStoreInfo != nil) {
            [self.favoriteStoreArray removeObject:selStoreInfo];
        }
        
        if (storeInfo.favorite) {
            [self.favoriteStoreArray addObject:storeInfo];
        }
    }
}

-(void)getNetData:(enum StoreListType)type startIndex:(int)startIndex searchInfo:(SearchInfo*)searchInfo {
    self.storeListType = type;
    if (startIndex == 0) {
         [self clearData];
    }
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString * urlString = @"";
    if (type == StoreListTypeRecommend) {
        urlString = recommendStoreListUrl;
    } else if (type == StoreListTypeAround) {
        urlString = aroundStoreListUrl;
    } else {
        urlString = collectStoreListUrl;
    }
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[appDelegate.memberInfo getLocation] forKey:@"location"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:[NSNumber numberWithInt:startIndex] forKey:@"p"];
    [paramsDic setValue:[NSNumber numberWithInt:searchInfo.classifyID] forKey:@"cat_id"];
    [paramsDic setValue:searchInfo.fromSearch ? [NSNumber numberWithInt:searchInfo.cppMin] : @"" forKey:@"cpp_min"];
    [paramsDic setValue:searchInfo.fromSearch ? [NSNumber numberWithInt:searchInfo.cppMax] : @"" forKey:@"cpp_max"];
    [paramsDic setValue:searchInfo.fromSearch ? [NSString stringWithFormat:@"%f", searchInfo.recommend] : @"" forKey:@"recommend"];
    
    if (type == StoreListTypeRecommend) {
        [paramsDic setValue:searchInfo.fromSearch ? searchInfo.cityID : @"" forKey:@"city"];
        [paramsDic setValue:searchInfo.fromSearch ? searchInfo.areaID : @"" forKey:@"district"];
        [paramsDic setValue:searchInfo.fromSearch ? searchInfo.regionID : @"" forKey:@"area"];
    }
    
    NSMutableArray *roomTypes = [NSMutableArray array];
    for(int i=0; i<searchInfo.roomSizeArray.count; i++) {
        [roomTypes addObject:[searchInfo.roomSizeArray objectAtIndex:i]];
    }
    [paramsDic setValue:searchInfo.fromSearch ? roomTypes : @"" forKey:@"room_types"];
    
    [self.netConnection startConnect:urlString paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSString* msg = [self parseJson: output];
        if (msg == succeed) {
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:loadComplate];
        } else if (msg == loadComplate) {
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:loadComplate];
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:msg forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }

     [[NSNotificationCenter defaultCenter] postNotificationName:@"updateStoreList" object:self userInfo:userInfoDic];
}

-(NSString*)parseJson:(NSString*)jsonString {
    NSData *data= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDictionary != nil && error == nil) {
        NSArray* storeArray = [jsonDictionary objectForKey:@"content"];
        if (storeArray.count != 0) {
            for (NSDictionary* storeDic in storeArray) {
                StoreInfo* storeInfo = [[StoreInfo alloc] init];
                [storeInfo parseJson:storeDic];
                if (self.storeListType == StoreListTypeRecommend) {
                    [self.recommendStoreArray addObject:storeInfo];
                } else if (self.storeListType == StoreListTypeAround) {
                    [self.aroundStoreArray addObject:storeInfo];
                } else {
                    [self.favoriteStoreArray addObject:storeInfo];
                }
            }
            
            return succeed;
            
        } else {
            return loadComplate;
        }
    }
    
    return @"获取商户列表失败";
}

-(void)clearData {
    if (self.storeListType == StoreListTypeRecommend) {
        [self.recommendStoreArray removeAllObjects];
    } else if (self.storeListType == StoreListTypeAround) {
        [self.aroundStoreArray removeAllObjects];
    } else {
        [self.favoriteStoreArray removeAllObjects];
    }
}



@end
