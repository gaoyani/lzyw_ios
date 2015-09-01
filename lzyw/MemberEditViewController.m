//
//  MemberEditViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/4.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "MemberEditViewController.h"
#import "MemberInfo.h"
#import "AppDelegate.h"
#import "ModifyMemberInfoTask.h"
#import "Constants.h"
#import "ModifyPhoneNumberViewController.h"
#import "ModifyPasswordViewController.h"
#import "SetPayPasswordViewController.h"
#import "ModifyNormalInfoViewController.h"

@interface MemberEditViewController () {
    MemberInfo* memberInfo;
    
    NSString* imageFilePath;
    NSString* imageName;
    enum SexType sexType;
    
    ModifyMemberInfoTask* modifyTask;
}

@end

@implementation MemberEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    modifyTask = [[ModifyMemberInfoTask alloc] init];
    
    self.title = @"会员资料修改";
    self.navigationItem.rightBarButtonItem = [self customRightButton];
    
    imageName = @"icon.png";
    
    self.phoneNumberBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.realNameBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.nickNameBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.loginNameBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.sexBG.image = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    
    [self.chooseImage setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.chooseImage setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageClick:)];
    [self.image addGestureRecognizer:imageTap];
    
    UITapGestureRecognizer *normalInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setNormalInfo:)];
    [self.setNormalInfo addGestureRecognizer:normalInfoTap];
    UITapGestureRecognizer *loginPasswordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setLoginPassword:)];
    [self.setLoginPassword addGestureRecognizer:loginPasswordTap];
    UITapGestureRecognizer *payPasswordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPayPassword:)];
    [self.setPayPassword addGestureRecognizer:payPasswordTap];
    
    [self setInfo];
    
    self.loginName.delegate = self;
    self.nickName.delegate = self;
    self.realName.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyResult:) name:@"modifyResult" object:nil];
}

-(void)setInfo {
    [self loadIcon:memberInfo.imgUrl];
    
    self.phoneNumber.text = memberInfo.phoneNum;
    self.loginName.text = memberInfo.userName;
    self.nickName.text = memberInfo.nickName;
    self.realName.text = memberInfo.realName;
    
    sexType = memberInfo.sex;
    [self resetSexButton];
}

-(void)resetSexButton {
    UIImage* singleSelectedImg = [[UIImage imageNamed:@"type_single_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 30, 40)];
    UIImage* unselectedImg = [[UIImage imageNamed:@"type_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 40, 40)];
    if (sexType == female) {
        [self.male setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.male setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.female setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.female setBackgroundImage:singleSelectedImg forState:UIControlStateHighlighted];

    } else {
        [self.male setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.male setBackgroundImage:singleSelectedImg forState:UIControlStateHighlighted];
        [self.female setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.female setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
    }
}

-(void)loadIcon:(NSString*)iconUrl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:iconUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image.image = image;
            });
        }
    });
}

-(UIBarButtonItem*)customRightButton{
    UIImage *btnUP=[UIImage imageNamed:@"button_title_bg_up.png"];
    UIImage *btnDown=[UIImage imageNamed:@"button_title_bg_down.png"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    btn.frame=CGRectMake(0, 0, 60, self.navigationController.navigationBar.frame.size.height-10);
    [btn setBackgroundImage:btnUP forState:UIControlStateNormal];
    [btn setBackgroundImage:btnDown forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}

-(void)saveBtnClick{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否提交所填信息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        memberInfo.userName = self.loginName.text;
        memberInfo.nickName = self.nickName.text;
        memberInfo.realName = self.realName.text;
        memberInfo.sex = sexType;
        
        [self.loadingView setLoadingText:@"正在提交..."];
        [self.loadingView showView];
        [modifyTask modifyUserInfo:(imageFilePath == nil ? nil : self.image.image) picFileName:imageName];
    }
}

-(void)modifyResult:(NSNotification*)notification {
    self.loadingView.hidden = YES;
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[userInfoDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)tackPictrueClick:(id)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self.parentViewController presentViewController:picker animated:YES completion:nil];
    self.takePicView.hidden = YES;
}

- (IBAction)phoneAlbumClick:(id)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self.parentViewController presentViewController:picker animated:YES completion:nil];
    self.takePicView.hidden = YES;
}

- (IBAction)cancelSetPicClick:(id)sender {
    self.takePicView.hidden = YES;
}

- (IBAction)chooseImageClick:(id)sender {
    self.takePicView.hidden = NO;
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.image.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:self.image.image];
}

- (void)saveImage:(UIImage *)tempImage {
    NSData* imageData;
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    imageFilePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSArray *nameAry=[imageFilePath componentsSeparatedByString:@"/"];
    NSLog(@"===fullPathToFile===%@",imageFilePath);
    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:imageFilePath atomically:NO];
}

- (IBAction)editPhoneNumber:(id)sender {
    ModifyPhoneNumberViewController* viewController = [[ModifyPhoneNumberViewController alloc] initWithNibName:@"ModifyPhoneNumberViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)maleClick:(id)sender {
    sexType = male;
    [self resetSexButton];
}

- (IBAction)femaleClick:(id)sender {
    sexType = female;
    [self resetSexButton];
}

- (IBAction)setNormalInfo:(id)sender {
    ModifyNormalInfoViewController* viewController = [[ModifyNormalInfoViewController alloc] initWithNibName:@"ModifyNormalInfoViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)setLoginPassword:(id)sender {
    ModifyPasswordViewController* viewController = [[ModifyPasswordViewController alloc] initWithNibName:@"ModifyPasswordViewController" bundle:nil];
    viewController.isModifyPayPassword = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)setPayPassword:(id)sender {
    if (memberInfo.isSetPayPassword) {
        ModifyPasswordViewController* viewController = [[ModifyPasswordViewController alloc] initWithNibName:@"ModifyPasswordViewController" bundle:nil];
        viewController.isModifyPayPassword = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        SetPayPasswordViewController* viewController = [[SetPayPasswordViewController alloc] initWithNibName:@"SetPayPasswordViewController" bundle:nil];
        viewController.isReset = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
