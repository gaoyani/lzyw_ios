//
//  CommonData.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/18.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "CommonData.h"

static int CELL_HEIGHT = 80;

@implementation CommonData

-(CommonData *)initData {
    self = [super init];
    if (self) {
        
        self.categoryTitles = [NSMutableArray arrayWithCapacity:8];
        [self.categoryTitles addObject:@"洗浴"];
        [self.categoryTitles addObject:@"足疗"];
        [self.categoryTitles addObject:@"KTV"];
        [self.categoryTitles addObject:@"会所"];
        [self.categoryTitles addObject:@"餐饮包房"];
        [self.categoryTitles addObject:@"茶室咖啡"];
        [self.categoryTitles addObject:@"美容美体"];
        [self.categoryTitles addObject:@"更多"];
        
        self.categoryImgNames = [NSMutableArray arrayWithCapacity:8];
        [self.categoryImgNames addObject:@"classify_xy_"];
        [self.categoryImgNames addObject:@"classify_zl_"];
        [self.categoryImgNames addObject:@"classify_ktv_"];
        [self.categoryImgNames addObject:@"classify_hs_"];
        [self.categoryImgNames addObject:@"classify_cy_"];
        [self.categoryImgNames addObject:@"classify_cs_"];
        [self.categoryImgNames addObject:@"classify_jd_"];
        [self.categoryImgNames addObject:@"classify_gd_"];
    }
    return self;
}

@end
