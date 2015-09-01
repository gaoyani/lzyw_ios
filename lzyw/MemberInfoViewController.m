//
//  MemberInfoViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/5/7.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "AppDelegate.h"
#import "RechargeViewController.h"
#import "LoginViewController.h"
#import "Constants.h"
#import "CreateRechargeOrderTask.h"
#import "MemberEditViewController.h"

@interface MemberInfoViewController () {
    CreateRechargeOrderTask* createRechargeOrderTask;
}

@end

@implementation MemberInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.recharge setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.recharge setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [self.exchange setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.exchange setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    
    [self.levelTipBG setImage:[[UIImage imageNamed:@"member_tips_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];

    [self.mouthConsumeBG setImage:[[UIImage imageNamed:@"member_info_table_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    [self.totalConsumeBG setImage:[[UIImage imageNamed:@"member_info_table_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    
    self.icon.image = [UIImage imageNamed:@"member_default_icon"];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(createRechargeOrderResult:)
     name:@"createRechargeOrderResult"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(getInfoResult:)
     name:@"getInfoResult"
     object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.memberInfo.isLogin) {
        [appDelegate.memberInfo getMemberInfo];
        [self.loadingView showView];
    }
}

-(void)getInfoResult:(NSNotification*)notification {
    self.loadingView.hidden = YES;
    NSDictionary* userInfo = notification.userInfo;
    if ([userInfo objectForKey:succeed]) {
        [self setInfo];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[userInfo objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)setInfo {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self loadIcon:appDelegate.memberInfo.imgUrl];
    self.name.text = [appDelegate.memberInfo getName];
    self.memberID.text = appDelegate.memberInfo.uidName;
    self.level.text = appDelegate.memberInfo.curLevel;
    self.acount.text = [NSString stringWithFormat:@"账户%@",appDelegate.memberInfo.account];
    self.grade.text = [NSString stringWithFormat:@"积分 %@",appDelegate.memberInfo.grades];
    self.curLevel.text = appDelegate.memberInfo.curLevel;
    self.nextLevel.text = appDelegate.memberInfo.nextLevel;
    self.mouthConsume.text = appDelegate.memberInfo.mouthConsume;
    self.totalConsume.text = appDelegate.memberInfo.totleConsume;
    
    float progress = (float)(appDelegate.memberInfo.curPoints-appDelegate.memberInfo.curLevelPoints)/(float)(appDelegate.memberInfo.nextLevelPoints-appDelegate.memberInfo.curLevelPoints);
    self.gradeProgress.progress = progress;
    
    NSError* error;
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSAttributedString *string = [[NSAttributedString alloc] initWithData:[appDelegate.memberInfo.promotionTips dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:&error];
    [self.levelTip setAttributedText:string];
    self.levelTip.font = [UIFont systemFontOfSize:9];
}

-(void)loadIcon:(NSString*)iconUrl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:iconUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.icon.image = image;
            });
        }
    });
}

- (IBAction)memberInfoEditClick:(id)sender {
    MemberEditViewController* viewController = [[MemberEditViewController alloc] initWithNibName:@"MemberEditViewController" bundle:nil];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.parentNavigationViewController pushViewController:viewController animated:YES];
}

- (IBAction)rechargeClick:(id)sender {
    if (createRechargeOrderTask == nil) {
        createRechargeOrderTask = [[CreateRechargeOrderTask alloc] init];
    }
    
    [createRechargeOrderTask createRechargeOrder];
}

-(void)createRechargeOrderResult:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    if ([userInfo objectForKey:succeed]) {
        RechargeViewController* viewController = [[RechargeViewController alloc] initWithNibName:@"RechargeViewController" bundle:nil];
        viewController.orderID = [userInfo objectForKey:message];
        [self.parentNavigationViewController pushViewController:viewController animated:YES];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[userInfo objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
