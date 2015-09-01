//
//  CreateRechargeOrder.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface CreateRechargeOrderTask : NSObject<NetConnectionDelegate>

@property NetConnection* netConnection;
-(void)createRechargeOrder;


@end
