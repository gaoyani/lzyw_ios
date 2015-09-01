//
//  TimeSlotTask.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/4.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

@interface TimeSlotTask : NSObject<NetConnectionDelegate>  {
    NSMutableArray* timeSlotArray;
}

@property NetConnection* netConnection;
-(void)getTimeSlots:(NSString*)roomID date:(NSString*)date timeSlotArray:(NSMutableArray*)array;

@end
