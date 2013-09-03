//
//  GenericPhotoTVC.m
//  SPoT
//
//  Created by Majid Mvulle on 8/14/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "GenericPhotoTVC.h"
#import "ImageViewController.h"


@interface GenericPhotoTVC ()<UISplitViewControllerDelegate>
@property (nonatomic, weak) NSDictionary *aPhoto;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (nonatomic, strong) UIBarButtonItem *myBarButtonItem;
@end

@implementation GenericPhotoTVC



#pragma mark - UISplitViewController delegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
        //Grab a reference to the popover
    self.popOver = pc;

    barButtonItem.title = @"Photos";

    self.myBarButtonItem = barButtonItem;

    id detailViewController = [self.splitViewController.viewControllers lastObject];

    if([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)]){
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:self.myBarButtonItem];
    }
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
        //Nill out the pointer to the popover
    self.popOver = nil;
    self.myBarButtonItem = nil;

    id detailViewController = [self.splitViewController.viewControllers lastObject];

    if([detailViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)]){
        [detailViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:self.myBarButtonItem];

    }

}

- (UIPopoverController *)popOver
{
    if(_popOver) [_popOver dismissPopoverAnimated:YES];
    
    return _popOver;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([segue.identifier isEqualToString:@"Show ImageVC"]){
        if([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
            ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;

            if([self.photos[[self.tableView indexPathForCell:cell].item] isKindOfClass:[NSDictionary class]]){
                self.aPhoto = self.photos[[self.tableView indexPathForCell:cell].item];
                ivc.imageURL = [FlickrFetcher urlForPhoto:self.aPhoto format:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? FlickrPhotoFormatLarge
                                                                              : UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? FlickrPhotoFormatOriginal : FlickrPhotoFormatSquare)];
                ivc.photoTitle = [self.aPhoto objectForKey:FLICKR_PHOTO_TITLE];
                ivc.photoID = [self.aPhoto objectForKey:FLICKR_PHOTO_ID];
            }

//            #warning: Fix the left bar button issue
            UIBarButtonItem *barButtonItem = ivc.barButtonItem;
            self.myBarButtonItem = barButtonItem;
            
        }
    }
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [[[self.photos[row] objectForKey:FLICKR_PHOTO_TITLE] description] capitalizedString];
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [[self.photos[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
}

@end
