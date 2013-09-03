//
//  RecentsViewController.m
//  SPoT
//
//  Created by Majid Mvulle on 8/9/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "RecentsTVC.h"
#import "ImageViewController.h"

@interface RecentsTVC () <UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *dictOfPhotos;
@property (nonatomic, strong) NSString *recentPhotoID;
@property (nonatomic, strong) NSDate *recentViewedTime;
@end

@implementation RecentsTVC

#define ALL_RECENTS_KEY @"Recents_All"
#define VIEWED_TIME_KEY @"Viewed_Time"
#define PHOTO_KEY @"Photo"

@synthesize photos = _photos;

- (IBAction)clearRecentPhotos:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:@"This will clear all recent photos!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ALL_RECENTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self resetTable];
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"Show ImageVC"]){
//        if([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
//            ImageViewController *ivc = (ImageViewController *)segue.destinationViewController;
//            UITableViewCell *cell = (UITableViewCell *)sender;
//
//            id aRow = self.photos[[self.tableView indexPathForCell:cell].item];
//
//            ivc.imageURL = [FlickrFetcher urlForPhoto:aRow
//                                               format:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? FlickrPhotoFormatLarge : UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? FlickrPhotoFormatOriginal : FlickrPhotoFormatSquare)];
//            ivc.photoTitle = [aRow objectForKey:FLICKR_PHOTO_TITLE];
//            ivc.photoID = [aRow objectForKey:FLICKR_PHOTO_ID];
//
//        }
//    }
//}

- (void)setRecentPhoto:(NSMutableDictionary *)recentPhoto
{
    id photoid = [recentPhoto objectForKey:FLICKR_PHOTO_ID];
    _recentPhoto = recentPhoto;

    if([photoid isKindOfClass:[NSString class]]){
        self.recentPhotoID = photoid;
    }

    [self synchronize];
}

- (void)resetTable
{
    self.photos = [self allRecentPhotos];
    [self.tableView reloadData];
}

- (void)synchronize
{
    NSMutableDictionary *mutableUserDefaults = [[[NSUserDefaults standardUserDefaults]
                                                dictionaryForKey:ALL_RECENTS_KEY] mutableCopy];

    if(!mutableUserDefaults) mutableUserDefaults = [[NSMutableDictionary alloc] init];

    self.recentViewedTime = [NSDate date];

    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[self.recentViewedTime, self.recentPhoto]
                                                     forKeys:@[VIEWED_TIME_KEY, PHOTO_KEY]];

    [mutableUserDefaults setObject:dict forKey:self.recentPhotoID];

    [[NSUserDefaults standardUserDefaults] setObject:mutableUserDefaults forKey:ALL_RECENTS_KEY];

    if([[NSUserDefaults standardUserDefaults] synchronize])
        NSLog(@"Synchronized");
    else
        NSLog(@"Not synchronized");
}

- (NSMutableArray *)allRecentPhotos
{
    NSArray *sortedKeys = [[NSArray alloc] init];
    NSMutableArray *allRecentPhotos = [[NSMutableArray alloc] init];

    NSMutableDictionary *mutableUserDefaults = [[[NSUserDefaults standardUserDefaults]
                                                 dictionaryForKey:ALL_RECENTS_KEY] mutableCopy];

    sortedKeys = [mutableUserDefaults keysSortedByValueUsingComparator:^(id obj1, id obj2){
            //reverse objects for descending order
        return [[obj2 objectForKey:VIEWED_TIME_KEY ] compare:[obj1 objectForKey:VIEWED_TIME_KEY ]];
    }];

    for(id key in sortedKeys){
        NSString *keyPath = [(NSString*)key stringByAppendingFormat:@".%@",PHOTO_KEY];
        
        [allRecentPhotos addObject:[mutableUserDefaults valueForKeyPath:keyPath]];
    }

    return allRecentPhotos;

}



- (NSArray *)photos
{
    if(!_photos) _photos = [self allRecentPhotos];

    return _photos;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
