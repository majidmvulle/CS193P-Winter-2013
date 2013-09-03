//
//  SpotManagedObjectContext.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/21/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SpotManagedObjectContext.h"

@implementation SpotManagedObjectContext


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
        //broadcast it
    [notifCenter postNotificationName:@"SpotManagedObjectContextChanged"
                               object:self
                             userInfo:[NSDictionary dictionaryWithObject:managedObjectContext
                                                                  forKey:@"managedObjectContext"]];

    NSLog(@"Setting Context");
}

- (void)useDocument
{

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"CoreDataSpot"];

    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];

    if(![fileManager fileExistsAtPath:url.path]){
            //create it
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success){
                self.managedObjectContext = document.managedObjectContext;

//                [self refresh];
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
            //try to use (maybe check for other document states as well?)
        self.managedObjectContext = document.managedObjectContext;
        
    }

}

@end
