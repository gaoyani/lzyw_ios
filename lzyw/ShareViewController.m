//
//  ShareViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/7/29.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ShareViewController.h"
#import "Constants.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"乐分享";
    self.navigationItem.rightBarButtonItem = [self mainMenuButton];
    
    self.phoneNumberBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.contactNameBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    
    [self.nextStep setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.nextStep setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    [self.skip setBackgroundImage:[[UIImage imageNamed:@"button_yellow_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.skip setBackgroundImage:[[UIImage imageNamed:@"button_yellow_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    qrInfo = [[QRInfo alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(qrInfoResult:)
     name:@"qrInfoResult"
     object:nil];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(getResult:)
//     name:@"qrInfoResult"
//     object:nil];
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(shareResult:)
//     name:@"qrInfoResult"
//     object:nil];
    
    //add main menu view
    CGRect rx = [UIScreen mainScreen].bounds;
    self.mainMenuView = [MainMenuView initView];
    self.mainMenuView.viewController = self;
    self.mainMenuView.hidden = YES;
    [self.mainMenuView setFrame:CGRectMake(0.0, 0.0, rx.size.width, rx.size.height)];
    [self.view addSubview:self.mainMenuView];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
}

-(UIBarButtonItem*)mainMenuButton{
    UIImage *btnUP=[UIImage imageNamed:@"button_menu"];
    UIImage *btnDown=[UIImage imageNamed:@"button_menu_down"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 45, 45);
    [btn setBackgroundImage:btnUP forState:UIControlStateNormal];
    [btn setBackgroundImage:btnDown forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}

-(void)rightBtnClick {
    [self.mainMenuView viewShow];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.mainMenuView viewDisappear];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.indicatorView.hidden = NO;
    [qrInfo getInfo];
}

-(void)qrInfoResult:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
    if (isSucceed) {
        self.qrNote.text = qrInfo.note;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL * url = [NSURL URLWithString:qrInfo.qrUrl];
            NSData * data = [[NSData alloc]initWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc]initWithData:data];
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.qrCode.image = image;
                });
            }
        });

    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[resultDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    self.indicatorView.hidden = YES;
}

- (IBAction)nextStepClick:(id)sender {
}

- (IBAction)skipClick:(id)sender {
}

- (IBAction)contactClick:(id)sender {
    ABPeoplePickerNavigationController* peoplePickerController = [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerController.peoplePickerDelegate = self;
    [self presentViewController:peoplePickerController animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerDelegate
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    self.contactName.text = CFBridgingRelease(ABRecordCopyCompositeName(person));
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && phoneNO.length == 11) {
        self.phoneNumber.text = phoneNO;
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
