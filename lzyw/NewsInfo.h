//
//  NewsInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface NewsInfo : NSObject<NetConnectionDelegate>

@property NSString* newsID;
@property NSString* name;
@property NSString* title;
@property NSString* author;
@property NSString* time;
@property NSString* scanTimes;
@property NSString* content;
@property BOOL isCommented;

@property NetConnection* netConnection;

-(void)getInfo:(NSString*)newsID;

@end
