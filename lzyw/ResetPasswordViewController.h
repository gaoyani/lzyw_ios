//
//  ResetPasswordViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/8.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"
#import "MemberInfo.h"
#import "AuthCodeTask.h"

@interface ResetPasswordViewController : BaseViewController<UITextFieldDelegate> {
    MemberInfo* memberInfo;
    int authCodeSave;
    BOOL isAuthCodeInvalid;
    BOOL isCountDown;
    int countDownSeconds;
    
    AuthCodeTask* authCodeTask;
    NSTimer* countDownTimer;
}

@property (weak, nonatomic) IBOutlet UIImageView *phoneNumBG;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBG;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *passwordConfirmBG;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (weak, nonatomic) IBOutlet UIImageView *authCodeBG;
@property (weak, nonatomic) IBOutlet UITextField *authCode;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@end
