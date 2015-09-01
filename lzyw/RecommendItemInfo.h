//
//  RecommendItemInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

enum RecommendType {RecommendTypeStore=1, RecommendTypeNews=2, RecommendTypeWeb=3};

@interface RecommendItemInfo : NSObject

@property NSString* picUrl;
@property NSString* title;
@property NSString* price;
@property NSString* content;
@property int type;

@property NSString* localPicPath;

-(RecommendItemInfo*)init;

@end
