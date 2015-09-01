//
//  OrderListTask.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

enum ListViewType {
    ListViewOrder,
    ListViewComment,
    ListViewPoint
};

@interface OrderListTask : NSObject<NetConnectionDelegate> {
    NSMutableArray* orderListTemp;
    NSMutableArray* commentListTemp;
    NSMutableArray* pointListTemp;
    
    enum ListViewType listViewType;
}

@property NetConnection* netConnection;

-(void)getOrderList:(NSMutableArray*)orderList;
-(void)getCommentList:(NSMutableArray*)commentList;
-(void)getPointList:(NSMutableArray*)pointList;

@end
