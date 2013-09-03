//
//  Photo.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/23/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recent, SpotTag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * padImageURL;
@property (nonatomic, retain) NSString * phoneImageURL;
@property (nonatomic, retain) NSString * photographerName;
@property (nonatomic, retain) NSString * sectionHeading;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnailImage;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Recent *recent;
@property (nonatomic, retain) NSSet *spotTag;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addSpotTagObject:(SpotTag *)value;
- (void)removeSpotTagObject:(SpotTag *)value;
- (void)addSpotTag:(NSSet *)values;
- (void)removeSpotTag:(NSSet *)values;

@end
