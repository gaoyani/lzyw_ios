//
//  StoreListViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/27.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "StoreTableViewController.h"
#import "StoreListInfo.h"
#import "SearchFactorView.h"

@interface StoreListViewController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate> {
    SearchInfo* searchInfo;
    StoreListInfo* storeListInfo;
}

@property SearchFactorView *searchView;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property int categoryID;

-(void)searchViewDisappear;

@end
