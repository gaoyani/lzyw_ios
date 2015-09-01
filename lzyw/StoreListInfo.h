//
//  StoreListInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchInfo.h"
#import "NetConnection.h"
#import "StoreDetailInfo.h"

enum StoreListType {StoreListTypeRecommend, StoreListTypeAround, StoreListTypeFavorite};

@interface StoreListInfo : NSObject<NetConnectionDelegate>

@property enum StoreListType storeListType;
@property NSMutableArray* recommendStoreArray;
@property NSMutableArray* aroundStoreArray;
@property NSMutableArray* favoriteStoreArray;

@property NetConnection* netConnection;

-(StoreListInfo*)init;
-(NSString*)parseJson:(NSString*)jsonString;
-(void)clearData;
-(void)resetCollect:(StoreDetailInfo*)storeInfo;

-(void)getNetData:(enum StoreListType)type startIndex:(int)startIndex searchInfo:(SearchInfo*)searchInfo;

@end
