//
//  DemoPhotographerMapViewController.m
//  Photomania
//
//  Created by Majid Mvulle on 8/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "DemoPhotographerMapViewController.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@interface DemoPhotographerMapViewController ()

@end

@implementation DemoPhotographerMapViewController

- (IBAction)refresh{


    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher latestGeoreferencedUAEPhotos];
            //put the photos in Core Data

        [self.managedObjectContext performBlock:^{
            for(NSDictionary *photo in photos){
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self reload];
            });
        }]; //end performBlock
    });


}

- (void)viewDidLoad
{
    [super viewDidLoad];


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(!self.managedObjectContext) [self useDemoDocument];
}

- (void)useDemoDocument
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];

    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];

    if(![fileManager fileExistsAtPath:[url path]]){
            //create it
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success){
                self.managedObjectContext = document.managedObjectContext;
                [self refresh];
            }
        }];
    }else if(document.documentState == UIDocumentStateClosed) {
            //open it
        [document openWithCompletionHandler:^(BOOL success){
            if(success){
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    }else{
            //try to use (might check for othe document states as well)
        self.managedObjectContext = document.managedObjectContext;
    }
    
}

@end
