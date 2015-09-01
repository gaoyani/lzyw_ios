//
//  PointInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "PointInfo.h"

@implementation PointInfo

-(void)parseJson:(NSDictionary*)jsonDic {
    self.name = [jsonDic objectForKey:@"name"];
    self.price = [jsonDic objectForKey:@"pay_points"];
    self.time = [jsonDic objectForKey:@"time"];
    self.type = [jsonDic objectForKey:@"type"];
}

@end
