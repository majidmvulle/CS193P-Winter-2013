//
//  PlayingCard.m
//  Matchismo
//
//  Created by Majid Mvulle on 6/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard


- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int numberOfSuits = 0;
    int numberOfRanks = 0;
    

    
    if([otherCards count] == 1){
        PlayingCard *otherCard = [otherCards lastObject];
        if([otherCard.suit isEqualToString:self.suit]){
            score = 1;
            numberOfSuits++;
        }else if(otherCard.rank == self.rank){
            score = 4;
            numberOfRanks++;
        }
        
        NSArray *ranks = [PlayingCard rankStrings];
        NSArray *details = @[[NSString stringWithFormat:@"%@%@",ranks[self.rank], self.suit],
                             [NSString stringWithFormat:@"%@%@",ranks[otherCard.rank], otherCard.suit]];
        
        
        self.matchResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             details, @"details",
                             [NSNumber numberWithInt:0], @"bonus", nil]; //set flip details
    }
    
    
    return score;
}
- (NSString *)contents
{
    NSArray *rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; //because we provide getter AND setter

+ (NSArray *)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}
- (void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ?: @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count-1; //max array index
}

- (void)setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}





@end
