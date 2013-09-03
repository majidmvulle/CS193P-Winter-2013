//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Majid Mvulle on 6/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PlayingCardDeck.h"

@implementation PlayingCardDeck
- (id)init
{
    self = [super init];
    
    if(self) {//not nil
        for(NSString *suit in [PlayingCard validSuits]){
            for(NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++){
                PlayingCard *card = [[PlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                
                [self addCard:card atTop:YES];
            }
        }
    }
    return self;
}
@end
