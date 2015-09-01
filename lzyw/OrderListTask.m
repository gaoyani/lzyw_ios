//
//  OrderListTask.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "OrderListTask.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "OrderInfo.h"
#import "PointInfo.h"
#import "CommentInfo.h"

@implementation OrderListTask

-(OrderListTask*)init {
    self = [super init];
    if (self) {
        self.netConnection = [[NetConnection alloc] init];
        self.netConnection.delegate = self;
    }
    
    return self;
}

-(void)getOrderList:(NSMutableArray*)orderList {
    orderListTemp = orderList;
    listViewType = ListViewOrder;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:[NSString stringWithFormat:@"%d", orderList.count] forKey:@"p"];
    
    [self.netConnection startConnect:orderListUrl paramsDictionary:paramsDic];
}

-(void)getCommentList:(NSMutableArray*)commentList {
    commentListTemp = commentList;
    listViewType = ListViewComment;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:[NSString stringWithFormat:@"%d", commentList.count] forKey:@"p"];
    
    [self.netConnection startConnect:commentListUrl paramsDictionary:paramsDic];
}

-(void)getPointList:(NSMutableArray*)pointList {
    pointListTemp = pointList;
    listViewType = ListViewPoint;
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setValue:((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.memberID forKey:@"user_id"];
    [paramsDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    [paramsDic setValue:[NSString stringWithFormat:@"%d", pointList.count] forKey:@"p"];
    
    [self.netConnection startConnect:pointListUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        NSData* jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error;
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (jsonArray != nil && error == nil) {
            if (jsonArray.count != 0) {
                [self parseJson:jsonArray];
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:loadComplate];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:loadComplate];
            }
        } else {
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
            [userInfoDic setValue:@"获取列表失败" forKey:errorMessage];
        }
        
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:[result objectForKey:errorMessage] forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableView" object:self userInfo:userInfoDic];
}

-(void)parseJson:(NSArray*)jsonArray {
    if (listViewType == ListViewOrder) {
        for (NSDictionary* orderDic in jsonArray) {
            OrderInfo* orderInfo = [[OrderInfo alloc] init];
            [orderInfo parseJson:orderDic];
            [orderListTemp addObject:orderInfo];
        }
    } else if (listViewType == ListViewComment) {
        for (NSDictionary* orderDic in jsonArray) {
            CommentInfo* commentInfo = [[CommentInfo alloc] init];
            [commentInfo parseJson:orderDic];
            [commentListTemp addObject:commentInfo];
        }
    } else {
        for (NSDictionary* orderDic in jsonArray) {
            PointInfo* pointInfo = [[PointInfo alloc] init];
            [pointInfo parseJson:orderDic];
            [pointListTemp addObject:pointInfo];
        }
    }
}


@end
