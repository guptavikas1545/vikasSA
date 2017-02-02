//
//  ProfilePictureTableViewCell.h
//  StudentAcco
//
//  Created by MAG on 28/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignupViewController.h"
@interface ProfilePictureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseImage;
@property (weak, nonatomic) IBOutlet UILabel *pictureSelectionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end
//(void) imagePickerController: (UIImagePickerController*)reader
//
//didFinishPickingMediaWithInfo: (NSDictionary*) info {
//    
//    
//    
//    
//    
//    //img_Profile.image = [info objectForKey: UIImagePickerControllerOriginalImage] ;
//    
//    
//    
//    //    img_Group.image =   [CreateGroup imageWithImage:[info objectForKey: UIImagePickerControllerOriginalImage] scaledToSize:CGSizeMake(150, 150)];
//    
//    //Set image in imageView
//    
//    img_Group.image = [UIImage imageWithImage:[info objectForKey: UIImagePickerControllerOriginalImage] scaledToFillToSize:CGSizeMake(150, 150)];
//    
//    
//    
//    [reader dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//
//
//
//
//+ (UIImage*)imageWithImage:(UIImage*)image
//
//scaledToSize:(CGSize)newSize;
//
//{
//    
//    UIGraphicsBeginImageContext( newSize );
//    
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    
//    
//    return newImage;
//    
