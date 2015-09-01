//
//  ShareViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/7/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BaseViewController.h"
#import "QRInfo.h"
#import "MainMenuView.h"

@interface ShareViewController : BaseViewController<ABPeoplePickerNavigationControllerDelegate> {
    QRInfo* qrInfo;
}

@property (weak, nonatomic) IBOutlet UIImageView *qrCode;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *qrNote;

@property (weak, nonatomic) IBOutlet UIImageView *phoneNumberBG;
@property (weak, nonatomic) IBOutlet UIImageView *contactNameBG;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *contactName;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (weak, nonatomic) IBOutlet UIButton *skip;

@property MainMenuView* mainMenuView;

@end
