//
//  ServiceBaseInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "ServiceBaseInfo.h"

@implementation ServiceBaseInfo

-(ServiceBaseInfo*)init {
    self = [super init];
    if (self) {
        self.picUrlArray = [NSMutableArray array];
    }
    return  self;
}

-(void)clearData {
    [self.picUrlArray removeAllObjects];
}

@end
