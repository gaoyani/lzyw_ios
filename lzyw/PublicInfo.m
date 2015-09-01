//
//  PublicInfo.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/31.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "PublicInfo.h"
#import "AppDelegate.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation RegionInfo
@end

@implementation AreaInfo
@end

@implementation CityInfo
@end

@implementation TimeSlotInfo
@end

@implementation RoomSizeInfo
@end

@implementation PublicInfo

-(PublicInfo*)init {
    self = [super init];
    if (self) {
        self.roomSizeArray = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
        self.resTypeArray = [NSMutableArray array];
        self.complaintReasonArray = [NSMutableArray array];
    }
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return self;
}

-(void)getNetData {
    [self.netConnection startConnect:publicInfoUrl paramsDictionary:nil];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
//    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        [self parseJson: output];
    }
}

-(NSString*)parseJson:(NSString*)jsonString {
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDictionary != nil && error == nil) {
        [self clearData];
        
        NSDictionary* cppDic = [jsonDictionary objectForKey:@"business_expense"];
        self.cppMin = (int)[[cppDic objectForKey:@"cpp_min"] integerValue];
        self.cppMax = (int)[[cppDic objectForKey:@"cpp_max"] integerValue];
        
        NSArray* roomTypeArray = [jsonDictionary objectForKey:@"room_cat"];
        for (NSDictionary* roomTypeDic in roomTypeArray) {
            RoomSizeInfo* info = [[RoomSizeInfo alloc] init];
            info.ID = [roomTypeDic objectForKey:@"cat_id"];
            info.name = [roomTypeDic objectForKey:@"cat_name"];
            [self.roomSizeArray addObject:info];
        }
        
        NSString* reasons = [jsonDictionary objectForKey:@"complain_reason"];
        NSArray *reasonArray = [reasons componentsSeparatedByString:@","];
        for (int i = 0; i < reasonArray.count; i++) {
            TimeSlotInfo* info = [[TimeSlotInfo alloc] init];
            info.time = [reasonArray objectAtIndex:i];
            info.isBookable = YES;
            if (i == 0) {
                info.isReserved = YES;
            }
            [self.complaintReasonArray addObject:info];
        }
        
        NSArray* orderTypeArray = [jsonDictionary objectForKey:@"order_type"];
        for (NSDictionary* orderTypeDic in orderTypeArray) {
            TimeSlotInfo* info = [[TimeSlotInfo alloc] init];
            info.ID = [orderTypeDic objectForKey:@"id"];
            info.time = [orderTypeDic objectForKey:@"name"];
            info.isBookable = YES;
            [self.resTypeArray addObject:info];
        }
        if (orderTypeArray.count > 0) {
             ((TimeSlotInfo*)[self.resTypeArray objectAtIndex:0]).isReserved = YES;
        }
        
        NSArray* cityArray = [jsonDictionary objectForKey:@"region_list"];
        BOOL hasDefaultCity = NO;
        for (NSDictionary* cityDic in cityArray) {
            CityInfo* cityInfo = [[CityInfo alloc] init];
            cityInfo.ID = [cityDic objectForKey:@"id"];
            cityInfo.name = [cityDic objectForKey:@"name"];
            NSArray* areaArray = [cityDic objectForKey:@"child"];
            for (NSDictionary* areaDic in areaArray) {
                AreaInfo* areaInfo = [[AreaInfo alloc] init];
                areaInfo.ID = [areaDic objectForKey:@"id"];
                areaInfo.name = [areaDic objectForKey:@"name"];
                NSArray* regionArray = [areaDic objectForKey:@"child"];
                for (NSDictionary* regionDic in regionArray) {
                    RegionInfo* regionInfo = [[RegionInfo alloc] init];
                    regionInfo.ID = [regionDic objectForKey:@"id"];
                    regionInfo.name = [regionDic objectForKey:@"name"];
                    if (areaInfo.regionArray == nil) {
                        areaInfo.regionArray = [NSMutableArray array];
                    }
                    [areaInfo.regionArray addObject:regionInfo];
                }
                
                if (cityInfo.areaArray == nil) {
                    cityInfo.areaArray = [NSMutableArray array];
                }
                
                [cityInfo.areaArray addObject:areaInfo];
            }
            
            [self.cityArray addObject:cityInfo];
            
            if ([cityInfo.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"]]) {
                hasDefaultCity = true;
            }
        }
        
        if (!hasDefaultCity) {
            [[NSUserDefaults standardUserDefaults]  setObject:((CityInfo*)[self.cityArray objectAtIndex:0]).ID forKey:@"city_id"];
        }
    }

    return @"";
}

-(void)clearData {
    [self.roomSizeArray removeAllObjects];
    [self.cityArray removeAllObjects];
    [self.resTypeArray removeAllObjects];
    [self.complaintReasonArray removeAllObjects];
}

-(int)getResTypeIndex:(NSString*)resTypeID {
    for (int i=0; self.resTypeArray.count; i++) {
        TimeSlotInfo* info = [self.resTypeArray objectAtIndex:i];
        if ([info.ID isEqualToString:resTypeID]) {
            return i;
        }
    }
    
    return 0;
}

@end
