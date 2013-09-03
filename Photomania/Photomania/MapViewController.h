//
//  MapViewController.h
//  Photomania
//
//  Created by Majid Mvulle on 8/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//
//  Will display a thumbnail in leftCallOutAccessoryView
//  if the annotation implements the method "thumbnail" (return UIImage)

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end
