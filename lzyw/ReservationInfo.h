//
//  ReservationInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/3.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberInfo.h"
#import "NetConnection.h"

enum ReservationVia { ReservationViaRoom, ReservationViaOrder, ReservationViaSubOrder};

@interface ReservationInfo : NSObject<NetConnectionDelegate>

@property NSString* storeIconUrl;
@property NSString* storeName;
@property NSString* storePhone;
@property NSString* priceType;
@property NSString* price;
@property NSString* roomName;
@property NSString* roomInfo;
@property NSString* storeTips;

@property NSString* subOrderID;
@property NSString* orderID;
@property NSString* time;
@property NSMutableArray* timeList;
@property NSString* contacts;
@property NSString* phoneNum;
@property enum SexType sex;
@property NSString* type;
@property int peopleNum;
@property NSString* otherInfo;

@property BOOL isSubmit;

@property NetConnection* netConnection;

-(void)getInfo:(NSString*)orderID subOrderID:(NSString*)subOrderID;

-(void)submitRoomReservationInfo;

@end
