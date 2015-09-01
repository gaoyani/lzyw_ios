//
//  SearchInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchInfo : NSObject

@property BOOL fromSearch;
@property int classifyID;
@property NSMutableArray* roomSizeArray;
@property int cppMin;
@property int cppMax;
@property float recommend;
@property NSString* cityID;
@property NSString* areaID;
@property NSString* regionID;

-(SearchInfo*)init;

@end
