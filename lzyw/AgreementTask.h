//
//  AgreementTask.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/11.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface AgreementTask : NSObject<NetConnectionDelegate>

@property NetConnection* netConnection;

-(void)getAgreement:(int)agreementType;

@end
