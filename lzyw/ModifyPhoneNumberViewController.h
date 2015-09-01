//
//  ModifyPhoneNumberViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"

@interface ModifyPhoneNumberViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *oldPhoneNumBG;
@property (strong, nonatomic) IBOutlet UITextField *oldPhoneNum;
@property (strong, nonatomic) IBOutlet UIImageView *phoneNumBG;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UIImageView *safeQuestionBG;
@property (strong, nonatomic) IBOutlet UILabel *safeQuestion;
@property (strong, nonatomic) IBOutlet UIImageView *safeAnswerBG;
@property (strong, nonatomic) IBOutlet UITextField *safeAnswer;
@property (strong, nonatomic) IBOutlet UIImageView *authCodeBG;
@property (strong, nonatomic) IBOutlet UITextField *authCode;
@property (strong, nonatomic) IBOutlet UIButton *getAuthCode;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet LoadingView *loadingView;

@end
