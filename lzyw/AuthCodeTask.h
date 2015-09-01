//
//  AuthCodeManager.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/28.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface AuthCodeTask: NSObject<NetConnectionDelegate>

@property NetConnection* netConnection;
-(void)getAuthCode:(NSString*)phoneNumber autoCodeUrl:(NSString*)autoCodeUrl;

@end
