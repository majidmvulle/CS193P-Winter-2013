//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if(self) {//not nil        
        for(NSString *shape in [SetCard validShapes]){
            for(NSString *color in [SetCard validColors]){
                for(NSString *shading in [SetCard validShadings]){
                    for(NSUInteger numberOfCharacters = [SetCard minNumberOfCharacters]; numberOfCharacters <= [SetCard maxNumberOfCharacters]; numberOfCharacters++){
                        SetCard *setCard = [[SetCard alloc] init];
                        setCard.shape = shape;
                        setCard.color = color;
                        setCard.shading = shading;
                        setCard.numberOfCharacters = numberOfCharacters;
                        
                        [self addCard:setCard atTop:YES];
                    }
                }
            }

        }
    }
    return self;
}

@end
