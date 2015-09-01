//
//  PublicInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/31.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface RegionInfo : NSObject
    
@property NSString* ID;
@property NSString* name;
    
@end

@interface AreaInfo : NSObject

@property NSString* ID;
@property NSString* name;
@property NSMutableArray* regionArray;

@end

@interface CityInfo : NSObject

@property NSString* ID;
@property NSString* name;
@property NSMutableArray* areaArray;

@end

@interface TimeSlotInfo : NSObject
    
@property NSString* ID;
@property NSString* time;
@property BOOL isBookable;
@property BOOL isReserved;

@end

@interface RoomSizeInfo : NSObject
    
@property NSString* ID;
@property NSString* name;
@property BOOL isSelected;

@end


@interface PublicInfo : NSObject<NetConnectionDelegate>

@property int cppMax;
@property int cppMin;
@property NSMutableArray* roomSizeArray;
@property NSMutableArray* cityArray;
@property NSMutableArray* resTypeArray;
@property NSMutableArray* complaintReasonArray;

@property NetConnection* netConnection;

-(PublicInfo*)init;
-(NSString*)parseJson:(NSString*)jsonString;
-(void)clearData;

-(void)getNetData;

-(int)getResTypeIndex:(NSString*)resType;

@end
