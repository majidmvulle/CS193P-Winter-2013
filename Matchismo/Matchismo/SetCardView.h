//
//  SetCardView.h
//  Matchismo
//
//  Created by Majid Mvulle on 7/28/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView
@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *shading;

@property (nonatomic) BOOL faceUp;

@property (nonatomic) NSUInteger numberOfCharacters;
@end
