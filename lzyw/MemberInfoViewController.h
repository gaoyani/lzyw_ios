//
//  MemberInfoViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/5/7.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"

@interface MemberInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *memberID;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *acount;
@property (weak, nonatomic) IBOutlet UIButton *recharge;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UIButton *exchange;
@property (weak, nonatomic) IBOutlet UILabel *curLevel;
@property (weak, nonatomic) IBOutlet UILabel *nextLevel;
@property (weak, nonatomic) IBOutlet UIProgressView *gradeProgress;
@property (weak, nonatomic) IBOutlet UIImageView *levelTipBG;
////@property (weak, nonatomic) IBOutlet MDHTMLLabel *levelTip;
@property (strong, nonatomic) IBOutlet UITextView *levelTip;
@property (weak, nonatomic) IBOutlet UILabel *mouthConsume;
@property (weak, nonatomic) IBOutlet UIImageView *mouthConsumeBG;
@property (weak, nonatomic) IBOutlet UILabel *totalConsume;
@property (weak, nonatomic) IBOutlet UIImageView *totalConsumeBG;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@property UINavigationController* parentNavigationViewController;

-(void)setInfo;

@end
