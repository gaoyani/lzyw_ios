//
//  StoreTableViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StoreListInfo.h"
#import "SearchInfo.h"
#import "LoadingView.h"
@interface StoreTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property LoadingView *loadingView;

@property UINavigationController* parentNavigationController;

@property StoreListInfo* storeListInfo;
@property SearchInfo* searchInfo;
@property enum StoreListType storeListType;

-(void)loadData;
-(void)resetCollect:(StoreDetailInfo*)storeInfo;

@end
