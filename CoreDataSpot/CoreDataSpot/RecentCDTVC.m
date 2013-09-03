//
//  RecentCDTVC.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "RecentCDTVC.h"
#import "Recent.h"
#import "CoreDataHelper.h"

@interface RecentCDTVC() <UIAlertViewDelegate>

@end

@implementation RecentCDTVC


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath && [segue.identifier isEqualToString:@"setupPhoto:"]){
            if([segue.destinationViewController respondsToSelector:@selector(setupPhoto:)]){
                Recent *recent = [self.fetchedResultsController objectAtIndexPath:indexPath];

                NSDictionary *photoDetails = [NSDictionary dictionaryWithObjects:@[[NSURL URLWithString:recent.photo.padImageURL],
                                              [NSURL URLWithString:recent.photo.phoneImageURL],
                                              recent.photo.unique, recent.photo.title]
                                                                         forKeys:@[PAD_IMAGE_URL,
                                              PHONE_IMAGE_URL,
                                              PHOTO_ID, PHOTO_TITLE]];

                [segue.destinationViewController performSelector:@selector(setupPhoto:) withObject:photoDetails];
            }
        }
    }
}

- (void)setupFetchedResultsControllerWithDocument:(UIManagedDocument *)document
{
    if(document.managedObjectContext){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recent"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"viewedTime"
                                                                  ascending:NO]];
        request.predicate = nil; //All records
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:document.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
    }else{
        self.fetchedResultsController = nil;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpotPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photocell"];

    Recent *recent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.photoImageView.image = [UIImage imageWithData:recent.photo.thumbnailImage];
    cell.photoTitle.text = [recent.photo.title capitalizedString];
    cell.photoOwner.text = [recent.photo.photographerName description];
    cell.photoDescription.text = [recent.photo.subtitle description];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    cell.viewedTime.text = [dateFormatter stringFromDate:recent.viewedTime];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[CoreDataHelper sharedManagedDocument] performWithDocument:^(UIManagedDocument *document) {
        [self setupFetchedResultsControllerWithDocument:document];
    }];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}



@end
