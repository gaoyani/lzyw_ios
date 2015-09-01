//
//  ModifyMemberInfoTask.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/5.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface ModifyMemberInfoTask : NSObject<NetConnectionDelegate>

@property NetConnection* netConnection;

-(void)modifyUserInfo:(UIImage*)picImage picFileName:(NSString*)picFileName;
@end
