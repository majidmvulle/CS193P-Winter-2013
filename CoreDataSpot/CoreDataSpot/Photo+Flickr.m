//
//  Photo+Flickr.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "SpotTag+Create.h"

@implementation Photo (Flickr)


+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", photoDictionary[FLICKR_PHOTO_ID]];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if(!matches || [matches count] > 1){
            //handle error
    }else if(![matches count]){
            //create

        NSURL *thumbnailURL = [FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare];
            //        NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailURL];

            //        NSMutableArray *tags = [NSMutableArray array];

            //        [[photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            //            if(![@[@"cs193pspot", @"potrait", @"landscape"] containsObject:obj]){
            //                [tags addObject:obj];
            //            }
            //        }];

        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];

        NSString *photoTitle = [photoDictionary[FLICKR_PHOTO_TITLE]
                                stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        photo.unique = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoTitle description];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
            //        photo.thumbnailImage = thumbnailData;
        photo.thumbnailURL = [thumbnailURL absoluteString];
        photo.phoneImageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.padImageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatOriginal] absoluteString];
        photo.spotTag = [SpotTag spotTagsWithNames:[photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "] inManagedObjectContext:context];
        photo.photographerName = [photoDictionary[FLICKR_PHOTO_OWNER] description];

        NSString *sectionHeading = @"";
       
        if([photoTitle length]) sectionHeading = [photoTitle substringWithRange:NSMakeRange(0, 1)];

        photo.sectionHeading = sectionHeading;
        
    }else{
            //use it
        photo = [matches lastObject];
    }

    return photo;
}

+ (void)deletePhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", photo.unique];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if([matches count]){
        [context deleteObject:photo];
        
    }else{
        NSLog(@"Record doesn't exist: %@", error);
    }

}

@end
