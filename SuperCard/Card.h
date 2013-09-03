//
//  Card.h
//  Matchismo
//
//  Created by Majid Mvulle on 6/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;
@property (nonatomic, strong)NSMutableDictionary *matchResults;


-(int)match:(NSArray *)otherCards;

@end
