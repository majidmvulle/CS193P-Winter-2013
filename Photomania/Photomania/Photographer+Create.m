//
//  Photographer+Create.m
//  Photomania
//
//  Created by Majid Mvulle on 8/18/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)


+ (Photographer *)photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photographer *photographer = nil;

    if(name.length){
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];

        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];

        if(!matches || ([matches count] > 1)){
                //handle error
        }else if(![matches count]){ // no record found
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
            photographer.name = name;

        }else{
            photographer = [matches lastObject];
        }
    }

    return photographer;
}

@end
