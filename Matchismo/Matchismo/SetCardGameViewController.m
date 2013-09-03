//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardCollectionViewCell.h"
#import "SetCard.h"

@implementation SetCardGameViewController

@synthesize deck = _deck;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
}

- (Deck *)deck
{
    if(!_deck) _deck =[[SetCardDeck alloc] init];

    return _deck;
}

- (void)clearDeck
{
    self.deck = nil;
}

- (NSUInteger)startingCardCount
{
    return 12;
}

- (int)flipMode
{
    return 2;
}

- (void)updateCell:(UICollectionViewCell *)cell
         usingCard:(Card *)card
           animate:(BOOL)animate
{
    if([cell isKindOfClass:[SetCardCollectionViewCell class]]){
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if([card isKindOfClass:[SetCard class]]){
            SetCard *setCard = (SetCard *)card;
            setCardView.color = setCard.color;
            setCardView.shape = setCard.shape;
            setCardView.shading  = setCard.shading;
            setCardView.numberOfCharacters = setCard.numberOfCharacters;
            setCardView.faceUp = setCard.faceUp;
            setCardView.backgroundColor = setCard.faceUp ? [UIColor lightGrayColor] : [UIColor whiteColor];

            if(setCard.isUnplayable){
                NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
                [super deleteCardAtIndexPath:indexPath];
            }

        }

    }

}


@end
