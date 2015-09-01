//
//  SecondViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/12.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "StoreInfo.h"
#import "StoreDetailViewController.h"
#import "Constants.h"
#import "UrlConstants.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    netConnection = [[NetConnection alloc] init];
    netConnection.delegate = self;
    
    CGRect rx = [UIScreen mainScreen].bounds;
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.view addSubview:mapView];
    
    self.loadingView = [LoadingView initView];
    [self.loadingView setFrame:CGRectMake(0, 0, rx.size.width, rx.size.height)];
    [self.loadingView showView];
    [self.view addSubview:self.loadingView];
    
    [self.searchInput setBackground:[[UIImage imageNamed:@"map_search_input_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 5, 5)]];
    self.searchInput.delegate = self;
    
    storeArray = [NSMutableArray array];
    pointAnnotationArray = [NSMutableArray array];
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
    
    mapView.userTrackingMode = BMKUserTrackingModeNone;
    mapView.showsUserLocation = YES;//显示定位图层
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self getNetData];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)bmkMapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[bmkMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorPurple;
//        annotationView.image = [UIImage imageNamed:@"pin_red.png"];
        
        // 从天上掉下效果
        annotationView.animatesDrop = NO;
        // 设置可拖拽
        annotationView.draggable = NO;
    }
    return annotationView;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    int index = view.tag;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StoreDetailViewController* viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"StoreDetailViewController"];
    StoreInfo* storeInfo = (StoreInfo*)[storeArray objectAtIndex:index];
    viewController.storeID = storeInfo.storeID;
    viewController.title = storeInfo.name;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    NSLog(@"paopaoclick");
}

#pragma mark implement Location delegate
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [mapView updateLocationData:userLocation];
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [mapView updateLocationData:userLocation];
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [locService stopUserLocationService];
    [self getNetData];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (IBAction)startSearch:(id)sender {
    [self getNetData];
}

-(void)clearData {
    //clear data
    [storeArray removeAllObjects];
    [mapView removeAnnotations:pointAnnotationArray];
    [pointAnnotationArray removeAllObjects];
}

-(void)getNetData {
    [self clearData];
    [self.loadingView showView];
  
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    
    [paramsDic setValue:[appDelegate.memberInfo getLocation] forKey:@"location"];
    [paramsDic setValue:self.searchInput.text forKey:@"keywords"];
    
    [netConnection startConnect:mapStoreListUrl paramsDictionary:paramsDic];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    if (isSucceed) {
        NSString* output = [result objectForKey:message];
        
        NSString* msg = [self parseJson: output];
        
        if ([msg isEqualToString:@"no_store"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"没有搜索到相关商家" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        } else {
            CLLocationCoordinate2D coor1;
            CLLocationCoordinate2D coor2;
            StoreInfo* info = [storeArray objectAtIndex:0];
            coor1.latitude = info.latitude;
            coor1.longitude = info.longitude;
            coor2.latitude = info.latitude;
            coor2.longitude = info.longitude;
            
            int index = 0;
            for (StoreInfo* storeInfo in storeArray) {
                BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
                CLLocationCoordinate2D coor;
                coor.latitude = storeInfo.latitude;
                coor.longitude = storeInfo.longitude;
                
                if (coor1.latitude > storeInfo.latitude) {
                    coor1.latitude = storeInfo.latitude;
                }
                if (coor1.longitude > storeInfo.longitude) {
                    coor1.longitude = storeInfo.longitude;
                }
                if (coor2.latitude < storeInfo.latitude) {
                    coor2.latitude = storeInfo.latitude;
                }
                if (coor2.longitude < storeInfo.longitude) {
                    coor2.longitude = storeInfo.longitude;
                }
                
                pointAnnotation.coordinate = coor;
                pointAnnotation.title = storeInfo.name;
                [mapView addAnnotation:pointAnnotation];
                [pointAnnotationArray addObject:pointAnnotation];
                [mapView viewForAnnotation:pointAnnotation].tag = index;
                index++;
            }
            
            CLLocationCoordinate2D center;
            center.latitude = (coor1.latitude+coor2.latitude)/2;
            center.longitude = (coor1.longitude+coor2.longitude)/2;
            BMKCoordinateRegion region ;//表示范围的结构体
            region.center = center;//中心点
            region.span.latitudeDelta = coor2.latitude-center.latitude;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
            region.span.longitudeDelta = coor2.longitude-center.longitude;//纬度范围
            [mapView setRegion:region animated:YES];
        }

    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:errorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
    
    self.loadingView.hidden = YES;
}

-(NSString*)parseJson:(NSString*)jsonString {
    NSData *data= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonDictionary != nil && error == nil) {
        NSArray* arrStore = [jsonDictionary objectForKey:@"content"];
        if (arrStore.count != 0) {
            for (NSDictionary *dicStore in arrStore) {
                StoreInfo* storeInfo = [[StoreInfo alloc] init];
                storeInfo.storeID = [dicStore objectForKey:@"business_id"];
                storeInfo.name = [dicStore objectForKey:@"name"];
                storeInfo.address = [dicStore objectForKey:@"address"];
                storeInfo.stars = [[dicStore objectForKey:@"recommend"] floatValue];
                storeInfo.cpp = [dicStore objectForKey:@"cpp"];
                
                NSString* location = [dicStore objectForKey:@"map_label"];
                NSArray *coordinate = [location componentsSeparatedByString:@","];
                storeInfo.longitude = [((NSString*)[coordinate objectAtIndex:0]) doubleValue];
                storeInfo.latitude = [((NSString*)[coordinate objectAtIndex:1]) doubleValue];
                
                [storeArray addObject:storeInfo];
            }
        } else {
            return @"no_store";
        }
        
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] autoLogout:[[jsonDictionary objectForKey:@"is_login" ] boolValue]];
    }
    
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
