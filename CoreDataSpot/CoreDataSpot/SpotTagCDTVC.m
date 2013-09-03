//
//  SpotTagCDTVC.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SpotTagCDTVC.h"
#import "SpotTag.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "CoreDataHelper.h"

@interface SpotTagCDTVC()<UIAlertViewDelegate>
@property (nonatomic, strong) UIManagedDocument *managedDocument;
@end

@implementation SpotTagCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    if(self.managedObjectContext){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpotTag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sectionHeading"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)],
                                    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; //all records

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:@"sectionHeading"
                                                                                       cacheName:nil];




    }else{
        self.fetchedResultsController = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([sender isKindOfClass:[UITableViewCell class]]){

        if([segue.identifier isEqualToString:@"setSpotTag:"]){
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

            if(indexPath){
                SpotTag *spotTag = [self.fetchedResultsController objectAtIndexPath:indexPath];

                if([segue.destinationViewController respondsToSelector:@selector(setSpotTag:)]){
                    [segue.destinationViewController performSelector:@selector(setSpotTag:) withObject:spotTag];
                }

            }
        }else if([segue.identifier isEqualToString:@"setPhotos:"]){
            if([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]){
                [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
            }
        }
    }

}


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleForHeader = @"";
    
    if(section != 0){
        titleForHeader = [[[[self.fetchedResultsController sections] objectAtIndex:(section - 1)] name] capitalizedString];
    }

    return titleForHeader;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = [[self.fetchedResultsController sections] count];

    return numberOfSections++; //Add extra section for the "All Photos" row
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger numberOfRows = 0;

    if(section == 0){
        numberOfRows = 1; //For the all row
    }else{
        numberOfRows = [[[self.fetchedResultsController sections] objectAtIndex:(section - 1)] numberOfObjects];
    }
    
    return numberOfRows;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:@"spotTag"];

    SpotTag *spotTag = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = [spotTag.name capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [spotTag.photos count]];


    return cell;
}

- (IBAction)refresh{
    [self.refreshControl beginRefreshing];

    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);

    dispatch_async(fetchQ, ^{
//        NSArray *photos = [FlickrFetcher stanfordPhotos];
        NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];

            //put the photos in Core Data

        [self.managedObjectContext performBlock:^{
            for(NSDictionary *photo in photos){
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            
                //Save without waiting for Auto Save
            [self.managedDocument saveToURL:self.managedDocument.fileURL
                           forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }]; //end performBlock
    });


}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.managedObjectContext) [self useDocument];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)useDocument
{
    CoreDataHelper *coreDataHelper = [CoreDataHelper sharedManagedDocument];
    coreDataHelper.managedDocumentFileName = @"CoreDataSpot";
    self.managedDocument = coreDataHelper.managedDocument;


    if (![coreDataHelper.fileManager fileExistsAtPath:[coreDataHelper.managedDocument.fileURL path]]){
        [coreDataHelper.managedDocument saveToURL:coreDataHelper.managedDocument.fileURL
                                 forSaveOperation:UIDocumentSaveForCreating
                                completionHandler:^(BOOL success) {
                                    if (success) {
                                        self.managedObjectContext = self.managedDocument.managedObjectContext;
                                        [self refresh];
                                    }
                                }];
    } else if (self.managedDocument.documentState == UIDocumentStateClosed) {
        [self.managedDocument openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = self.managedDocument.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = self.managedDocument.managedObjectContext;
    }
}

@end
