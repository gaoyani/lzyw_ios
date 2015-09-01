//
//  SettingViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *cityBG;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UIImageView *autoLoginBG;
@property (strong, nonatomic) IBOutlet UISwitch *autoLogin;
@property (strong, nonatomic) IBOutlet UIImageView *acountSettingBG;
@property (strong, nonatomic) IBOutlet UILabel *acountSetting;
@property (strong, nonatomic) IBOutlet UIButton *logout;
@property (strong, nonatomic) IBOutlet UIPickerView *cityPicker;

@end
