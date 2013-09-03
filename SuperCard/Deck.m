//
//  Deck.m
//  Matchismo
//
//  Created by Majid Mvulle on 6/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "Deck.h"
@interface Deck()

@property (nonatomic, strong) NSMutableArray *cards; //Mutable array of cards

@end


@implementation Deck

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop{
    if(atTop){
        [self.cards insertObject:card atIndex:0]; //insert at top
    }else{
        [self.cards addObject:card];
    }
    
}

- (Card *)drawRandomCard{
    
    Card *randomCard = nil;
    
    if(self.cards.count){ //if not empty array
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index]; //Remove this card
    }
    
    return randomCard;
}

@end
