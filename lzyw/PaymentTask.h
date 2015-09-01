//
//  PaymentTask.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/15.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

enum PaymentType {
    PaymentTypeNone,
    PaymentTypeLezi,
    PaymentTypeAli,
    PaymentTypeYL
};

@interface PaymentTask : NSObject<NetConnectionDelegate> {
    enum PaymentType paymentType;
}

@property NetConnection* netConnection;

-(void)payOrder:(NSString*)orderID paymentType:(enum PaymentType)type password:(NSString*)password payNum:(int)payNum;
-(void)confirmRechargeOrder:(NSString*)orderID paymentType:(enum PaymentType)type price:(NSString*)price;

@end
