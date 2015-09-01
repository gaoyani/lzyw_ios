//
//  AgreementViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/8/11.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "BaseViewController.h"

@interface AgreementViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextView *agreementText;
@property (strong, nonatomic) IBOutlet LoadingView *loadingView;

@property int agreementType;

@end
