//
//  RoomReservationViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "RoomReservationViewController.h"
#import "AppDelegate.h"
#import "RoomDetialViewController.h"
#import "TimeSlotTask.h"
#import "PayOrderViewController.h"
#import "Constants.h"
#import "Utils.h"

@interface RoomReservationViewController () {
    NSDate* todayDate;
    NSDate* tomorrowDate;
    NSDate* afterTomorrowDate;
    PublicInfo* publicInfo;
    StoreDetailInfo* storeInfo;
    RoomInfo* roomInfo;
    
    int sex;
    
    NSMutableArray* curTimeSlotArray;
    TimeSlotTask* timeSlotTask;
    
    UIImage* selectedImg;
    UIImage* singleSelectedImg;
    UIImage* unselectedImg;
}

@end

@implementation RoomReservationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"包间预定";
    
    selectedImg = [[UIImage imageNamed:@"type_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 30, 40)];
    singleSelectedImg = [[UIImage imageNamed:@"type_single_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 30, 40)];
    unselectedImg = [[UIImage imageNamed:@"type_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 40, 40)];
    
    AppDelegate* appDelegate = ((AppDelegate*)[UIApplication sharedApplication].delegate);
    publicInfo = appDelegate.publicInfo;
    storeInfo = appDelegate.storeDetailInfo;
    roomInfo = appDelegate.roomInfo;
    curTimeSlotArray = [NSMutableArray array];
    timeSlotTask = [[TimeSlotTask alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateTimeSlots:)
     name:@"updateTimeSlots"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(submitReservationResult:)
     name:@"submitReservationResult"
     object:nil];
    
    self.reservationCalendar.dataSource = self;
    self.reservationCalendar.delegate = self;
    [self.reservationCalendar registerNib:[UINib nibWithNibName:@"TimeSlotCell" bundle:nil] forCellWithReuseIdentifier:@"TimeSlotCell"];
    self.reservationType.dataSource = self;
    self.reservationType.delegate = self;
    [self.reservationType registerNib:[UINib nibWithNibName:@"TimeSlotCell" bundle:nil] forCellWithReuseIdentifier:@"TimeSlotCell"];
    
    [self.storeInfoViewBG setImage:[[UIImage imageNamed:@"info_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 10, 2)]];
    [self.reservation setBackgroundImage:[[UIImage imageNamed:@"button_orange_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateNormal];
    [self.reservation setBackgroundImage:[[UIImage imageNamed:@"button_orange_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateHighlighted];
    self.reservationInfo = [[ReservationInfo alloc] init];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    [self initDate];
    
    sex = male;
    [self resetSexButton];
    
    self.contactName.delegate = self;
    self.contactNumber.delegate = self;
    self.remarkInfo.delegate = self;
    
    if (self.reservationVia == ReservationViaRoom) {
        [self setInfo:appDelegate];
    } else {
        [self.loadingView showView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo:) name:@"updateInfo" object:nil];
        [self.reservationInfo getInfo:self.orderID subOrderID:(self.reservationVia == ReservationViaOrder ? @"" : self.subOrderID)];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark--UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UICollectionView class]])
    {
        return NO;
    }
    return YES;
}

-(void)updateInfo:(NSNotification*)notification {
    BOOL isSuccess = [[[notification userInfo] valueForKey:succeed] boolValue];
    if (isSuccess == YES) {
        [self loadIcon:self.reservationInfo.storeIconUrl];
        [self.storeName setText:self.reservationInfo.storeName];
        [self.roomName setText:[NSString stringWithFormat:@"%@：%@", self.reservationInfo.roomName, self.reservationInfo.roomInfo]];
        [self.storeContactNumber setText:[NSString stringWithFormat:@"联系电话：%@", self.reservationInfo.storePhone]];
        [self.price setText:[NSString stringWithFormat:@"¥%@", self.reservationInfo.price]];
        [self.priceType setText:self.reservationInfo.priceType];
        
        self.contactName.text = self.reservationInfo.contacts;
        self.contactNumber.text = self.reservationInfo.phoneNum;
        self.remarkInfo.text = self.reservationInfo.otherInfo;
        [self.reservationType selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:[publicInfo getResTypeIndex:self.reservationInfo.type]] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self setDate];
        if (self.reservationVia == ReservationViaSubOrder) {
            self.contactName.enabled = NO;
            self.contactNumber.enabled = NO;
            self.remarkInfo.enabled = NO;
            self.male.enabled = NO;
            self.female.enabled = NO;
            self.reservationType.allowsSelection = NO;
        }
    } else {
        NSString* errorMsg = [[notification userInfo] valueForKey:errorMessage];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
    
    self.loadingView.hidden = YES;
}

-(void)setDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:todayDate];
    NSArray *ymd = [self.reservationInfo.time componentsSeparatedByString:@"-"];
    [comps setYear:[((NSString*)[ymd objectAtIndex:0]) integerValue]];
    [comps setMonth:[((NSString*)[ymd objectAtIndex:1]) integerValue]];
    [comps setDay:[((NSString*)[ymd objectAtIndex:2]) integerValue]];
    
    NSDate *date = [calendar dateFromComponents:comps];
    [self dateDisplay:date];
}

-(void)setInfo:(AppDelegate*)appDelegate {
    [self loadIcon:storeInfo.iconUrl];
    [self.storeName setText:storeInfo.name];
    [self.roomName setText:[NSString stringWithFormat:@"%@：%@", roomInfo.name, roomInfo.otherInfo]];
    [self.storeContactNumber setText:[NSString stringWithFormat:@"联系电话：%@", storeInfo.phoneNumber]];
    [self.price setText:[NSString stringWithFormat:@"¥%@", roomInfo.price]];
    [self.priceType setText:roomInfo.priceType];
    
    self.contactName.text = appDelegate.memberInfo.realName;
    self.contactNumber.text = appDelegate.memberInfo.phoneNum;
}

-(void)initDate {
    todayDate=[NSDate date];
    tomorrowDate = [[NSDate alloc]initWithTimeInterval:24*60*60 sinceDate:todayDate];
    afterTomorrowDate = [[NSDate alloc]initWithTimeInterval:2*24*60*60 sinceDate:todayDate];
    [self resetDateButton:1];
    
    NSDate* maxDate = [[NSDate alloc]initWithTimeInterval:7*24*60*60 sinceDate:todayDate];
    self.datePicker.minimumDate = todayDate;
    self.datePicker.maximumDate = maxDate;
    [self.datePicker setDate:todayDate animated:YES];
}

-(void)loadIcon:(NSString*)iconUrl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:iconUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.roomIcon.image = image;
            });
        }
    });
}

- (IBAction)threeDayClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    [self resetDateButton:button.tag];
}

-(void)resetDateButton:(NSInteger)buttonTag{
    if (buttonTag == 1) {
        [self.today setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.today setBackgroundImage:singleSelectedImg forState:UIControlStateHighlighted];
        [self.tomorrow setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.tomorrow setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.afterTomorrow setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.afterTomorrow setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self dateDisplay:todayDate];
        [self.datePicker setDate:todayDate animated:YES];
    } else if (buttonTag == 2) {
        [self.today setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.today setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.tomorrow setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.tomorrow setBackgroundImage:singleSelectedImg forState:UIControlStateHighlighted];
        [self.afterTomorrow setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.afterTomorrow setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self dateDisplay:tomorrowDate];
        [self.datePicker setDate:tomorrowDate animated:YES];
    } else if (buttonTag == 3) {
        [self.today setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.today setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.tomorrow setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.tomorrow setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.afterTomorrow setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.afterTomorrow setBackgroundImage:singleSelectedImg forState:UIControlStateHighlighted];
        [self dateDisplay:afterTomorrowDate];
        [self.datePicker setDate:afterTomorrowDate animated:YES];
    } else {
        [self.today setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.today setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.tomorrow setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.tomorrow setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.afterTomorrow setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.afterTomorrow setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
    }
}

- (IBAction)maleClick:(id)sender {
    sex = male;
    [self resetSexButton];
}

- (IBAction)femalClick:(id)sender {
    sex = female;
    [self resetSexButton];
}

-(void)resetSexButton {
    if (sex == male) {
        [self.male setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.male setBackgroundImage:singleSelectedImg forState:UIControlStateHighlighted];
        [self.female setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.female setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
    } else {
        [self.male setBackgroundImage:unselectedImg forState:UIControlStateNormal];
        [self.male setBackgroundImage:unselectedImg forState:UIControlStateHighlighted];
        [self.female setBackgroundImage:singleSelectedImg forState:UIControlStateNormal];
        [self.female setBackgroundImage:singleSelectedImg forState:UIControlStateHighlighted];
    }
}

- (IBAction)dateClick:(id)sender {
    self.datePicker.hidden = NO;
}

- (void)chooseDate:(UIDatePicker *)sender {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *curComps  = [calendar components:unitFlags fromDate:sender.date];
    NSDateComponents *todayComps  = [calendar components:unitFlags fromDate:todayDate];
    NSDateComponents *tomorrowComps  = [calendar components:unitFlags fromDate:tomorrowDate];
    NSDateComponents *afterTomorrowComps  = [calendar components:unitFlags fromDate:afterTomorrowDate];
    
    if ([curComps month] == [todayComps month] && [curComps day] == [todayComps day]) {
        [self resetDateButton:1];
    } else if ([curComps month] == [tomorrowComps month] && [curComps day] == [tomorrowComps day]) {
        [self resetDateButton:2];
    } else if ([curComps month] == [afterTomorrowComps month] && [curComps day] == [afterTomorrowComps day]) {
        [self resetDateButton:3];
    } else {
        [self resetDateButton:-1];
        [self dateDisplay:sender.date];
    }
    self.datePicker.hidden = YES;
}

-(void)dateDisplay:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    self.reservationDate.text = dateString;
    
    [timeSlotTask getTimeSlots:(self.reservationVia == ReservationViaRoom ? roomInfo.serviceID : self.roomID) date:dateString timeSlotArray:curTimeSlotArray];
}

-(void)updateTimeSlots:(NSNotification *)notification{
    BOOL isSuccess = [[[notification userInfo] valueForKey:succeed] boolValue];
    if (isSuccess == YES) {
        [self.reservationCalendar reloadData];
    } else {
        NSString* errorMsg = [[notification userInfo] valueForKey:errorMessage];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
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
        self.contactNumber.text = phoneNO;
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    return YES;
}

- (IBAction)reservationClick:(id)sender {
    if ([self.contactNumber.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写联系人电话号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    [self.loadingView setLoadingText:@"正在提交..."];
    [self.loadingView showView];
    self.reservationInfo.time = self.reservationDate.text;
    self.reservationInfo.otherInfo = self.remarkInfo.text;
    self.reservationInfo.contacts = self.contactName.text;
    self.reservationInfo.phoneNum = self.contactNumber.text;
    self.reservationInfo.sex = sex;
    
    for (TimeSlotInfo* timeSlotInfo in publicInfo.resTypeArray) {
        if (timeSlotInfo.isReserved) {
            self.reservationInfo.type = timeSlotInfo.ID;
            break;
        }
    }
    
    [self.reservationInfo.timeList removeAllObjects];
    for (TimeSlotInfo* timeSlotInfo in curTimeSlotArray) {
        if (timeSlotInfo.isReserved) {
            [self.reservationInfo.timeList addObject:timeSlotInfo.ID];
        }
    }
    
    [self.reservationInfo submitRoomReservationInfo];
}

-(void)submitReservationResult:(NSNotification *)notification{
    BOOL isSuccess = [[[notification userInfo] valueForKey:succeed] boolValue];
    if (isSuccess == YES) {
        NSMutableArray* infoArray = [[notification userInfo] valueForKey:message];
        PayOrderViewController* viewController = [[PayOrderViewController alloc]initWithNibName:@"PayOrderViewController" bundle:nil];
        viewController.orderID = [infoArray objectAtIndex:0];
        viewController.orderSNValue = [infoArray objectAtIndex:1];
        viewController.storeNameValue = storeInfo.name;
        viewController.priceType = roomInfo.priceType;
        viewController.pricePay = [infoArray objectAtIndex:2];
        viewController.isFromOrder = NO;
        viewController.serviceType = ServiceTypeRoom;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        NSString* errorMsg = [[notification userInfo] valueForKey:errorMessage];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
    
    self.loadingView.hidden = YES;
}

#pragma mark -CollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 2) {
        return publicInfo.resTypeArray.count;
    } else {
        return curTimeSlotArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    //赋值
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView* imageBG = (UIImageView*)[cell viewWithTag:2];
    
    if (collectionView.tag == 1) {
        TimeSlotInfo* timeInfo = [curTimeSlotArray objectAtIndex:(int)indexPath.row];
        label.text = timeInfo.time;
        if (timeInfo.isBookable) {
            if (timeInfo.isReserved) {
                [imageBG setImage:selectedImg];
            } else {
                [imageBG setImage:unselectedImg];
            }
        } else {
            [imageBG setImage:[[UIImage imageNamed:@"reservation_invalid"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
        }
    } else {
        TimeSlotInfo* timeInfo = [publicInfo.resTypeArray objectAtIndex:(int)indexPath.row];
        label.text = timeInfo.time;
        if (timeInfo.isReserved) {
            [imageBG setImage:singleSelectedImg];
        } else {
            [imageBG setImage:unselectedImg];
        }
    }
    
    [cell layoutIfNeeded];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [UIScreen mainScreen].bounds;
    return CGSizeMake((rect.size.width-95-4)/3, 30);
//    return CGSizeMake(80, 30);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1) {
        TimeSlotInfo* timeInfo = [curTimeSlotArray objectAtIndex:(int)indexPath.row];
        if (timeInfo.isBookable) {
            timeInfo.isReserved = !timeInfo.isReserved;
        }
        [self.reservationCalendar reloadData];
    } else {
        for (TimeSlotInfo* timeInfo in publicInfo.resTypeArray) {
            timeInfo.isReserved = NO;
        }
        TimeSlotInfo* timeInfo = [publicInfo.resTypeArray objectAtIndex:(int)indexPath.row];
        timeInfo.isReserved = YES;
        [self.reservationType reloadData];
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
