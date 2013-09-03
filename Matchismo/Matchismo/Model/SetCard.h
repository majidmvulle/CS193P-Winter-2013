//
//  SetCard.h
//  Matchismo
//
//  Created by Majid Mvulle on 7/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card

@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic) NSUInteger numberOfCharacters;


+ (NSUInteger) minNumberOfCharacters;  //min number of characters in Card
+ (NSUInteger) maxNumberOfCharacters;  //max number of characters in Card
+ (NSArray *)validShapes; //of Shapes
+ (NSArray *)validColors; //of Colors
+ (NSArray *)validShadings; //of Shadings

@end
