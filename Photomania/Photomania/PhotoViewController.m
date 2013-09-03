//
//  PhotoViewController.m
//  Photomania
//
//  Created by Majid Mvulle on 8/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PhotoViewController.h"
#import "MapViewController.h"
#import "Photo+MKAnnotation.h"

@interface PhotoViewController ()
@property (nonatomic, strong) MapViewController *mapvc;
@end

@implementation PhotoViewController

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.title = photo.title;
    self.imageURL = [NSURL URLWithString:self.photo.imageURL];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Embed Map of Photo"]){
        if([segue.destinationViewController isKindOfClass:[MapViewController class]]){
            self.mapvc = segue.destinationViewController;
            NSLog(@"Seguing");
        }

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapvc.mapView addAnnotation:self.photo];
    NSLog(@"Self.photo %@", self.photo);
}
@end
