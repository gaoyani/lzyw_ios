//
//  AlipayResultTask.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/23.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface AlipayResultTask : NSObject<NetConnectionDelegate>

@property NetConnection* netConnection;
-(void)getPayResult:(NSString*)orderID isRecharge:(BOOL)isRecharge;

@end
