//
//  RecentsViewController.h
//  SPoT
//
//  Created by Majid Mvulle on 8/9/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericPhotoTVC.h"

@interface RecentsTVC : GenericPhotoTVC
@property (nonatomic, strong) NSMutableDictionary *recentPhoto;
@end
