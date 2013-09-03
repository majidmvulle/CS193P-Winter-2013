//
//  SpotCache.m
//  SPoT
//
//  Created by Majid Mvulle on 8/12/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SpotCache.h"

@interface SpotCache() <NSFileManagerDelegate>
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, readwrite) NSURL *fileURL;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSURL *storageURL;
@property (nonatomic, strong) NSString *idiom;
@end

@implementation SpotCache

#define PAD_LIMIT 6
#define PHONE_LIMIT 10

- (int)cacheLimit
{
  return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? PAD_LIMIT : PHONE_LIMIT;
}

    //designated initializer
- (id)initWithFileName:(NSString *)fileName
{
    self = [self init];

    if(self) self.fileName = fileName;

    return self;
}

- (NSString *)idiom
{

    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"ipad" : @"iphone";
}

- (NSFileManager *)fileManager
{
    if(!_fileManager) _fileManager = [[NSFileManager alloc] init];
    
    return _fileManager;
}

- (NSURL *)searchPathDirectoryURL
{
    return [[self.fileManager URLsForDirectory:NSPicturesDirectory
                                     inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)storageURL
{
    BOOL isDir = NO;

    if([self.fileManager fileExistsAtPath:[self flickrDirectoryURL].path isDirectory:&isDir]){
        if(!isDir){
            if(![self createFlickrDirectory]){
                NSLog(@"Couldnt create Flickr Dir.");
                return nil;
            }
        }
    }else{
            //create directory
        if(![self createFlickrDirectory]){
                NSLog(@"Couldnt create Flickr Dir. 2");
            return nil;
        }

    }

    return [self flickrDirectoryURL];
}

#pragma mark - Flickr Directory

- (NSURL *)flickrDirectoryURL
{
    return [[self searchPathDirectoryURL]
            URLByAppendingPathComponent:[@"flickr/" stringByAppendingString:self.idiom ?: @""]];
}

- (BOOL)createFlickrDirectory
{
    if([self.fileManager createDirectoryAtURL:[self flickrDirectoryURL]
                  withIntermediateDirectories:YES attributes:nil error:nil]){
        return YES;
    }

    return NO;
}

- (BOOL)isFlickrDirectoryExists
{
    BOOL isDir = NO;
    
    if([self.fileManager fileExistsAtPath:self.storageURL.path isDirectory:&isDir]){
        if(isDir){
            return YES;
        }
    }

    return NO;
}

- (BOOL)isFileExists
{

    if([self.fileManager fileExistsAtPath:self.fileURL.path])
        return YES;
    
    return NO;
}


- (NSURL *)fileURL
{
    return [self.storageURL URLByAppendingPathComponent:self.fileName];
}

- (BOOL)saveFileToCacheWithData:(NSData *)data
{

    if([self.fileManager createFileAtPath:self.fileURL.path contents:data attributes:nil]){
        NSLog(@"Successfully saved to Cache");

        __block NSError *error = nil;
        __weak SpotCache *weakSelf = self;

        dispatch_queue_t limitQ = dispatch_queue_create("Cache Limit Process", NULL);

        dispatch_async(limitQ, ^{
            NSArray *cachedFiles = [weakSelf.fileManager contentsOfDirectoryAtURL:weakSelf.storageURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];


            if([cachedFiles count] > [weakSelf cacheLimit]){

                NSArray *sortedCachedFiles = [cachedFiles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){

                    if([obj1 isKindOfClass:[NSURL class]] && [obj2 isKindOfClass:[NSURL class]]){
                        NSDictionary *obj1Attr = [weakSelf.fileManager attributesOfItemAtPath:((NSURL *)obj1).path error:&error];
                        NSDictionary *obj2Attr = [weakSelf.fileManager attributesOfItemAtPath:((NSURL *)obj2).path error:&error];

                        return [[obj2Attr objectForKey:NSFileModificationDate] compare:[obj1Attr objectForKey:NSFileModificationDate]];
                    }

                    return NSOrderedSame;

                }];

                for(int i = [sortedCachedFiles count] - 1; i >= [self cacheLimit]; i--){
                    [self.fileManager removeItemAtURL:[sortedCachedFiles objectAtIndex:i] error:&error];
                }



                if(error){
                    NSLog(@"Error: %@", error);
                }else{
                    NSLog(@"Cleaned Cache too");
                }
                
            }
            
        });
        
        return YES;
    }
    NSLog(@"Failed to saved to Cache");
    return NO;

}

- (NSData *)getFileFromCache
{
    return [self.fileManager contentsAtPath:self.fileURL.path];
}


#pragma mark - NSFileManager Delegate

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error
                                                        copyingItemAtURL:(NSURL *)srcURL
                                                                   toURL:(NSURL *)dstURL
{
    return NO;
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error
                                                       removingItemAtURL:(NSURL *)URL
{
    return NO;
}

@end
