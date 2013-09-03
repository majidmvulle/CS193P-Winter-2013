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
@property (nonatomic, readwrite) NSString *scoreText;
@property (strong, nonatomic)NSMutableArray *cards;//of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1


- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    [card.matchResults removeAllObjects]; //reset the dictionary
    [card.matchResults setObject:[NSNumber numberWithBool:NO] forKey:@"match"];
    [card.matchResults setObject:[NSNumber numberWithBool:NO] forKey:@"mismatch"];

    if(card && !card.isUnplayable){
        
        if(!card.isFaceUp){
            
            for(Card *otherCard in self.cards){
                
                if(otherCard.isFaceUp && !otherCard.isUnplayable){
                    
                    int matchScore = [card match:@[otherCard]];

                    if(matchScore){
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += MATCH_BONUS;
                        
                        [card.matchResults setObject:[NSNumber numberWithInt:MATCH_BONUS] forKey:@"bonus"];
                        [card.matchResults setObject:[NSNumber numberWithBool:YES] forKey:@"match"];
                        
                    }else{
                        
                        otherCard.faceUp = NO;
                        card.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        
                        [card.matchResults setObject:[NSNumber numberWithInt:MISMATCH_PENALTY] forKey:@"bonus"];
                        [card.matchResults setObject:[NSNumber numberWithBool:YES] forKey:@"mismatch"];
                        
                    }
                    
                    break; //get out of the loop
                }
            }
            self.score -= FLIP_COST;
            
            [card.matchResults setObject:[NSNumber numberWithInt:FLIP_COST] forKey:@"flipcost"];


        }
        card.faceUp = !card.faceUp;

    }
        
    self.scoreText = @"";
    
    if([card.matchResults count] != 0){
        
        if([card.matchResults objectForKey:@"match"] != Nil
           && [[card.matchResults objectForKey:@"match"] boolValue]){
            
            self.scoreText = @"Matched ";
            
            if([card.matchResults objectForKey:@"details"] != Nil
               && [[card.matchResults objectForKey:@"details"] count] > 0){
                self.scoreText = [self.scoreText stringByAppendingString:[[card.matchResults objectForKey:@"details"] componentsJoinedByString:@" & "]];
            }
            
            self.scoreText = [self.scoreText stringByAppendingFormat:@" for %@ points!", [card.matchResults objectForKey:@"bonus"]];
        }
        else if([card.matchResults objectForKey:@"mismatch"] != Nil
                && [[card.matchResults objectForKey:@"mismatch"] boolValue]){
            
            if([card.matchResults objectForKey:@"details"] != Nil
               && [[card.matchResults objectForKey:@"details"] count] > 0){
                self.scoreText = [[card.matchResults objectForKey:@"details"] componentsJoinedByString:@" & "];
            }
            self.scoreText = [self.scoreText stringByAppendingFormat:@" don't match %@ point penalty!", [card.matchResults objectForKey:@"bonus"]];
        }else{
            self.scoreText = [self.scoreText stringByAppendingFormat:@"Flipped up %@", card.contents];
        }
    }
    
    
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


@end
