//
//  Recent+Create.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/19/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Recent.h"

@interface Recent (Create)

+ (Recent *)recentWithPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
