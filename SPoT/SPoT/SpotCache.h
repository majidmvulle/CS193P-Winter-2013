//
//  SpotCache.h
//  SPoT
//
//  Created by Majid Mvulle on 8/12/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotCache : NSObject
@property (nonatomic, readonly) NSURL *fileURL;
- (id)initWithFileName:(NSString *)fileName;
- (BOOL)saveFileToCacheWithData:(NSData *)data;
- (NSData *)getFileFromCache;
- (BOOL)isFileExists;
@end
