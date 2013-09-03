//
//  CoreDataHelper.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/21/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "CoreDataHelper.h"

#define MANAGED_DOCUMENT_NAME @"CoreDataSpot"


@implementation CoreDataHelper

@synthesize managedDocumentFileName = _managedDocumentFileName;

+ (CoreDataHelper *)sharedManagedDocument
{


        //----- It's a singleton --------------------------------------------
    static dispatch_once_t coreDataHelperDispatcher = 0;
    __strong static CoreDataHelper *_sharedManagedDocument = nil;

    dispatch_once(&coreDataHelperDispatcher, ^{
        _sharedManagedDocument = [[self alloc] init];
    });
    
    return _sharedManagedDocument;

}

- (NSFileManager *)fileManager
{
    if(!_fileManager) _fileManager = [[NSFileManager alloc] init];

    return _fileManager;
}

+ (NSURL *)documentDirectoryURL
{	
    return [[[[NSFileManager alloc] init] URLsForDirectory:NSDocumentDirectory
                                                 inDomains:NSUserDomainMask] lastObject];
}

- (UIManagedDocument *)managedDocument
{
    if (!_managedDocument) {
        
        _managedDocument = [[UIManagedDocument alloc] initWithFileURL:[[CoreDataHelper documentDirectoryURL] URLByAppendingPathComponent:self.managedDocumentFileName]];
    }
    return _managedDocument;
}

- (NSString *)managedDocumentFileName
{
    if(!_managedDocumentFileName) _managedDocumentFileName = MANAGED_DOCUMENT_NAME;

    return _managedDocumentFileName;
}

- (void)setManagedDocumentFileName:(NSString *)managedDocumentFileName
{
    if(_managedDocumentFileName != managedDocumentFileName){
        _managedDocumentFileName = managedDocumentFileName;
        self.managedDocument = nil; //reset the document
    }
}

- (void)openManagedDocumentUsingBlock:(void (^)(BOOL success))block
{
    CoreDataHelper *coreDataHelper = [CoreDataHelper sharedManagedDocument];

    if (![coreDataHelper.fileManager fileExistsAtPath:[coreDataHelper.managedDocument.fileURL path]]) {
            //Create it
        [coreDataHelper.managedDocument saveToURL:coreDataHelper.managedDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:block];

    } else if (coreDataHelper.managedDocument.documentState == UIDocumentStateClosed) {
            //Open it
        [coreDataHelper.managedDocument openWithCompletionHandler:block];

    } else {
            //Use it
        BOOL success = YES;
        block(success);
    }
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    void (^OnDocumentDidLoad)(BOOL) =^(BOOL success) {
        onDocumentReady(self.managedDocument);
    };

    if (![self.fileManager fileExistsAtPath:[self.managedDocument.fileURL path]]){
        [self.managedDocument saveToURL:self.managedDocument.fileURL forSaveOperation:UIDocumentSaveForCreating  completionHandler:OnDocumentDidLoad];

    } else if (self.managedDocument.documentState == UIDocumentStateClosed) {
        [self.managedDocument openWithCompletionHandler:OnDocumentDidLoad];

    } else if (self.managedDocument.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);

    }

}

@end
