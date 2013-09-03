//
//  SpotTag+Create.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SpotTag+Create.h"

@implementation SpotTag (Create)


+ (SpotTag *)spotTagWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    SpotTag *spotTag = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpotTag"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if(!matches || [matches count] > 1){
            //handle error
    }else if(![matches count]){
            //create
        
            //trim it
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        spotTag = [NSEntityDescription insertNewObjectForEntityForName:@"SpotTag" inManagedObjectContext:context];
        spotTag.name = name;

        NSString *sectionHeading = @"";

        if([name length]) sectionHeading = [name substringWithRange:NSMakeRange(0, 1)];
        
        spotTag.sectionHeading = sectionHeading;

    }else{
            //use it
        spotTag = [matches lastObject];
    }


    return spotTag;
}

+ (NSSet *)spotTagsWithNames:(NSArray *)names inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *aMutableArray = [NSMutableArray array];

    for(id name in names){
        if([name isKindOfClass:[NSString class]]){
            [aMutableArray addObject:[SpotTag spotTagWithName:name inManagedObjectContext:context]];
        }
    }

    return [NSSet setWithArray:aMutableArray];
}

+ (NSInteger)numberOfPhotosForSpotTagWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSInteger numberOfPhotos = 0;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedCaseInsensitiveCompare:)]];

    request.predicate = [NSPredicate predicateWithFormat:@"ANY spotTag.name = %@", name];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];    

    if([matches count]){
        numberOfPhotos = [matches count];
    }

    return numberOfPhotos;
}

@end
