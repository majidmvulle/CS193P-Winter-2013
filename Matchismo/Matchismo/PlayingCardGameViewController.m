//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/28/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@implementation PlayingCardGameViewController

#define STARTING_CARD_COUNT 22
#define FLIP_MODE 1

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
}

- (Deck *)deck
{
    return [[PlayingCardDeck alloc] init];
    
}

- (NSUInteger)startingCardCount
{
    return STARTING_CARD_COUNT;
}

- (int)flipMode
{
    return FLIP_MODE;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{

    if([cell isKindOfClass:[PlayingCardCollectionViewCell class]]){
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if([card isKindOfClass:[PlayingCard class]]){
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;

            PlayingCardCollectionViewCell *myCell = (PlayingCardCollectionViewCell *)cell;

            if(animate && ((playingCardView.faceUp && !playingCard.faceUp)
                           || [self.cardCollectionView indexPathForCell:self.selectedCell].item == [self.cardCollectionView indexPathForCell:myCell].item)){
                [UIView transitionWithView:myCell.playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                    playingCardView.faceUp = playingCard.faceUp;

                }completion:NULL];
            }

            playingCardView.faceUp = playingCard.faceUp;

            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;

//            if(playingCard.isUnplayable){
//                NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
//                [super deleteCardAtIndexPath:indexPath];
//            }
        }
    }
    
}


@end
