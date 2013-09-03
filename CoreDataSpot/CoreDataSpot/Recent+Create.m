//
//  Recent+Create.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Recent+Create.h"
#import "Photo.h"

@implementation Recent (Create)

+ (Recent *)recentWithPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Recent *recent = nil;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recent"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photo" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"photo.unique = %@", photo.unique];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if(!matches || [matches count] > 1){
            //handle error
    }else if(![matches count]){
            //create
        recent = [NSEntityDescription insertNewObjectForEntityForName:@"Recent" inManagedObjectContext:context];
        recent.viewedTime = [NSDate date];
        recent.photo = photo;
        
    }else{
        recent = [matches lastObject];
    }

    return recent;
}

@end
