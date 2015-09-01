//
//  RechargeViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/25.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "RechargeViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Utils.h"

@interface RechargeViewController () {
    enum PaymentType paymentType;
}

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员充值";
    
    [self.tipBG setImage:[[UIImage imageNamed:@"member_info_table_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    
    [self.payNow setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateNormal];
    [self.payNow setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateHighlighted];
    
    self.alipayManager = [[AlipayManager alloc] init];
    self.paymentTask = [[PaymentTask alloc] init];
    paymentType = PaymentTypeAli;
    
    self.orderSN.text = self.orderID;
    self.acount.text = [NSString stringWithFormat:@"¥%@",((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo.account];
    
    self.rechargeInput.delegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(submitResult:)
     name:@"submitResult"
     object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.alipayManager stopGetResultTimer];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)rechargeValueClick:(id)sender {
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case 1:
            self.rechargeInput.text = @"50";
            break;
            
        case 2:
            self.rechargeInput.text = @"100";
            break;
            
        case 3:
            self.rechargeInput.text = @"300";
            break;
            
        case 4:
            self.rechargeInput.text = @"500";
            break;
            
        default:
            break;
    }
}

- (IBAction)paymentChoseClick:(id)sender {
    UIButton* button = (UIButton*)sender;
    UIImage* checked = [UIImage imageNamed:@"login_checked"];
    UIImage* uncheck = [UIImage imageNamed:@"login_checkbox"];
    if (button.tag == 1) {
        [self.paymentAli setImage:checked forState:UIControlStateNormal];
        [self.paymentAli setImage:checked forState:UIControlStateHighlighted];
        [self.paymentYL setImage:uncheck forState:UIControlStateNormal];
        [self.paymentYL setImage:uncheck forState:UIControlStateHighlighted];
        paymentType = PaymentTypeAli;
    } else {
        [self.paymentAli setImage:uncheck forState:UIControlStateNormal];
        [self.paymentAli setImage:uncheck forState:UIControlStateHighlighted];
        [self.paymentYL setImage:checked forState:UIControlStateNormal];
        [self.paymentYL setImage:checked forState:UIControlStateHighlighted];
        paymentType = PaymentTypeYL;
    }
}

- (IBAction)payNowClick:(id)sender {
    switch (paymentType) {
        case PaymentTypeAli: {
            if (self.rechargeInput.text.length != 0) {
                [self.loadingView showView];
                [self.loadingView setLoadingText:@"正在提交..."];
                [self.paymentTask confirmRechargeOrder:self.orderID paymentType:PaymentTypeAli price:self.rechargeInput.text];
            } else {
                [Utils showMessage:@"请输入充值金额"];
            }
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
