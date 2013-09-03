//
//  ImageViewController.h
//  Shutterbug
//
//  Created by Majid Mvulle on 8/7/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *photoTitle;
@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@end
