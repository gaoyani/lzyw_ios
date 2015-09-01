//
//  RoomDetialViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/31.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DetailPicturesView.h"
#import "RoomInfo.h"
#import "LoadingView.h"

@interface RoomDetialViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property NSString* roomID;
@property RoomInfo* roomInfo;

@property (weak, nonatomic) IBOutlet DetailPicturesView *picturesView;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *feature;
@property (weak, nonatomic) IBOutlet UILabel *recommend;
@property (weak, nonatomic) IBOutlet UILabel *privilege;
@property (weak, nonatomic) IBOutlet UIButton *phoneOrderBtn;
@property LoadingView *loadingView;

//@property (weak, nonatomic) IBOutlet CustomProgressView *progressHot;
@property (weak, nonatomic) IBOutlet UICollectionView *timeSlotView;
@property (weak, nonatomic) IBOutlet UIButton *reservationBtn;

@end
