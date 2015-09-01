//
//  PointInfo.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointInfo : NSObject

@property NSString* name;
@property NSString* price;
@property NSString* time;
@property NSString* type;

-(void)parseJson:(NSDictionary*)jsonDic;

@end
