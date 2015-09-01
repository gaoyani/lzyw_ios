//
//  TimeSlotTask.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/4.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "TimeSlotTask.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation TimeSlotTask

-(TimeSlotTask*)init {
    self = [super init];
    
    self.netConnection = [[NetConnection alloc] init];
    self.netConnection.delegate = self;
    
    return  self;
}

-(void)getTimeSlots:(NSString*)roomID date:(NSString*)date timeSlotArray:(NSMutableArray*)array{
    timeSlotArray = array;
    
    NSString * urlString = [NSString stringWithFormat:@"/order/get_calendar/time/%@/room_id/%@",date,roomID];
    
    [self.netConnection startConnect:urlString paramsDictionary:nil];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if ([[result objectForKey:succeed] boolValue]) {
        NSString* output = [result objectForKey:message];
        NSData* jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (jsonDic != nil && error == nil) {
            int errorCode = [[jsonDic objectForKey:@"error"] integerValue];
            if (errorCode == 0) {
                [timeSlotArray removeAllObjects];
                NSArray* timeArray = [jsonDic objectForKey:@"content"];
                for (NSDictionary* timeSlotDic in timeArray) {
                    TimeSlotInfo* info = [[TimeSlotInfo alloc] init];
                    info.ID = [timeSlotDic objectForKey:@"id"];
                    info.time = [timeSlotDic objectForKey:@"time"];
                    info.isBookable = ![[timeSlotDic objectForKey:@"disable"] boolValue];
                    [timeSlotArray addObject:info];
                }
                
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
                
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:[jsonDic objectForKey:@"message"] forKey:errorMessage];
            }
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"获取档期失败" forKey:errorMessage];
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTimeSlots" object:self userInfo:userInfoDic];
}

@end
