//
//  AlipayManager.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/23.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlipayResultTask.h"

enum PayResult {
    PayResultSuccess,
    PayResultFail,
    PayResultCheck
};

@protocol AlipayManagerDelegate <NSObject>

-(void)payResult:(enum PayResult)result;

@end

@interface AlipayManager : NSObject {
    NSTimer *timer;
    AlipayResultTask* alipayResultTask;
    NSString* orderID;
    BOOL isRecharge;
}

@property(assign,nonatomic)id<AlipayManagerDelegate> delegate;

-(void)pay:(NSString*)orderInfo orderID:(NSString*)ID isRecharge:(BOOL)is;
-(void)stopGetResultTimer;

@end
