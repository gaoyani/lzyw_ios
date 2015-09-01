//
//  MemberEditViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/4.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"

@interface MemberEditViewController : BaseViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *chooseImage;
@property (weak, nonatomic) IBOutlet UIImageView *phoneNumberBG;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *loginNameBG;
@property (weak, nonatomic) IBOutlet UITextField *loginName;
@property (weak, nonatomic) IBOutlet UIImageView *nickNameBG;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *realNameBG;
@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UIImageView *sexBG;
@property (weak, nonatomic) IBOutlet UIButton *male;
@property (weak, nonatomic) IBOutlet UIButton *female;
@property (weak, nonatomic) IBOutlet UILabel *setNormalInfo;
@property (weak, nonatomic) IBOutlet UILabel *setLoginPassword;
@property (weak, nonatomic) IBOutlet UILabel *setPayPassword;
@property (weak, nonatomic) IBOutlet UIView *takePicView;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;
@end
