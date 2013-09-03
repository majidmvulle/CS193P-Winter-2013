//
//  AllPhotosCDTVC.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/24/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "AllPhotosCDTVC.h"
#import "SpotPhotoCell.h"
#import "Photo.h"
#import "Recent+Create.h"
#import "SpotTag+Create.h"

@interface AllPhotosCDTVC ()

@end

@implementation AllPhotosCDTVC


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    self.title = @"All Photos";
    
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    if(self.managedObjectContext){

        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpotTag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];

        request.predicate = nil;//All records

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:@"name"
                                                                                       cacheName:nil];
    }else{
        self.fetchedResultsController = nil;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([segue.identifier isEqualToString:@"setupPhoto:"]){
        if([sender isKindOfClass:[UITableViewCell class]]){
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            if(indexPath){
                
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];

                SpotTag *spotTag  = [self.fetchedResultsController objectAtIndexPath:newIndexPath];

                NSArray *photos = [spotTag.photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                                                              ascending:YES
                                                                                                               selector:@selector(localizedCaseInsensitiveCompare:)]]];
                
                
                Photo *photo = [photos objectAtIndex:indexPath.item];
                
                NSDictionary *photoDetails = [NSDictionary dictionaryWithObjects:@[[NSURL URLWithString:photo.padImageURL],
                                              [NSURL URLWithString:photo.phoneImageURL],
                                              photo.unique, photo.title]
                                                                         forKeys:@[PAD_IMAGE_URL,
                                              PHONE_IMAGE_URL,
                                              PHOTO_ID, PHOTO_TITLE]];
                
                photo.recent = [Recent recentWithPhoto:photo inManagedObjectContext:self.managedObjectContext];
                NSError *error = nil;

                [self.managedObjectContext save:&error];

                if(error) NSLog(@"ManagedObject saving Error for Recent: %@", error);

                [segue.destinationViewController performSelector:@selector(setupPhoto:) withObject:photoDetails];

            }
        }
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;

    id aRow = [[[self.fetchedResultsController sections] objectAtIndex:section] name];

    if([aRow isKindOfClass:[NSString class]]){
        numberOfRows = [SpotTag numberOfPhotosForSpotTagWithName:aRow inManagedObjectContext:self.managedObjectContext];
    }

    return numberOfRows;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpotPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photocell"];

    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];

    SpotTag *spotTag  = [self.fetchedResultsController objectAtIndexPath:newIndexPath];

    NSArray *photos = [spotTag.photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                                                  ascending:YES
                                                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]]];
    

    Photo *photo = [photos objectAtIndex:indexPath.item];

    if(!photo.thumbnailImage){
        dispatch_queue_t thumbnailQ = dispatch_queue_create("Fetch Flickr Thumbnail", NULL);

        dispatch_async(thumbnailQ, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURL]];

            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photoImageView.image = [UIImage imageWithData:imageData];

            });

            [self.managedObjectContext performBlock:^{
                photo.thumbnailImage = imageData;
            }];
        });
    }else{
        cell.photoImageView.image = [UIImage imageWithData:photo.thumbnailImage];
    }

    cell.photoTitle.text = [photo.title capitalizedString];
    cell.photoOwner.text = photo.photographerName;
    cell.photoDescription.text = photo.subtitle;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Path: %@", indexPath);
    [self performSegueWithIdentifier:@"setupPhoto:" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}
@end
