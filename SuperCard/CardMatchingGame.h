//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Majid Mvulle on 6/26/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *scoreText;

    //designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck;

- (Card *)cardAtIndex:(NSUInteger)index;
- (void)flipCardAtIndex:(NSUInteger)index;

@end
