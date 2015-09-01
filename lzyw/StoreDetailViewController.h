//
//  StoreDetialViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/23.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StoreDetailInfo.h"
#import "DetailPicturesView.h"
#import "StoreDetailInfoView.h"
#import "LoadMoreTableFooterView.h"
#import "LoadingView.h"

@interface StoreDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, LoadMoreTableFooterDelegate> {
    enum ServiceType serviceType;
    BOOL allLoad;
    BOOL isLoading;
    int cellHeight;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DetailPicturesView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *infoViewContainer;
@property StoreDetailInfoView *infoView;
@property (weak, nonatomic) IBOutlet UIView *collectContainer;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UILabel *collectNum;
@property (weak, nonatomic) IBOutlet UIView *serviceTypeContainer;
@property (weak, nonatomic) IBOutlet UIButton *roomBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *artificerBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property LoadMoreTableFooterView* loadMoreTableFooterView;
@property LoadingView* loadingView;

@property StoreDetailInfo* storeInfo;
@property NSString* storeID;

@end
