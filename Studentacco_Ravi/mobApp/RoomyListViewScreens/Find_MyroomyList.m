//
//  Find_MyroomyList.m
//  Studentacco
//
//  Created by MAG on 07/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "Find_MyroomyList.h"
#import "Roomy_listCollectionViewCell.h"
#import "FindRoomyListDetail.h"
@interface Find_MyroomyList ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation Find_MyroomyList
{
    FindRoomyListDetail *propertyDetail;
    NSMutableArray *globalListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_roomyListCollectionView registerNib:[UINib nibWithNibName:@"Roomy_listCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"roomy_listCollectionViewCell"];
    [_roomyListCollectionView setPagingEnabled:YES];
    globalListArray=[[NSMutableArray alloc]init];
    for (int index = 0; index < _roomyPropertyListArray.count; index++) {
        
        NSDictionary *dict = _roomyPropertyListArray[index];
        
        propertyDetail = [[FindRoomyListDetail alloc]init];
        propertyDetail.preferred_location = dict[@"preferred_location"];
        if ([propertyDetail.preferred_location isEqual:[NSNull null]] || [propertyDetail.preferred_location isEqualToString:@" "]) {
            propertyDetail.preferred_location = @"";
        }

        propertyDetail.full_image_path = dict[@"full_image_path"];
        if ([propertyDetail.full_image_path isEqual:[NSNull null]] || [propertyDetail.full_image_path isEqualToString:@" "]) {
            propertyDetail.full_image_path = @"";
        }
        propertyDetail.users_full_name = dict[@"users_full_name"];
        if ([propertyDetail.users_full_name isEqual:[NSNull null]] || [propertyDetail.users_full_name isEqualToString:@" "]) {
            propertyDetail.users_full_name = @"";
        }
        propertyDetail.share_my_acco = dict[@"share_my_acco"];
        if ([propertyDetail.share_my_acco isEqual:[NSNull null]] || [propertyDetail.share_my_acco isEqualToString:@" "]) {
            propertyDetail.share_my_acco = @"";
        }
        propertyDetail.food_habits = dict[@"food_habits"];
        if ([propertyDetail.food_habits isEqual:[NSNull null]] || [propertyDetail.food_habits isEqualToString:@" "]) {
            propertyDetail.food_habits = @"";
        }
        propertyDetail.smoking_habits = dict[@"smoking_habits"];
        if ([propertyDetail.smoking_habits isEqual:[NSNull null]] || [propertyDetail.smoking_habits isEqualToString:@" "]) {
            propertyDetail.smoking_habits = @"";
        }
        propertyDetail.tell_us_about_yourself = dict[@"tell_us_about_yourself"];
        if ([propertyDetail.tell_us_about_yourself isEqual:[NSNull null]] || [propertyDetail.tell_us_about_yourself isEqualToString:@" "]) {
            propertyDetail.tell_us_about_yourself = @"";
        }
        [globalListArray addObject:propertyDetail];
    }

    
    }

#pragma mark - UICollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return globalListArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-64);
    return size;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *reusableCell;
    if (indexPath.section==0) {
        
        static NSString *identifier = @"roomy_listCollectionViewCell";
        
        Roomy_listCollectionViewCell *cell = (Roomy_listCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        propertyDetail = globalListArray[indexPath.item];
        
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",propertyDetail.full_image_path]];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.roomyImageView.image=image;
                        
                    });
                }
            }
        }];
        [task resume];
//        NSArray *acco =[propertyDetail.share_my_acco componentsSeparatedByString:@","];
        cell.locationNameLabel.text=propertyDetail.preferred_location;
        cell.singleLable.text=propertyDetail.share_my_acco;
        cell.roomyNameLabel.text=propertyDetail.users_full_name;
        cell.foodHabitNameLabel.text=propertyDetail.food_habits;
        cell.smokingHabitNameLabel.text=propertyDetail.smoking_habits;
        cell.aboutMeTextView.text=propertyDetail.tell_us_about_yourself;
        
         //[cell.nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
             reusableCell = cell;
        
        
       
        }
    return reusableCell;
}
-(void)next:(UIButton*)sender
{
   
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSArray *indexPaths = [_roomyListCollectionView indexPathsForSelectedItems];
    if ( globalListArray.count > 0 )
    {
        NSIndexPath *oldIndexPath = indexPaths[0];
        NSInteger oldRow = oldIndexPath.row;
        newIndexPath = [NSIndexPath indexPathForRow:oldRow - 1 inSection:0];
    }
        [_roomyListCollectionView scrollToItemAtIndexPath:newIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
}
- (IBAction)backToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
