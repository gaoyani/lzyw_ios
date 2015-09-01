//
//  RecommendInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "RecommendInfo.h"
#import "NewsInfo.h"
#import "StoreInfo.h"
#import "AppDelegate.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation RecommendInfo

-(RecommendInfo*)init {
    self = [super init];
    if (self) {
        self.leftItemInfo = [[RecommendItemInfo alloc] init];
        self.rightTopItemInfo = [[RecommendItemInfo alloc] init];
        self.rightBottomItemInfo = [[RecommendItemInfo alloc] init];
        
        self.newsArray = [NSMutableArray array];
        self.recommendStoreArray = [NSMutableArray array];
    }
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}

-(void)getData {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:appDelegate.memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[appDelegate.memberInfo getLocation] forKey:@"location"];
    [self.netConnection startConnect:mainPageUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    [self clearData];
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSString* errMsg = [self parseJson: output isLocalData:NO];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateView" object:self userInfo:userInfoDic];
}

-(NSString*)parseJson:(NSString*)jsonString isLocalData:(bool)isLocalData {
    
    NSData *data= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDictionary != nil && error == nil) {
        NSArray* newsArray = [jsonDictionary objectForKey:@"news_list"];
        for(NSDictionary *newsDictionary in newsArray){
            NewsInfo* newsInfo = [NewsInfo alloc];
            newsInfo.newsID = [newsDictionary objectForKey:@"id"];
            newsInfo.title = [newsDictionary objectForKey:@"title"];
            [self.newsArray addObject:newsInfo];
        }
        
        NSDictionary* leftDic = [jsonDictionary objectForKey:@"pic1"];
        self.leftItemInfo.title = [leftDic objectForKey:@"name"];
        self.leftItemInfo.price = [leftDic objectForKey:@"price"];
        self.leftItemInfo.picUrl = [leftDic objectForKey:@"pic"];
        self.leftItemInfo.type = [[leftDic objectForKey:@"type"] integerValue];
        self.leftItemInfo.content = [leftDic objectForKey:@"content"];
        
        NSDictionary* rightTopDic = [jsonDictionary objectForKey:@"pic2"];
        self.rightTopItemInfo.title = [rightTopDic objectForKey:@"name"];
        self.rightTopItemInfo.price = [rightTopDic objectForKey:@"price"];
        self.rightTopItemInfo.picUrl = [rightTopDic objectForKey:@"pic"];
        self.rightTopItemInfo.type = [[rightTopDic objectForKey:@"type"] integerValue];
        self.rightTopItemInfo.content = [rightTopDic objectForKey:@"content"];
        
        NSDictionary* rightBottomDic = [jsonDictionary objectForKey:@"pic3"];
        self.rightBottomItemInfo.title = [rightBottomDic objectForKey:@"name"];
        self.rightBottomItemInfo.price = [rightBottomDic objectForKey:@"price"];
        self.rightBottomItemInfo.picUrl = [rightBottomDic objectForKey:@"pic"];
        self.rightBottomItemInfo.type = [[rightBottomDic objectForKey:@"type"] integerValue];
        self.rightBottomItemInfo.content = [rightBottomDic objectForKey:@"content"];
        
        //    if (!isLocalData) {
        //        leftItemInfo.localPicPath = FileManager.getSDPath()+
        //        Constant.MAIN_PAGE_PIC_DIR+"pic1.jpg";
        //        leftJson.put("pic", leftItemInfo.localPicPath);
        //        rightTopItemInfo.localPicPath = FileManager.getSDPath()+
        //        Constant.MAIN_PAGE_PIC_DIR+"pic2.jpg";
        //        rightTopJson.put("pic", rightTopItemInfo.localPicPath);
        //        rightBottomItemInfo.localPicPath = FileManager.getSDPath()+
        //        Constant.MAIN_PAGE_PIC_DIR+"pic3.jpg";
        //        rightbottomJson.put("pic", rightBottomItemInfo.localPicPath);
        //    }
        
        NSArray* storeArray = [jsonDictionary objectForKey:@"business_list"];
        for(NSDictionary *storeDic in storeArray){
            StoreInfo* storeInfo = [[StoreInfo alloc] init];
            [storeInfo parseJson:storeDic];
//            if (!isLocalData) {
//                storeInfo.localPicPath = FileManager.getSDPath()+
//                Constant.MAIN_PAGE_PIC_DIR+"icon"+i+".jpg";
//                storeJson.put("iconUrl", storeInfo.localPicPath);
//            }
            [self.recommendStoreArray addObject:storeInfo];
        }
        
//        if (!isLocalData) {
//            FileManager.writeTxtFile(Constant.MAIN_PAGE_PIC_DIR,
//                                     Constant.MAIN_PAGE_DATA_FILE_NAME, jsonObject.toString());
//        }
    }
    
    return @"";
   
}

-(void)collectRecommendStore:(NSString*)storeID isCollect:(bool)isCollect; {
    for (StoreInfo* info in self.recommendStoreArray) {
        if ([info.storeID isEqualToString:storeID]) {
            info.favorite = isCollect;
            break;
        }
    }
}

-(void)clearData {
    [self.newsArray removeAllObjects];
    [self.recommendStoreArray removeAllObjects];
}


@end
