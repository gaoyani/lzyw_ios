//
//  ServiceBaseInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceBaseInfo : NSObject

@property NSString* iconUrl;
@property NSString* serviceID;
@property NSString* name;
@property NSString* nameTitle;
@property NSString* priceType;
@property NSString* price;
@property NSString* otherTitle;
@property NSString* otherInfo;

@property NSString* consumeTitle;
@property NSString* consumeValue;
@property NSString* consumeOriginal;

@property int hot;
@property bool bookable;
@property bool isOrdered;
@property bool isCommented;
@property bool isComplainted;

@property NSString* picture360Url;
@property NSMutableArray* picUrlArray;
//public List<CommentInfo> commentList = new ArrayList<CommentInfo>();

-(ServiceBaseInfo*)init;
-(void)clearData;

@end
