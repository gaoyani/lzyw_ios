//
//  PayOrderViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/5.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "PayOrderViewController.h"
#import "AppDelegate.h"
#import "SetPayPasswordViewController.h"
#import "Constants.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Utils.h"

@interface PayOrderViewController () {
    MemberInfo* memberInfo;
    enum PaymentType paymentType;
    int payMoney;
}

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单支付";
    
    [self.tipBG setImage:[[UIImage imageNamed:@"member_info_table_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    
    [self.payNow setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateNormal];
    [self.payNow setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateHighlighted];
    
    memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    
    self.orderSN.text = self.orderSNValue;
    self.storeName.text = self.storeNameValue;
    self.payName.text = self.priceType;
    self.price.text = [NSString stringWithFormat:@"¥%@",self.pricePay];
    self.acount.text = [NSString stringWithFormat:@"¥%@",memberInfo.account];
    payMoney = [self.price.text integerValue]-[self.acount.text integerValue];
    self.payRest.text = [NSString stringWithFormat:@"¥%d",(payMoney > 0 ?  payMoney: 0)];
    
    self.alipayManager = [[AlipayManager alloc] init];
    self.paymentTask = [[PaymentTask alloc] init];
    self.passwordDlg = [PayPasswordView initView];
    self.passwordDlg.parentViewController = self;
    self.passwordDlg.paymentTask = self.paymentTask;
    self.passwordDlg.orderID = self.orderID;
    self.passwordDlg.hidden = YES;
    [self.view addSubview:self.passwordDlg];
    
    paymentType = PaymentTypeLezi;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(submitResult:)
     name:@"submitResult"
     object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.alipayManager stopGetResultTimer];
}

- (IBAction)paymentChoseClick:(id)sender {
    UIButton* button = (UIButton*)sender;
    UIImage* checked = [UIImage imageNamed:@"login_checked"];
    UIImage* uncheck = [UIImage imageNamed:@"login_checkbox"];
    if (button.tag == 1) {
        [self.paymentLezi setImage:checked forState:UIControlStateNormal];
        [self.paymentLezi setImage:checked forState:UIControlStateHighlighted];
        [self.paymentAli setImage:uncheck forState:UIControlStateNormal];
        [self.paymentAli setImage:uncheck forState:UIControlStateHighlighted];
        [self.paymentYL setImage:uncheck forState:UIControlStateNormal];
        [self.paymentYL setImage:uncheck forState:UIControlStateHighlighted];
        paymentType = PaymentTypeLezi;
    } else if (button.tag == 2) {
        [self.paymentLezi setImage:uncheck forState:UIControlStateNormal];
        [self.paymentLezi setImage:uncheck forState:UIControlStateHighlighted];
        [self.paymentAli setImage:checked forState:UIControlStateNormal];
        [self.paymentAli setImage:checked forState:UIControlStateHighlighted];
        [self.paymentYL setImage:uncheck forState:UIControlStateNormal];
        [self.paymentYL setImage:uncheck forState:UIControlStateHighlighted];
        paymentType = PaymentTypeAli;
    } else {
        [self.paymentLezi setImage:uncheck forState:UIControlStateNormal];
        [self.paymentLezi setImage:uncheck forState:UIControlStateHighlighted];
        [self.paymentAli setImage:uncheck forState:UIControlStateNormal];
        [self.paymentAli setImage:uncheck forState:UIControlStateHighlighted];
        [self.paymentYL setImage:checked forState:UIControlStateNormal];
        [self.paymentYL setImage:checked forState:UIControlStateHighlighted];
        paymentType = PaymentTypeYL;
    }
}

- (IBAction)payNowClick:(id)sender {
    switch (paymentType) {
        case PaymentTypeLezi: {
            if (payMoney > 0) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"账户余额不足，请先充值或选择其他方式支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                if (memberInfo.isSetPayPassword) {
                    [self.passwordDlg viewShow];
                } else {
                    SetPayPasswordViewController* viewController = [[SetPayPasswordViewController alloc] initWithNibName:@"SetPayPasswordViewController" bundle:nil];
                    viewController.isReset = NO;
                    [self.parentViewController.navigationController pushViewController:viewController animated:YES];
                }
            }
        }
            break;
            
        case PaymentTypeAli: {
            [self.loadingView showView];
            [self.loadingView setLoadingText:@"正在提交..."];
            [self.paymentTask payOrder:self.orderID paymentType:PaymentTypeAli password:@"" payNum:1];
        }
            break;
            
        case PaymentTypeYL: {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)submitResult:(NSNotification *)notification {
    BOOL isSuccess = [[[notification userInfo] valueForKey:succeed] boolValue];
    if (isSuccess == YES) {
        [self.alipayManager pay:[[notification userInfo] valueForKey:message] orderID:self.orderID isRecharge:NO];
    } else {
        [Utils showMessage:[[notification userInfo] valueForKey:errorMessage]];
        self.loadingView.hidden = YES;
    }
}

-(void)payResult:(enum PayResult)result {
    switch (result) {
        case PayResultCheck:
            [self.loadingView setLoadingText:@"正在验证..."];
            break;
            
        case PayResultSuccess:
            [Utils showMessage:@"支付成功"];
            self.loadingView.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case PayResultFail:
            [Utils showMessage:@"支付失败"];
            self.loadingView.hidden = YES;
            break;
            
        default:
            break;
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
