//
//  StoreInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface StoreInfo : NSObject<NetConnectionDelegate>

@property NSString* iconUrl;
@property NSString* storeID;
@property NSString* name;
@property NSString* cpp;
@property NSString* address;
@property NSString* distance;

@property float stars;
@property BOOL favorite;
@property int classify;
@property double longitude;
@property double latitude;

@property NSString* localPicPath;

@property NetConnection* netConnection;

@property BOOL isCollectResult;
-(void)collect:(BOOL)isCollect;
-(void)parseJson:(NSDictionary*)dictionaryInfo;
-(NSString*)parseCollectResult:(NSString*)result;

@end
