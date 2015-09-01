//
//  AlipayManager.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/23.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Constants.h"
#import "Utils.h"

@implementation AlipayManager

-(AlipayManager*)init {
    self = [super init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(getPayResult:)
     name:@"getPayResult"
     object:nil];
    
    alipayResultTask = [[AlipayResultTask alloc] init];
    
    return self;
}

-(void)pay:(NSString*)orderInfo orderID:(NSString*)ID isRecharge:(BOOL)is {
    orderID = ID;
    isRecharge = is;
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:@"lzyw" callback:^(NSDictionary *resultDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int resultSuccess = [[resultDic objectForKey:@"ResultStatus"] intValue];
            if (resultSuccess == 9000) {
//                [self startGetResultTimer];
                [NSThread detachNewThreadSelector:@selector(startGetResultTimer) toTarget:self withObject:nil];
                [self.delegate payResult:PayResultCheck];
                NSLog(@"支付成功");
            } else {
                [Utils showMessage:[resultDic objectForKey:@"memo"]];
                NSLog(@"支付失败");
            }
        });
    }];
}

-(void)startGetResultTimer {
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

-(void)timerAction {
    [alipayResultTask getPayResult:orderID isRecharge:isRecharge];
}

-(void)stopGetResultTimer {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)getPayResult:(NSNotification*)notification {
    BOOL isSucceed = [notification.userInfo objectForKey:succeed];
    if (isSucceed) {
        [self.delegate payResult:PayResultSuccess];
    } else {
        [self.delegate payResult:PayResultFail];
    }
    
    [self stopGetResultTimer];
}

@end