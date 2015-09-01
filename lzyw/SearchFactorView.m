//
//  SearchFactorView.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/3.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "SearchFactorView.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation SearchFactorView

-(void)awakeFromNib {
    publicInfo = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).publicInfo;
    
    [self.bgImageView setImage:[[UIImage imageNamed:@"menu_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 50, 1, 10)]];
    
    [self.pickConfirm setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.pickConfirm setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    [self.pickCancel setBackgroundImage:[[UIImage imageNamed:@"button_blue_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
    [self.pickCancel setBackgroundImage:[[UIImage imageNamed:@"button_blue_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    [self initAddress];
    
    self.roomType.dataSource = self;
    self.roomType.delegate = self;
    [self.roomType registerNib:[UINib nibWithNibName:@"TimeSlotCell" bundle:nil] forCellWithReuseIdentifier:@"TimeSlotCell"];
    
    [self configureLabelSlider];
    
    [self.recommendStars setImagesDeselected:@"store_rating_off.png" partlySelected:@"store_rating_on.png" fullSelected:@"store_rating_on.png" andDelegate:self];
    [self.recommendStars displayRating:3.0f];
}

-(void)initAddress {
    cityIndex = 0;
    areaIndex = 0;
    regionIndex = 0;
    tempCityIndex = 0;
    tempAreaIndex = 0;
    tempRegionIndex = 0;
    CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:0];
    self.city.text = cityInfo.name;
    if (cityInfo.areaArray.count > 0) {
        AreaInfo* areaInfo = [cityInfo.areaArray objectAtIndex:0];
        self.area.text = areaInfo.name;
        if (areaInfo.regionArray.count > 0) {
            RegionInfo* regionInfo = [areaInfo.regionArray objectAtIndex:0];
            self.region.text = regionInfo.name;
        }
    }
    
    self.city.userInteractionEnabled = YES;
    self.area.userInteractionEnabled = YES;
    self.region.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureCity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAddress)];
    [self.city addGestureRecognizer:tapGestureCity];
    UITapGestureRecognizer *tapGestureArea = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAddress)];
    [self.area addGestureRecognizer:tapGestureArea];
    UITapGestureRecognizer *tapGestureRegion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAddress)];
    [self.region addGestureRecognizer:tapGestureRegion];
}

-(void)ratingChanged:(float)newRating {
    //    [self.ratingSet displayRating:newRating];
    self.starsText.text = [NSString stringWithFormat:@"≥%d星商户",(int)newRating];
}

-(void)onClickAddress {
    self.pickerParentView.hidden = NO;
    [self.pickerView reloadAllComponents];
    [self setPickItemSelected];
}

-(void)setPickItemSelected {
    tempCityIndex = cityIndex;
    tempAreaIndex = areaIndex;
    tempRegionIndex = regionIndex;
    [self.pickerView selectRow:cityIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:areaIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:regionIndex inComponent:2 animated:YES];
}
                                 
#pragma mark pickerview function
/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return publicInfo.cityArray.count;
    } else if (component == 1) {
        return ((CityInfo*)[publicInfo.cityArray objectAtIndex:tempCityIndex]).areaArray.count;
    } else {
        CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:tempCityIndex];
        AreaInfo* areaInfo = [cityInfo.areaArray objectAtIndex:tempAreaIndex];
        return areaInfo.regionArray.count;
    }
}
                             
/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:row];
        return cityInfo.name;
    } else if (component == 1) {
        CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:tempCityIndex];
        AreaInfo* areaInfo = [cityInfo.areaArray objectAtIndex:row];
        return areaInfo.name;
    } else {
        CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:tempCityIndex];
        AreaInfo* areaInfo = [cityInfo.areaArray objectAtIndex:tempAreaIndex];
        RegionInfo* regionInfo = [areaInfo.regionArray objectAtIndex:row];
        return regionInfo.name;
    }
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        tempCityIndex = (int)row;
        [pickerView selectRow:row inComponent:1 animated:YES];
        [pickerView reloadComponent:1];
    } else if (component == 1) {
        tempAreaIndex = (int)row;
        [pickerView selectRow:row inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
    } else {
        tempRegionIndex = (int)row;
    }
}

- (IBAction)pickConfirmClick:(id)sender {
    cityIndex = tempCityIndex;
    areaIndex = tempAreaIndex;
    regionIndex = tempRegionIndex;
    self.pickerParentView.hidden = YES;
    CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:cityIndex];
    self.city.text = cityInfo.name;
    if (cityInfo.areaArray.count > 0) {
        AreaInfo* areaInfo = [cityInfo.areaArray objectAtIndex:areaIndex];
        self.area.text = areaInfo.name;
        if (areaInfo.regionArray.count > 0) {
            RegionInfo* regionInfo = [areaInfo.regionArray objectAtIndex:regionIndex];
            self.region.text = regionInfo.name;
        } else {
            self.region.text = @"";
            regionIndex = 0;
        }
    } else {
        self.area.text = @"";
        self.region.text = @"";
        areaIndex = 0;
        regionIndex = 0;
    }
}

- (IBAction)pickCancelClick:(id)sender {
    self.pickerParentView.hidden = YES;
}

#pragma mark -CollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return publicInfo.roomSizeArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //重用cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    //赋值
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView* imageBG = (UIImageView*)[cell viewWithTag:2];
    
    RoomSizeInfo* roomSizeInfo = [publicInfo.roomSizeArray objectAtIndex:(int)indexPath.row];
    label.text = roomSizeInfo.name;
    [imageBG setImage:[[UIImage imageNamed:@"type_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    
    [cell layoutIfNeeded];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(55, 20);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView* imageBG = (UIImageView*)[cell viewWithTag:2];
    RoomSizeInfo* roomSizeInfo = [publicInfo.roomSizeArray objectAtIndex:(int)indexPath.row];
    if (roomSizeInfo.isSelected) {
        roomSizeInfo.isSelected = NO;
        [imageBG setImage:[[UIImage imageNamed:@"type_unselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]];
    } else {
        roomSizeInfo.isSelected = YES;
        UIImage* image = [UIImage imageNamed:@"type_selected"];
        [imageBG setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 45, 45)]];
    }
    
    [cell layoutIfNeeded];
}

#pragma mark -
#pragma mark - Range  Slider
- (void) configureLabelSlider {
    UIImage* image = nil;
    
    image = [UIImage imageNamed:@"slider-default-trackBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    self.cpp.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"slider_track"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    self.cpp.trackImage = image;
    
    image = [UIImage imageNamed:@"slider_block"];
    image = [Utils scaleToSize:image size:CGSizeMake(10, image.size.height*10/image.size.width)];
    self.cpp.lowerHandleImageNormal = image;
    self.cpp.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"slider_block_down"];
    image = [Utils scaleToSize:image size:CGSizeMake(10, image.size.height*10/image.size.width)];
    self.cpp.lowerHandleImageHighlighted = image;
    self.cpp.upperHandleImageHighlighted = image;
    
    self.cpp.minimumValue = 0;
    self.cpp.maximumValue = publicInfo.cppMax-publicInfo.cppMin;
    
    self.cpp.lowerValue = 0;
    self.cpp.upperValue = publicInfo.cppMax-publicInfo.cppMin;
    
    self.cpp.minimumRange = 1;
    
    [self updateSliderLabels];
}

- (void) updateSliderLabels {
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.cpp.lowerCenter.x + self.cpp.frame.origin.x+16);
    lowerCenter.y = (self.cpp.center.y - 20.0f);
    self.cppMin.center = lowerCenter;
    self.cppMin.text = [NSString stringWithFormat:@"%d", (int)self.cpp.lowerValue+publicInfo.cppMin];
    
    CGPoint upperCenter;
    upperCenter.x = (self.cpp.upperCenter.x + self.cpp.frame.origin.x);
    upperCenter.y = (self.cpp.center.y - 20.0f);
    self.cppMax.center = upperCenter;
    self.cppMax.text = [NSString stringWithFormat:@"%d", (int)self.cpp.upperValue+publicInfo.cppMin];
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender {
    [self updateSliderLabels];
}

- (IBAction)searchClick:(id)sender {
    self.searchInfo.cppMin = (int)[self.cppMin.text integerValue];
    self.searchInfo.cppMax = (int)[self.cppMax.text integerValue];
    self.searchInfo.recommend = self.recommendStars.rating;
    
    CityInfo* cityInfo = [publicInfo.cityArray objectAtIndex:cityIndex];
    self.searchInfo.cityID = cityInfo.ID;
    
    AreaInfo* areaInfo = [cityInfo.areaArray objectAtIndex:areaIndex];
    self.searchInfo.areaID = areaInfo == nil ? @"" : areaInfo.ID;
    
    RegionInfo* regionInfo = [areaInfo.regionArray objectAtIndex:regionIndex];
    self.searchInfo.regionID = regionInfo == nil ? @"" : regionInfo.ID;
    
    [self.searchInfo.roomSizeArray removeAllObjects];
    for (RoomSizeInfo* info in publicInfo.roomSizeArray) {
        if (info.isSelected) {
            [self.searchInfo.roomSizeArray addObject:info.ID];
        }
    }
    
    self.searchInfo.fromSearch = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startSearch" object:self userInfo:nil];
}

+(SearchFactorView *)initView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SearchFactorView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
