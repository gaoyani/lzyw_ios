//
//  SecondViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "BaseViewController.h"
#import "LoadingView.h"
#import "NetConnection.h"

@interface SecondViewController : BaseViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, UITextFieldDelegate, NetConnectionDelegate> {
    BMKMapView* mapView;
    BMKLocationService* locService;
    
    NSMutableArray* storeArray;
    NSMutableArray* pointAnnotationArray;
    
    NetConnection* netConnection;
}

@property (weak, nonatomic) IBOutlet UITextField *searchInput;
@property LoadingView* loadingView;

-(NSString*)parseJson:(NSString*)jsonString;
-(void)getNetData;

@end

