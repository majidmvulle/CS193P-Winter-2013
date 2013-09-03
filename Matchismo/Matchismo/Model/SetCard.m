//
//  SetCard.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#define NUMBER_OF_CARDS_TO_BE_MATCHED_IN_A_SET 2
#define MIN_NUMBER_OF_CHARACTERS 1
#define MAX_NUMBER_OF_CHARACTERS 3

- (int)match:(NSArray *)otherCards
{

    int score = 0;

    int sameColors = 0;
    int sameShapes = 0;
    int sameShadings = 0;
    int sameNumberOfCharacters = 0;


    if([otherCards count] ==  NUMBER_OF_CARDS_TO_BE_MATCHED_IN_A_SET){
        if([otherCards[0] isKindOfClass:[SetCard class]] && [otherCards[1] isKindOfClass:[SetCard class]]){
            SetCard *firstCard = otherCards[0];
            SetCard *secondCard = otherCards[1];

                //Colors
            if([firstCard.color isEqualToString:self.color])
                sameColors++;
            if([firstCard.color isEqualToString:secondCard.color])
                sameColors++;
            if([secondCard.color isEqualToString:self.color])
                sameColors++;

                //Shadings
            if([firstCard.shading isEqualToString:self.shading])
                sameShadings++;
            if([firstCard.shading isEqualToString:secondCard.shading])
                sameShadings++;
            if([secondCard.shading isEqualToString:self.shading])
                sameShadings++;

                //Shapes
            if([firstCard.shape isEqualToString:self.shape])
                sameShapes++;
            if([firstCard.shape isEqualToString:secondCard.shape])
                sameShapes++;
            if([secondCard.shape isEqualToString:self.shape])
                sameShapes++;

                //Number of characters
            if(firstCard.numberOfCharacters == self.numberOfCharacters)
                sameNumberOfCharacters++;
            if(firstCard.numberOfCharacters == secondCard.numberOfCharacters)
                sameNumberOfCharacters++;
            if(secondCard.numberOfCharacters == self.numberOfCharacters)
                sameNumberOfCharacters++;

        }

        NSDictionary *aDictionary = [[NSDictionary alloc] initWithObjects:@[@(sameColors),
                                     @(sameShapes),
                                     @(sameShadings),
                                     @(sameNumberOfCharacters)]
                                                                  forKeys:@[@"sameColors",
                                     @"sameShapes",
                                     @"sameShadings",
                                     @"sameNumberOfCharacters"]];

            //        Magic Rule: If two are....and one isn't. NO MATCH

        if([self matchingPassed:aDictionary]){ //Magic Rule

            if([self matchedByColors:aDictionary]
               || [self matchedByShadings:aDictionary]
               || [self matchedByShapes:aDictionary]
               || [self matchedByNumberOfCharacters:aDictionary])
                score = 3;
            else if([self matchedAllOrNotMatchedAll:aDictionary])
                score = 8;
        }

    }

    return score;
}

- (BOOL)matchingPassed:(NSDictionary *)aDictionary
{

    int sameColors = [[aDictionary objectForKey:@"sameColors"] intValue];
    int sameShapes = [[aDictionary objectForKey:@"sameShapes"] intValue];
    int sameShadings = [[aDictionary objectForKey:@"sameShadings"] intValue];
    int sameNumberOfCharacters = [[aDictionary objectForKey:@"sameNumberOfCharacters"] intValue];

    if(sameColors == 1 || sameShapes == 1 || sameShadings == 1 || sameNumberOfCharacters == 1)
        return NO;

    return YES;
}

- (BOOL)matchedAllOrNotMatchedAll:(NSDictionary *)aDictionary
{
    int sameColors = [[aDictionary objectForKey:@"sameColors"] intValue];
    int sameShapes = [[aDictionary objectForKey:@"sameShapes"] intValue];
    int sameShadings = [[aDictionary objectForKey:@"sameShadings"] intValue];
    int sameNumberOfCharacters = [[aDictionary objectForKey:@"sameNumberOfCharacters"] intValue];

    if((sameColors == 3 && sameShapes == 3 && sameShadings == 3 && sameNumberOfCharacters == 3)
       || (sameColors == 0 && sameShapes == 0 && sameShadings == 0 && sameNumberOfCharacters == 0))
        return YES;

    return NO;
}

- (BOOL)matchedByColors:(NSDictionary *)aDictionary
{
    if([[aDictionary objectForKey:@"sameColors"] intValue] == 3)
        return YES;

    return NO;
}

- (BOOL)matchedByShapes:(NSDictionary *)aDictionary
{
    if([[aDictionary objectForKey:@"sameShapes"] intValue] == 3)
        return YES;

    return NO;
}

- (BOOL)matchedByShadings:(NSDictionary *)aDictionary
{
    if([[aDictionary objectForKey:@"sameShadings"] intValue] == 3)
        return YES;

    return NO;
}

- (BOOL)matchedByNumberOfCharacters:(NSDictionary *)aDictionary
{

    if([[aDictionary objectForKey:@"sameNumberOfCharacters"] intValue] == 2)
        return YES;
    
    return NO;
}


- (void)setShape:(NSString *)shape
{
    if([[SetCard validShapes] containsObject:shape]){
        _shape = shape;
    }
}

- (void)setColor:(NSString *)color
{
    if([[SetCard validColors] containsObject:color]){
        _color = color;
    }
}

- (void)setShading:(NSString *)shading
{
    if([[SetCard validShadings] containsObject:shading]){
        _shading = shading;
    }
}

- (void)setNumberOfCharacters:(NSUInteger)numberOfCharacters
{
    if(numberOfCharacters > [SetCard maxNumberOfCharacters]){
        _numberOfCharacters = [SetCard maxNumberOfCharacters];
    }else if(numberOfCharacters < [SetCard minNumberOfCharacters]){
        _numberOfCharacters = [SetCard minNumberOfCharacters];
    }else{
        _numberOfCharacters = numberOfCharacters;
    }
}


+ (NSArray *)validShapes{
    return @[FIRST_SHAPE,SECOND_SHAPE, THIRD_SHAPE];
}

+ (NSUInteger)minNumberOfCharacters
{
    return MIN_NUMBER_OF_CHARACTERS;
}

+ (NSUInteger)maxNumberOfCharacters
{
    return MAX_NUMBER_OF_CHARACTERS;
}

+ (NSArray *)validColors{
    return @[FIRST_COLOR, SECOND_COLOR, THIRD_COLOR];
}

+ (NSArray *)validShadings
{
    return @[FIRST_SHADING,SECOND_SHADING, THIRD_SHADING];
}

- (NSString *)contents{
    NSString *aContent = @"";
    
    for(int i = 0; i < (int)self.numberOfCharacters; i++){
        aContent = [aContent stringByAppendingString:self.shape];
    }

    return aContent;
}

@end
