//
//  Photo+MKAnnotation.h
//  Photomania
//
//  Created by Majid Mvulle on 8/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Photo.h"
#import <MapKit/MapKit.h>

@interface Photo (MKAnnotation) <MKAnnotation>

- (UIImage *)thumbnail; //blocks

@end
