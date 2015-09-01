//
//  PayOrderViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/5.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StoreDetailInfo.h"
#import "LoadingView.h"
#import "PayPasswordView.h"
#import "PaymentTask.h"
#import "AlipayManager.h"

@interface PayOrderViewController : BaseViewController<AlipayManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderSN;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UILabel *acount;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *payRest;

@property (weak, nonatomic) IBOutlet UIImageView *tipBG;

@property (weak, nonatomic) IBOutlet UIButton *paymentLezi;
@property (weak, nonatomic) IBOutlet UIButton *paymentAli;
@property (weak, nonatomic) IBOutlet UIButton *paymentYL;

@property (weak, nonatomic) IBOutlet UIButton *payNow;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;
@property PayPasswordView *passwordDlg;

@property PaymentTask* paymentTask;
@property AlipayManager* alipayManager;

@property NSString* orderSNValue;
@property NSString* storeNameValue;
@property NSString* priceType;
@property NSString* orderID;
@property NSString* pricePay;
@property BOOL isFromOrder;
@property enum ServiceType serviceType;

@end
