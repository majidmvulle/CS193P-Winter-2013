//
//  PhotographerMapViewController.h
//  Photomania
//
//  Created by Majid Mvulle on 8/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "MapViewController.h"

@interface PhotographerMapViewController : MapViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (void)reload;

@end
