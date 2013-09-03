//
//  SpotPhotoCell.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *photoTitle;
@property (weak, nonatomic) IBOutlet UILabel *photoDescription;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoOwner;
@property (weak, nonatomic) IBOutlet UILabel *viewedTime;

@end
