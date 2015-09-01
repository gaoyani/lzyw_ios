//
//  ModifyPasswordViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"

@interface ModifyPasswordViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *oldPasswordBG;
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UIImageView *passwordBG;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIImageView *confirmPasswordBG;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet LoadingView *loadingView;

@property BOOL isModifyPayPassword;

@end
