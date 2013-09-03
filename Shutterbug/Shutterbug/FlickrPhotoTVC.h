//
//  FlickrPhotoTVC.h
//  Shutterbug
//
//  Created by Majid Mvulle on 8/7/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//
//Will call setImageURL: as part of any "Show Image" segue

#import <UIKit/UIKit.h>

@interface FlickrPhotoTVC : UITableViewController
@property (nonatomic, strong)NSArray *photos; //of NSDictionary
@end
