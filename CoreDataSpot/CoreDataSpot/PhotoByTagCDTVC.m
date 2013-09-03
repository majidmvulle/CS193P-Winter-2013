//
//  PhotoByTagCDTVC.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PhotoByTagCDTVC.h"
#import "Recent+Create.h"

@interface PhotoByTagCDTVC()<UISe
@end

@implementation PhotoByTagCDTVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];

    if([segue.identifier isEqualToString:@"setupPhoto:"]){
        if([sender isKindOfClass:[UITableViewCell class]]){
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            if(indexPath){
                Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
                photo.recent = [Recent recentWithPhoto:photo inManagedObjectContext:self.spotTag.managedObjectContext];
                NSError *error = nil;
                
                [self.spotTag.managedObjectContext save:&error];
        
                if(error) NSLog(@"ManagedObject saving Error for Recent: %@", error);

            }
        }
    }
}

- (void)setSpotTag:(SpotTag *)spotTag
{
    _spotTag = spotTag;
    [self setupFetchedResultsController];
    self.title = [![spotTag.name isEqualToString:@""] ? spotTag.name: @"No Tag" capitalizedString];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpotPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photocell"];

    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];


    if(!photo.thumbnailImage){
        dispatch_queue_t thumbnailQ = dispatch_queue_create("Fetch Flickr Thumbnail", NULL);

        dispatch_async(thumbnailQ, ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURL]];

            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photoImageView.image = [UIImage imageWithData:imageData];

            });

            [self.spotTag.managedObjectContext performBlock:^{
                photo.thumbnailImage = imageData;
            }];
        });
    }else{
        cell.photoImageView.image = [UIImage imageWithData:photo.thumbnailImage];
    }
    
    cell.photoTitle.text = [photo.title capitalizedString];
    cell.photoOwner.text = photo.photographerName;
    cell.photoDescription.text = photo.subtitle;
//    cell.photoDescription.numberOfLines = 0;
//    [cell.photoDescription sizeToFit];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)setupFetchedResultsController
{
    if(self.spotTag.managedObjectContext){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sectionHeading"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)],
                                    [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];

        request.predicate = [NSPredicate predicateWithFormat:@"ANY spotTag.name = [cd] %@", self.spotTag.name];

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.spotTag.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }else{
        self.fetchedResultsController = nil;
    }
}


- (NSArray *)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSArray *searchResults = [NSArray array];

    searchResults = [[self.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText]];

    return searchResults;
}

@end
