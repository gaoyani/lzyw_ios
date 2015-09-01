//
//  QRInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface QRInfo : NSObject<NetConnectionDelegate>

@property NSString* qrUrl;
@property NSString* note;
@property NSString* shareInfo;

@property NetConnection* netConnection;

-(void)getInfo;

@end
