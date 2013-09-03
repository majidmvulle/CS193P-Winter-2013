//
//  PhotographerMapViewController.m
//  Photomania
//
//  Created by Majid Mvulle on 8/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PhotographerMapViewController.h"
#import <CoreData/CoreData.h>
#import "Photographer+MKAnnotation.h"


@interface PhotographerMapViewController ()

@end

@implementation PhotographerMapViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;

        //if I am on screen
    if(self.view.window)  [self reload];
   
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"]; //photographers who have more than 2 photos.
    NSArray *photographers = [self.managedObjectContext executeFetchRequest:request error:NULL];

    [self.mapView removeAnnotations:self.mapView.annotations]; //remove current annotations
    [self.mapView addAnnotations:photographers]; //photographer implements MKAnnotation in Photographer+MKAnnotation category


}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhotographer:" sender:view];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"setPhotographer:"]){
        if([sender isKindOfClass:[MKAnnotationView class]]){
            MKAnnotationView *aView = sender;
            if([aView.annotation isKindOfClass:[Photographer class]]){
                Photographer *photographer = aView.annotation;
                
                if([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]){
                    [segue.destinationViewController performSelector:@selector(setPhotographer:) withObject:photographer];
                }
            }
        }
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
}
@end
