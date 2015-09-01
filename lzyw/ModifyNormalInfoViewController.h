//
//  ModifyNormalInfoViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"

@interface ModifyNormalInfoViewController : BaseViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *safeQuestionBG;
@property (strong, nonatomic) IBOutlet UITextField *safeQuestion;
@property (strong, nonatomic) IBOutlet UIImageView *safeAnswerBG;
@property (strong, nonatomic) IBOutlet UITextField *safeAnswer;
@property (strong, nonatomic) IBOutlet UIImageView *emailBG;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UIImageView *birthdayBG;
@property (strong, nonatomic) IBOutlet UITextField *birthday;
@property (strong, nonatomic) IBOutlet UIImageView *billTitleBG;
@property (strong, nonatomic) IBOutlet UITextField *billTitle;
@property (strong, nonatomic) IBOutlet UIImageView *addressBG;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UIImageView *idTypeBG;
@property (strong, nonatomic) IBOutlet UIButton *idCard;
@property (strong, nonatomic) IBOutlet UIButton *passport;
@property (strong, nonatomic) IBOutlet UIButton *officerCard;
@property (strong, nonatomic) IBOutlet UIButton *otherIDCard;
@property (strong, nonatomic) IBOutlet UIImageView *idNumberBG;
@property (strong, nonatomic) IBOutlet UITextField *idNumber;
@property (strong, nonatomic) IBOutlet UIImageView *idPictureBG;
@property (strong, nonatomic) IBOutlet UIImageView *idPicture;
@property (strong, nonatomic) IBOutlet UIView *idPictureCover;
@property (strong, nonatomic) IBOutlet UIButton *choosePic;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet UIView *takePicView;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet LoadingView *loadingView;
@property (strong, nonatomic) IBOutlet UIButton *datePickConfirm;
@property (strong, nonatomic) IBOutlet UIButton *datePickCancel;

@end
