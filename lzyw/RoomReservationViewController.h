//
//  RoomReservationViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/2.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BaseViewController.h"
#import "ReservationInfo.h"
#import "LoadingView.h"

@interface RoomReservationViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ABPeoplePickerNavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *storeInfoViewBG;
@property (weak, nonatomic) IBOutlet UIImageView *roomIcon;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *storeContactNumber;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *priceType;
@property (weak, nonatomic) IBOutlet UITextField *reservationDate;
@property (weak, nonatomic) IBOutlet UIButton *today;
@property (weak, nonatomic) IBOutlet UIButton *tomorrow;
@property (weak, nonatomic) IBOutlet UIButton *afterTomorrow;
@property (weak, nonatomic) IBOutlet UICollectionView *reservationCalendar;
@property (weak, nonatomic) IBOutlet UITextField *contactName;
@property (weak, nonatomic) IBOutlet UITextField *contactNumber;
@property (weak, nonatomic) IBOutlet UIButton *male;
@property (weak, nonatomic) IBOutlet UIButton *female;
@property (weak, nonatomic) IBOutlet UICollectionView *reservationType;
@property (weak, nonatomic) IBOutlet UITextField *remarkInfo;
@property (weak, nonatomic) IBOutlet UIButton *reservation;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet LoadingView *loadingView;

@property NSString* orderID;
@property NSString* subOrderID;
@property NSString* roomID;

@property enum ReservationVia reservationVia;
@property ReservationInfo* reservationInfo;

@end
