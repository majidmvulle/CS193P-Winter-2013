//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Majid Mvulle on 7/21/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic)NSUInteger rank;
@property (nonatomic, strong) NSString *suit;

@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
@end
