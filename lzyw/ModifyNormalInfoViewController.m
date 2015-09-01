//
//  ModifyNormalInfoViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/10.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "ModifyNormalInfoViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ModifyNormalInfoViewController () {
    MemberInfo* memberInfo;
    
    NSString* imageFilePath;
    NSString* imageName;
    
    enum IdentType identType;
    
//    UIActionSheet* actionSheet;
//    UIDatePicker* datePicker;
}

@end

@implementation ModifyNormalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置常用信息";
    memberInfo = ((AppDelegate*)[UIApplication sharedApplication].delegate).memberInfo;
    
    UIImage* textBG = [[UIImage imageNamed:@"login_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.safeQuestionBG.image = textBG;
    self.safeAnswerBG.image = textBG;
    self.emailBG.image = textBG;
    self.birthdayBG.image = textBG;
    self.billTitleBG.image = textBG;
    self.addressBG.image = textBG;
    self.idTypeBG.image = textBG;
    self.idNumberBG.image = textBG;
    self.idPictureBG.image = textBG;
    
    self.safeQuestion.delegate = self;
    self.safeAnswer.delegate = self;
    self.email.delegate = self;
    self.birthday.delegate = self;
    self.billTitle.delegate = self;
    self.address.delegate = self;
    self.idNumber.delegate = self;
    
    [self.choosePic setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.choosePic setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    [self.submit setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.submit setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    [self.datePickConfirm setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.datePickConfirm setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    [self.datePickCancel setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.datePickCancel setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    
    [self setInfo];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageClick:)];
    [self.idPicture addGestureRecognizer:imageTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitResult:) name:@"submitResult" object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.datePickerView.hidden = NO;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSArray *ymd = [self.birthday.text componentsSeparatedByString:@"-"];
    [comps setYear:[((NSString*)[ymd objectAtIndex:0]) integerValue]];
    [comps setMonth:[((NSString*)[ymd objectAtIndex:1]) integerValue]];
    [comps setDay:[((NSString*)[ymd objectAtIndex:2]) integerValue]];
    NSDate *date = [calendar dateFromComponents:comps];
    self.datePicker.date = date;
    
    return NO;
}

- (IBAction)datePickConfirmClick:(id)sender {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birthday.text = [formatter stringFromDate:date];
    self.datePickerView.hidden = YES;
}

- (IBAction)datePickCancelClick:(id)sender {
    self.datePickerView.hidden = YES;
}

-(void)setInfo {
    self.safeQuestion.text = memberInfo.safeQuestion;
    self.safeAnswer.text = memberInfo.safeAnswer;
    self.email.text = memberInfo.email;
    self.birthday.text = memberInfo.birthday;
    self.billTitle.text = memberInfo.billTitile;
    self.address.text = memberInfo.address;
    
    memberInfo.identifyNum = @"123456789";
    NSString* tempNumber = @"";
    if (memberInfo.identifyNum != nil && ![memberInfo.identifyNum isEqualToString:@""]) {
        tempNumber = [memberInfo.identifyNum substringToIndex:2];
        for (int i = 0; i < memberInfo.identifyNum.length-4; i++) {
            tempNumber = [tempNumber stringByAppendingString:@"*"];
        }
        tempNumber = [tempNumber stringByAppendingString:[memberInfo.identifyNum substringFromIndex:memberInfo.identifyNum.length-2]];
    }
    self.idNumber.text = tempNumber;

    self.idPictureCover.hidden = [memberInfo.identifyImg isEqualToString:@""];
    [self loadIcon:memberInfo.identifyImg];
    
    identType = memberInfo.idType;
    [self resetIDTypeButton];
}

-(void)loadIcon:(NSString*)iconUrl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:iconUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.idPicture.image = image;
            });
        }
    });
}

- (IBAction)idTypeClick:(id)sender {
    UIButton* button = (UIButton*)sender;
    identType = (int)button.tag;
    [self resetIDTypeButton];
}

-(void)resetIDTypeButton {
    UIImage* singleSelectedImg = [[UIImage imageNamed:@"type_single_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 30, 40)];
    UIImage* unselectedImg = [[UIImage imageNamed:@"type_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 40, 40)];
    if (identType == IdentIDCard) {
        [self.idCard setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.passport setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.officerCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.otherIDCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        
    } else if (identType == IdentPassport) {
        [self.idCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.passport setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.officerCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.otherIDCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
    } else if (identType == IdentOfficerCard) {
        [self.idCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.passport setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.officerCard setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.otherIDCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
    } else {
        [self.idCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.passport setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.officerCard setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.otherIDCard setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
    }
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
    self.idPicture.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:self.idPicture.image];
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

- (IBAction)submitClick:(id)sender {
    memberInfo.safeQuestion = self.safeQuestion.text;
    memberInfo.safeAnswer = self.safeAnswer.text;
    memberInfo.email = self.email.text;
    memberInfo.birthday = self.birthday.text;
    memberInfo.billTitile = self.billTitle.text;
    memberInfo.address = self.address.text;
    memberInfo.idType = identType;
    memberInfo.identifyNum = self.idNumber.text;
    memberInfo.identifyImg = imageFilePath;
    
    [memberInfo modifyNormalInfo:(imageFilePath == nil ? nil : self.idPicture.image) identFileName:imageName];
}

-(void)submitResult:(NSNotification*)notification {
    self.loadingView.hidden = YES;
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[userInfoDic objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
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
