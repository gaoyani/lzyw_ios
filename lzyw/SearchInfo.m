//
//  SearchInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "SearchInfo.h"

@implementation SearchInfo

-(SearchInfo*)init {
    self = [super init];
    if (self) {
        self.fromSearch = NO;
        self.roomSizeArray = [NSMutableArray array];
    }
    
    return self;
}

@end
