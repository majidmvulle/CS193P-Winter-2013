//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Majid Mvulle on 7/28/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
