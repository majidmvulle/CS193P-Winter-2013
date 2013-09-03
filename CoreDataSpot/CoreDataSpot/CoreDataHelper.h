//
//  CoreDataHelper.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/21/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);


@interface CoreDataHelper : NSObject


@property (nonatomic, strong) NSString *managedDocumentFileName;
@property (nonatomic, strong) UIManagedDocument *managedDocument;
@property (nonatomic, strong) NSFileManager *fileManager;

+ (CoreDataHelper *)sharedManagedDocument;

- (void)openManagedDocumentUsingBlock:(void (^)(BOOL success))block;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end
