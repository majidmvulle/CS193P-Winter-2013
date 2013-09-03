//
//  SpotTVC.h
//  SPoT
//
//  Created by Majid Mvulle on 8/9/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface SpotTVC : UITableViewController
@property (nonatomic, strong) NSArray *photos;
- (NSString *)titleForRow:(NSUInteger)row;//abstract
- (NSString *)subtitleForRow:(NSUInteger)row;//abstract
@end
