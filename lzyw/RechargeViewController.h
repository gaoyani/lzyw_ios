//
//  RechargeViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/25.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"
#import "PaymentTask.h"
#import "AlipayManager.h"

@interface RechargeViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderSN;
@property (weak, nonatomic) IBOutlet UILabel *acount;
@property (weak, nonatomic) IBOutlet UITextField *rechargeInput;
@property (weak, nonatomic) IBOutlet UIImageView *tipBG;

@property (weak, nonatomic) IBOutlet UIButton *rmb50;
@property (weak, nonatomic) IBOutlet UIButton *rmb100;
@property (weak, nonatomic) IBOutlet UIButton *rmb300;
@property (weak, nonatomic) IBOutlet UIButton *rmb500;

@property (weak, nonatomic) IBOutlet UIButton *paymentAli;
@property (weak, nonatomic) IBOutlet UIButton *paymentYL;

@property (weak, nonatomic) IBOutlet UIButton *payNow;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@property PaymentTask* paymentTask;
@property AlipayManager* alipayManager;

@property NSString* orderID;


@end
