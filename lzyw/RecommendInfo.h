//
//  RecommendInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendItemInfo.h"
#import "NetConnection.h"

@interface RecommendInfo : NSObject<NetConnectionDelegate>

@property NSMutableArray* newsArray;
@property NSMutableArray* recommendStoreArray;

@property RecommendItemInfo* leftItemInfo;
@property RecommendItemInfo* rightTopItemInfo;
@property RecommendItemInfo* rightBottomItemInfo;

@property NetConnection* netConnection;

-(RecommendInfo*)init;
-(NSString*)parseJson:(NSString*)jsonString isLocalData:(bool)isLocalData;
-(void)collectRecommendStore:(NSString*)storeID isCollect:(bool)isCollect;
-(void)clearData;

-(void)getData;

@end
