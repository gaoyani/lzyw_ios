//
//  MemberViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInfoViewController.h"
#import "ViewPagerController.h"
#import "ListViewController.h"
#import "MainMenuView.h"

@interface MemberViewController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate> {
    MemberInfoViewController* memberInfoViewController;
    ListViewController* orderListViewController;
    ListViewController* commentListViewController;
    ListViewController* pointListViewController;
}

@property MainMenuView* mainMenuView;

@end
