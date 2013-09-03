//
//  Card.m
//  Matchismo
//
//  Created by Majid Mvulle on 6/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSMutableDictionary *)matchResults
{
    if(!_matchResults)
        _matchResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithBool:NO],@"match",
                         [NSNumber numberWithBool:NO],@"mismatch",
                         @[], @"details",
                         [NSNumber numberWithInt:0], @"bonus",
                         [NSNumber numberWithInt:0], @"flipcost",  nil];
    
    return _matchResults;
}

-(int)match:(NSArray *)otherCards{
    int score = 0;
    
    for(Card *card in otherCards){
        if([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    
    return score;
}



@end
