//
//  PhotoTVC.m
//  SPoT
//
//  Created by Majid Mvulle on 8/10/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PhotoTVC.h"
#import "RecentsTVC.h"


@interface PhotoTVC()
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, weak) NSDictionary *aPhoto;
@end

@implementation PhotoTVC

@synthesize photos = _photos;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([segue.identifier isEqualToString:@"Show ImageVC"]){
        [super prepareForSegue:segue sender:sender];
        
        if(self.aPhoto){
            RecentsTVC *recents = [[RecentsTVC alloc] init];
            recents.recentPhoto = [self.aPhoto mutableCopy];
        }

    }
}

- (NSArray *)photos
{
        //Sort Aplhabetically
    return [_photos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [[obj1 objectForKey:FLICKR_PHOTO_TITLE ] compare:[obj2 objectForKey:FLICKR_PHOTO_TITLE]];
    }];
}



- (void)setPhotosTag:(NSString *)photosTag
{
    _photosTag = photosTag;
    self.title = photosTag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.photosTag;

}

@end
