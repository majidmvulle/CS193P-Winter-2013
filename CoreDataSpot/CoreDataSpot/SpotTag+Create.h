//
//  SpotTag+Create.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SpotTag.h"

@interface SpotTag (Create)

+ (NSSet *)spotTagsWithNames:(NSArray *)names inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSInteger)numberOfPhotosForSpotTagWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
