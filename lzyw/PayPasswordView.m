//
//  PayPasswordView.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "PayPasswordView.h"
#import "SetPayPasswordViewController.h"
#import "Constants.h"
#import "Utils.h"

@implementation PayPasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(payOrderResult:)
     name:@"payOrderResult"
     object:nil];
    inputPayPwdNum = 1;
    
    self.dlgView.layer.cornerRadius = 8;
    self.dlgView.layer.masksToBounds = YES;
    self.dlgView.layer.borderWidth = 2;
    self.dlgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.passwordInput.delegate = self;
    
    self.forgetPassword.userInteractionEnabled = YES;
    UITapGestureRecognizer* forgetPasswordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordClick)];
    [self.forgetPassword addGestureRecognizer:forgetPasswordTap];
    
    [self.loadingView setLoadingText:@"正在支付..."];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)forgetPasswordClick {
    NSLog(@"click forget password");
    SetPayPasswordViewController* viewController = [[SetPayPasswordViewController alloc] initWithNibName:@"SetPayPasswordViewController" bundle:nil];
    viewController.isReset = YES;
    [self.parentViewController.navigationController pushViewController:viewController animated:YES];
}

-(void)viewShow {
    self.hidden = NO;
    self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformIdentity;
        self.dlgView.alpha = 1.0f;
    }];
}

- (IBAction)buttonOKClick:(id)sender {
    [self.loadingView showView];
    [self.paymentTask payOrder:self.orderID paymentType:PaymentTypeLezi password:self.passwordInput.text payNum:inputPayPwdNum];
}

- (IBAction)buttonCancelClick:(id)sender {
    [self viewDisappear];
}

-(void)payOrderResult:(NSNotification *)notification {
    BOOL isSuccess = [[[notification userInfo] valueForKey:succeed] boolValue];
    if (isSuccess == YES) {
        [self viewDisappear];
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
        [Utils showMessage:@"订单支付成功"];
        
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[[notification userInfo] valueForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
    self.loadingView.hidden = YES;
    inputPayPwdNum++;
}

-(void)viewDisappear {
    self.passwordInput.text = @"";
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.dlgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

+(PayPasswordView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PayPasswordView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


@end
