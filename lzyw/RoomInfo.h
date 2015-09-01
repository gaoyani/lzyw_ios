//
//  RoomInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceBaseInfo.h"
#import "NetConnection.h"

@interface RoomInfo : ServiceBaseInfo<NetConnectionDelegate>

@property NSString* roomClassify;

@property NSString* feature;
@property NSString* recommend;
@property NSString* privilegeID;
@property NSString* privilegeTitle;

@property NSMutableArray* todayTimeArray;

@property NetConnection* netConnection;

-(RoomInfo*)init;
-(void)clearData;

-(void)getNetData:(NSString*)roomID;

-(void)parseJson:(NSDictionary*)jsonDic;
-(NSString*)parseDetailJson:(NSString*)jsonString;

@end
