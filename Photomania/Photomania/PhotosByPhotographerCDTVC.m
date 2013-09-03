//
//  PhotosByPhotographerCDTVC.m
//  Photomania
//
//  Created by Majid Mvulle on 8/18/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PhotosByPhotographerCDTVC.h"
#import "Photo.h"

@implementation PhotosByPhotographerCDTVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;

    if([sender isKindOfClass:[UITableViewCell class]]){
        indexPath = [self.tableView indexPathForCell:sender];
    }

    if(indexPath){
        if([segue.identifier isEqualToString:@"setImageURL:"]){
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];

            if([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]){
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:[NSURL URLWithString:photo.imageURL]];
            }
        }
    }
}

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    [self setupFetchedResultsController];
    self.title = photographer.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];

    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;

    return cell;
}

- (void)setupFetchedResultsController
{
    if(self.photographer.managedObjectContext){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.photographer.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }else{
        self.fetchedResultsController = nil;
    }
}

@end
