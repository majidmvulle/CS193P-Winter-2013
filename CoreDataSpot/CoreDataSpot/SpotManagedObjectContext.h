//
//  SpotManagedObjectContext.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/21/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SpotManagedObjectContext : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)useDocument;

@end
