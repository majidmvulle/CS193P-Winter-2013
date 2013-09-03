//
//  FeaturedViewController.m
//  SPoT
//
//  Created by Majid Mvulle on 8/9/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "FeaturedTVC.h"
#import "PhotoTVC.h"
#import "SpotCache.h"

@interface FeaturedTVC()
@end

@implementation FeaturedTVC

@synthesize photos = _photos;

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Show PhotoTVC"]){
        if([segue.destinationViewController isKindOfClass:[PhotoTVC class]]){
            UITableViewCell *cell = (UITableViewCell *)sender;
            id aRow = self.photos[[self.tableView indexPathForCell:cell].item];
            NSString *cellTitle = cell.textLabel.text;

            
            PhotoTVC *ptvc = (PhotoTVC *)segue.destinationViewController;
            ptvc.photos = [aRow objectForKey:@"photos"];
            ptvc.photosTag = cellTitle;
        }

    }

}

- (NSString *)titleForRow:(NSUInteger)row{
    id aRow = self.photos[row];

    if([aRow isKindOfClass:[NSDictionary class]]){
        return [[[aRow objectForKey:@"tag"] description] capitalizedString];
    }

    return nil;
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    id aRow = self.photos[row];

    if([aRow isKindOfClass:[NSDictionary class]]){
        int numberOfPhotos = [[aRow objectForKey:@"photos"] count];
        return [NSString stringWithFormat:@"%d %@",
                numberOfPhotos,
                numberOfPhotos < 2 ? @"photo" : @"photos"];
    }

    return nil;
}


+ (NSArray *)stanfordPhotos
{
    NSMutableArray *aMutablearray = [NSMutableArray array];
    NSMutableDictionary *photosByTags = [NSMutableDictionary dictionary];

    for(id photo in [FlickrFetcher stanfordPhotos]){
        if([photo isKindOfClass:[NSDictionary class]]){
            NSArray *tags = [[photo objectForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];

            [tags enumerateObjectsUsingBlock:^(id tag, NSUInteger index, BOOL *stop){
                if(![tag isEqualToString:@"cs193pspot"] &&
                   ![tag isEqualToString:@"potrait"] &&
                   ![tag isEqualToString:@"landscape"]){
                    id aValue = [photosByTags valueForKey:tag];
                    if(aValue != nil && [aValue isKindOfClass:[NSMutableArray class]]){
                        [aValue addObject:photo];
                        [photosByTags setObject:aValue forKey:tag];
                    }else{
                        [photosByTags setObject:[NSMutableArray arrayWithObject:photo] forKey:tag];
                    }
                }
                
            }];

        }
    }

    for(id aKey in [photosByTags allKeys]){
        NSMutableDictionary *aDict = [[NSMutableDictionary alloc]
                                      initWithObjects:@[aKey,
                                      [photosByTags objectForKey:aKey]]
                                      forKeys:@[@"tag",
                                      @"photos"]];

        [aMutablearray addObject:aDict];
    }

        //Sort tags alphabetically
    return [aMutablearray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [[obj1 objectForKey:@"tag" ] compare:[obj2 objectForKey:@"tag"]];
    }];
    
}

- (NSArray *)photos
{

    if(!_photos) _photos = [FeaturedTVC stanfordPhotos];

    return _photos;
}

- (void)refreshTable
{
    [self.refreshControl beginRefreshing];

    dispatch_queue_t loaderQ = dispatch_queue_create("Flickr Loader", NULL);

    dispatch_async(loaderQ, ^{

        NSArray *latestPhotos = [FeaturedTVC stanfordPhotos];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });

    });

}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshTable];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
}
@end
