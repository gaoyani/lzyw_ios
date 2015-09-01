//
//  PayPasswordView.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "ReservationInfo.h"
#import "PaymentTask.h"

@interface PayPasswordView : UIView<UITextFieldDelegate> {
    int inputPayPwdNum;
}

@property (weak, nonatomic) IBOutlet UIView *dlgView;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UILabel *forgetPassword;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@property UIViewController* parentViewController;
@property PaymentTask* paymentTask;
@property NSString* orderID;

+(PayPasswordView *)initView;

-(void)viewShow;

@end
