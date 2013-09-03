//
//  SpotTag.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/23/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface SpotTag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sectionHeading;
@property (nonatomic, retain) NSSet *photos;
@end

@interface SpotTag (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
