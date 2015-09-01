//
//  SearchFactorView.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/3.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "ZYRatingView.h"
#import "PublicInfo.h"
#import "SearchInfo.h"

@interface SearchFactorView : UIView<UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RatingViewDelegate>{
    PublicInfo* publicInfo;
    int cityIndex;
    int areaIndex;
    int regionIndex;
    int tempCityIndex;
    int tempAreaIndex;
    int tempRegionIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *region;

@property (weak, nonatomic) IBOutlet UICollectionView *roomType;
@property (weak, nonatomic) IBOutlet NMRangeSlider *cpp;
@property (weak, nonatomic) IBOutlet UILabel *cppMin;
@property (weak, nonatomic) IBOutlet UILabel *cppMax;
@property (weak, nonatomic) IBOutlet ZYRatingView *recommendStars;
@property (strong, nonatomic) IBOutlet UILabel *starsText;

@property (strong, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *pickConfirm;
@property (strong, nonatomic) IBOutlet UIButton *pickCancel;

@property SearchInfo* searchInfo;

+(SearchFactorView *)initView;

@end
