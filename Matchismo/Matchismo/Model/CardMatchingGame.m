//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Majid Mvulle on 6/26/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSMutableAttributedString *scoreText;
@property (strong, nonatomic)NSMutableArray *cards;//of Card
@end

@implementation CardMatchingGame

#define ADDITIONAL_CARDS 3


- (int)numberOfCards
{
    return [self.cards count];
}

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    NSMutableArray *faceUpCards = [NSMutableArray array];
    
    Card *card = [self cardAtIndex:index];
    
    [card.matchResults removeAllObjects]; //reset the dictionary
    [card.matchResults setObject:[NSNumber numberWithBool:NO] forKey:@"match"];
    [card.matchResults setObject:[NSNumber numberWithBool:NO] forKey:@"mismatch"];

    if(card && !card.isUnplayable){
        
        if(!card.isFaceUp){
                //START
            for(Card *someOtherCard in self.cards){
                
                if(someOtherCard.isFaceUp
                   && !someOtherCard.isUnplayable
                   && someOtherCard != card){
                    [faceUpCards addObject:someOtherCard];
                }
            }

            if([faceUpCards count] == self.flipMode){ //We found some faced up cards

                int matchScore = [card match:faceUpCards];

                NSMutableArray *aMutableArray = [NSMutableArray array];
                [aMutableArray addObject:card.contents];

                if(matchScore){
                    card.unplayable = YES;
                    
                    for(Card *someOtherCard in faceUpCards){
                        someOtherCard.unplayable = YES;
                        [aMutableArray addObject:someOtherCard.contents];
                    }

                    self.score += MATCH_BONUS;

                    [card.matchResults setObject:aMutableArray forKey:@"details"];
                    [card.matchResults setObject:[NSNumber numberWithInt:MATCH_BONUS] forKey:@"bonus"];
                    [card.matchResults setObject:[NSNumber numberWithBool:YES] forKey:@"match"];

                }else{
                    card.faceUp = NO;
                    
                    for(Card *someOtherCard in faceUpCards){
                        someOtherCard.faceUp = NO;
                        [aMutableArray addObject:someOtherCard.contents];
                    }

                    self.score -= MISMATCH_PENALTY;

                    [card.matchResults setObject:aMutableArray forKey:@"details"];
                    [card.matchResults setObject:[NSNumber numberWithInt:MISMATCH_PENALTY] forKey:@"bonus"];
                    [card.matchResults setObject:[NSNumber numberWithBool:YES] forKey:@"mismatch"];

                }
                
                    ///END
            }

            self.score -= FLIP_COST;

            [card.matchResults setObject:[NSNumber numberWithInt:FLIP_COST] forKey:@"flipcost"];

        }
        [self populateResultsDetailsForCard:card];
        card.faceUp = !card.faceUp;

    }  //End if

}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
{
    self = [super init]; //always call the super's designated initializer
    
    if(self){
        
        for(int i = 0; i<cardCount; i++){
            Card *card = [deck drawRandomCard];
            
            if(card){ 
                self.cards[i] = card;
                
            }else{  //if we have run out cards
                self = nil;
                break;
                
            }
                
        }
        
    }
    
    return self;
}

- (NSIndexPath *)drawCardFromDeck:(Deck *)deck
{
    Card *card = [deck drawRandomCard];
    if(!card) return nil;

    [self.cards addObject:card];

    return [NSIndexPath indexPathForItem:[self.cards count]-1 inSection:0]; //important
}

- (void)deleteCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}



- (void)populateResultsDetailsForCard:(Card *)card
{

//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
//
//    if([card.matchResults count] != 0){
//
//        if([self matched:card]){
//            [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:@"Matched "]];
//
//            int counter = 0;
//            if([[card.matchResults objectForKey:@"details"] isKindOfClass:[NSArray class]]){
//                for(id content in [card.matchResults objectForKey:@"details"]){
//                    if([content isKindOfClass:[NSAttributedString class]]){
//                        [attributedString appendAttributedString:content];
//                        counter++;
//
//
//                        if(counter != [[card.matchResults objectForKey:@"details"] count]){
//                            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" & "]];
//                        }
//
//
//                    }
//                }
//            }
//            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:
//                                                      [NSString stringWithFormat:@" for %@ points!", [card.matchResults objectForKey:@"bonus"]]]];            
//        }
//        else if([self mismatched:card]){
//
//            if([[card.matchResults objectForKey:@"details"] isKindOfClass:[NSArray class]]){
//                int counter = 0;
//                for(id content in [card.matchResults objectForKey:@"details"]){
//                    if([content isKindOfClass:[NSAttributedString class]]){
//                        [attributedString appendAttributedString:content];
//                        counter++;
//
//                        if(counter != [[card.matchResults objectForKey:@"details"] count]){
//                            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" & "]];
//                        }
//
//                    }
//                }
//            }
//            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:
//                                                      [NSString stringWithFormat:@" don't match (-%@) points penalty!", [card.matchResults objectForKey:@"bonus"]]]];
//
//        }else{
//            if(!card.faceUp){
//                [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:@"Flipped up "]];
//                [attributedString appendAttributedString:card.contents];
//
//            }else{
//                [attributedString appendAttributedString:[[NSAttributedString alloc]initWithString:@"Flipped down!"]];
//            }
//        }
//    }
//    self.scoreText = attributedString;
}

- (BOOL)matched:(Card *)card
{

    if([card.matchResults objectForKey:@"match"] != Nil
       && [[card.matchResults objectForKey:@"match"] boolValue])
        return YES;

    return NO;
}

- (BOOL)mismatched:(Card *)card
{
    if([card.matchResults objectForKey:@"mismatch"] != Nil
       && [[card.matchResults objectForKey:@"mismatch"] boolValue])
        return YES;
    return NO;
}










@end
