//
//  LoginViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/24.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInfo.h"
#import "LoadingView.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UIAlertViewDelegate, UITextFieldDelegate> {
    MemberInfo* memberInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *userNameBG;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBG;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *forgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *autoLogin;
@property (weak, nonatomic) IBOutlet UIButton *rememberMe;
@property (weak, nonatomic) IBOutlet UIButton *login;

@property LoadingView* loadingView;


@end
