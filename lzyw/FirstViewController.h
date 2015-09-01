//
//  FirstViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "BaseViewController.h"
#import "CommonData.h"
#import "RecommendInfo.h"
#import "LoadingView.h"
#import "ItemListView.h"
#import "MainMenuView.h"

@interface FirstViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate, BMKLocationServiceDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesView;
@property (weak, nonatomic) IBOutlet UILabel *recommendMsg;
@property (weak, nonatomic) IBOutlet UIView *recommendMsgContainer;
@property (weak, nonatomic) IBOutlet UIView *recommendContainer;
@property (weak, nonatomic) IBOutlet UIView *featuredHeadContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property ItemListView* newsListView;
@property LoadingView *loadingView;
@property BMKLocationService *locService;
@property MainMenuView* mainMenuView;

@property CommonData* commonData;
@property RecommendInfo* recommendInfo;

@end

