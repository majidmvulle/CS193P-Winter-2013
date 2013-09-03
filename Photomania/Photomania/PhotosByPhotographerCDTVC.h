//
//  PhotosByPhotographerCDTVC.h
//  Photomania
//
//  Created by Majid Mvulle on 8/18/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Photographer.h"

@interface PhotosByPhotographerCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Photographer *photographer;

@end
