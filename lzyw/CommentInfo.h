//
//  CommentInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

enum CommentTarget {
    CommentTargetStore,
    CommentTargetRoom,
    CommentTargetNews,
    CommentTargetOrder,
    CommentTargetService
};

@interface CommentInfo : NSObject<NetConnectionDelegate>

@property NSString* orderID;
@property NSString* storeID;
@property NSString* newsID;
@property NSString* name;
@property NSString* time;
@property float stars;
@property NSString* comment;

@property BOOL isComment;
@property BOOL isStartComment;
@property NSString* info;

@property NetConnection* netConnection;
-(void)submit:(enum CommentTarget)commentTarget;

-(void)parseJson:(NSDictionary*)jsonDic;

@end
