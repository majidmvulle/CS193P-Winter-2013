//
//  SetCard.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

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
    return @[@"▲",@"■", @"●"];
}

+ (NSUInteger)minNumberOfCharacters
{
    return 1;
}

+ (NSUInteger)maxNumberOfCharacters
{
    return 3;
}

+ (NSArray *)validColors{
    return @[@"red", @"blue", @"green"];
}

+ (NSArray *)validShadings
{
    return @[@"full", @"empty", @"shaded"];
}

- (NSString *)contents{
    NSString *content = @"";
    
    for(int i = 0; i < (int)self.numberOfCharacters; i++){
        content = [content stringByAppendingString:self.shape];
    }
    
    return content;
}

@end
