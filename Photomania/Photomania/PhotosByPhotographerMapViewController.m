//
//  PhotosByPhotographerMapViewController.m
//  Photomania
//
//  Created by Majid Mvulle on 8/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PhotosByPhotographerMapViewController.h"
#import "Photo+MKAnnotation.h"

@interface PhotosByPhotographerMapViewController ()

@end

@implementation PhotosByPhotographerMapViewController

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;

        //if visible
    if(self.view.window) [self reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload]; //in viewWillAppear?
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];

    NSArray *photos = [self.photographer.managedObjectContext executeFetchRequest:request error:NULL];

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photos];

    Photo *photo = [photos lastObject];

    if(photo) self.mapView.centerCoordinate = photo.coordinate;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"setPhoto:"]){
        if([sender isKindOfClass:[MKAnnotationView class]]){
            MKAnnotationView *aView = sender;
            if([aView.annotation isKindOfClass:[Photo class]]){
                Photo *photo = aView.annotation;

                if([segue.destinationViewController respondsToSelector:@selector(setPhoto:)]){
                    [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
                }
            }
        }
    }

}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhoto:" sender:view];
}

@end
