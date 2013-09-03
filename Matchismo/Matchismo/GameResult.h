//
//  GameResult.h
//  Matchismo
//
//  Created by Majid Mvulle on 7/15/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject
@property (readonly, nonatomic)NSDate *start;
@property (readonly, nonatomic)NSDate *end;
@property (nonatomic, readonly)NSTimeInterval duration;
@property (nonatomic)int score;
+ (NSMutableArray *)allGameResults;
- (NSComparisonResult)compareByScore:(GameResult *)otherGameResult;
- (NSComparisonResult)compareByDate:(GameResult *)otherGameResult;
- (NSComparisonResult)compareByDuration:(GameResult *)otherGameResult;

@end

