//
//  Recent.h
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/23/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Recent : NSManagedObject

@property (nonatomic, retain) NSDate * viewedTime;
@property (nonatomic, retain) Photo *photo;

@end
