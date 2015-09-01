//
//  OrderDetialInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "OrderInfo.h"
#import "NetConnection.h"

enum SubOrderOperation {
    SubOrderOperationNone,
    SubOrderOperationCancel,
    SubOrderOperationReorder,
    SubOrderOperationDelete
};

@interface SubOrderInfo : NSObject<NetConnectionDelegate>
@property NSString* ID;
@property NSString* orderID;
@property NSString* info;
@property NSString* price;
@property NSString* state;

@property NSMutableArray* operations;

@property NetConnection* netConnection;
-(void)operationOrder:(int)operation;

@end

@interface OrderDetailInfo : OrderInfo<NetConnectionDelegate>

@property NSString* address;
@property NSMutableArray* subOrderList;

@property NetConnection* netConnection;

-(void)copy:(OrderInfo*)orderInfo;
-(void)setSubOrderInfo:(NSString*)ID time:(NSString*)time state:(NSString*)state operations:(NSMutableArray*)operations;
-(BOOL)isNoPayment;

-(void)getInfo:(NSString*)orderID;

@end
