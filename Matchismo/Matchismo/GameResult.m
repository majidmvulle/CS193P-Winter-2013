//
//  GameResult.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/15/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (nonatomic, readwrite)NSDate *start;
@property (nonatomic, readwrite)NSDate *end;
@end

@implementation GameResult

- (NSComparisonResult)compareByScore:(GameResult *)otherGameResult{
    return [@(self.score) compare:@(otherGameResult.score)];
}

- (NSComparisonResult)compareByDate:(GameResult *)otherGameResult{
    return [self.end compare:otherGameResult.end];
}

- (NSComparisonResult)compareByDuration:(GameResult *)otherGameResult{
    return [@(self.duration) compare:@(otherGameResult.duration)];
}

- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY ] mutableCopy];
    
    if(!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc]init];
    
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
   
    [[NSUserDefaults standardUserDefaults]synchronize];
}
                                       
- (id)asPropertyList
{
    return @{START_KEY:self.start, END_KEY:self.end, SCORE_KEY:@(self.score)};
}

+(NSMutableArray *)allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc]init];
    
    for(id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]){
        GameResult *gameResult = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:gameResult];
    }
    
    return allGameResults;
}

    //convenience initializer
- (id)initFromPropertyList:(id)plist
{
    self = [self init]; //call self designated initializer, not super's
    
    if(self){
        if([plist isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *resultDictionary = (NSDictionary *)plist; //casting not necessary, used to communicate to other programmers
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            
            if(!_start || !_end) self = nil;
        }
    }
    
    return self;
}

    //designated initializer
- (id)init
{
    self = [super init];
    
    if(self){
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}
@end
