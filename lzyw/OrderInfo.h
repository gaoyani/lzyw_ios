//
//  OrderInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

enum OrderOperation {
    OrderOperationNone,
    OrderOperationDelete,
    OrderOperationComment,
    OrderOperationReorder,
    OrderOperationCancel,
    OrderOperationConfirm,
    OrderOperationPay
};

@interface OrderInfo : NSObject<NetConnectionDelegate>

@property NSString* ID;
@property NSString* orderID;
@property NSString* storeName;
@property NSString* storeID;
@property NSString* roomID;
@property NSString* time;
@property NSString* price;
@property NSString* info;
@property NSString* state;
@property NSString* phoneNumber;
@property int orderType;
@property BOOL isCommented;
@property NSMutableArray* operations;

@property NetConnection* netConnection;
-(void)operationOrder:(int)operation;

-(void)parseJson:(NSDictionary*)jsonDic;

@end
