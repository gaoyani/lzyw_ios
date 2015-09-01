//
//  ListViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/30.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"
#import "OrderListTask.h"

@interface ListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray* orderList;
    NSMutableArray* commentList;
    NSMutableArray* pointList;
    
    OrderListTask* task;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@property UINavigationController* parentNavigationController;

@property enum ListViewType listViewType;

@end
