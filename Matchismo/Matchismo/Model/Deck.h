//
//  Deck.h
//  Matchismo
//
//  Created by Majid Mvulle on 6/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;
- (int)numberOfCardsInDeck;

@end
