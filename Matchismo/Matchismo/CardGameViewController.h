//
//  GameViewController.h
//  Matchismo
//
//  Created by Majid Mvulle on 7/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "GameResult.h"
#import "Deck.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic) int flipMode; //abstract
@property (nonatomic) NSUInteger startingCardCount; //abstract
- (void)updateUI;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)clearDeck;//abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate; //abstract
- (void)deleteCardAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) Deck *deck;//abstract
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic)UICollectionViewCell *selectedCell;

@end
