//
//  Photographer+Create.h
//  Photomania
//
//  Created by Majid Mvulle on 8/18/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;
@end
