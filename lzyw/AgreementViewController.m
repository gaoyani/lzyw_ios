//
//  AgreementViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/8/11.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "AgreementViewController.h"
#import "AgreementTask.h"
#import "Constants.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"协议";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreementResult:) name:@"agreementResult" object:nil];
    
    AgreementTask* task = [[AgreementTask alloc] init];
    [task getAgreement:self.agreementType];
}

-(void)agreementResult:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        NSString* agreement = [userInfoDic objectForKey:message];
        NSError* error;
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
        NSAttributedString *string = [[NSAttributedString alloc] initWithData:[agreement dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:&error];
        [self.agreementText setAttributedText:string];
        self.agreementText.font = [UIFont systemFontOfSize:12];
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
