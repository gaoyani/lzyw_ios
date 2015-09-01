//
//  StoreDetailInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/23.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreInfo.h"
#import "NetConnection.h"

enum ServiceType {ServiceTypeRoom, ServiceTypeService, ServiceTypeArtificer};

@interface StoreDetailInfo : StoreInfo<NetConnectionDelegate>

@property NSString* service;
@property NSString* recommend;
@property NSString* phoneNumber;
@property NSString* time;
@property NSString* picture360Url;
@property NSString* storeTips;
@property NSString* roomNum;
@property NSString* serviceNum;
@property int favoriteNum;
@property bool isOrdered;
@property bool isCommented;
@property bool isComplainted;

@property NSString* consumeTitle;
@property NSString* consumeValue;

@property NSMutableArray* picUrlArray;
@property NSMutableArray* newsArray;
@property NSMutableArray* roomArray;

//public List<RoomInfo> roomList = new ArrayList<RoomInfo>();
//public List<ServiceInfo> serviceList = new ArrayList<ServiceInfo>();
//public List<ArtificerInfo> artificerList = new ArrayList<ArtificerInfo>();

@property NetConnection* netConnection;

-(StoreDetailInfo*)init;
-(NSString*)parseJson:(NSString*)jsonString;
-(void)clearData;

-(void)getNetData:(NSString*)storeID startIndex:(int)startIndex serviceType:(int)type;

@end
