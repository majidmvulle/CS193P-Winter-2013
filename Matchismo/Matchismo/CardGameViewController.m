//
//  GameViewController.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) UIImage *cardImage;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreDescription;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int currentCardCount;
@end

@implementation CardGameViewController

#define CARDS_TO_ADD 3

- (IBAction)addCards:(id)sender
{
    NSMutableArray *indexPaths = [NSMutableArray array];

    for(int i = 0; i < CARDS_TO_ADD; i++){
        NSIndexPath *drawnCardIndexPath = [self.game drawCardFromDeck:self.deck];
        if(drawnCardIndexPath){
            [indexPaths addObject:drawnCardIndexPath];

        }
    }

    if([indexPaths count] != 0){
        [self.cardCollectionView performBatchUpdates:^{
            [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
            [self updateUI];

                //self.cardCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(1.0, 0, 1.0, 5.0);
        } completion:nil];

        [self.cardCollectionView scrollToItemAtIndexPath:[indexPaths lastObject]
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:YES];
    }

    if([indexPaths count] < CARDS_TO_ADD){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Out of Cards!"
                                                        message:[NSString stringWithFormat:@"No more Cards available. %d card(s) was/were added!", [indexPaths count]]
                                                       delegate:self
                                              cancelButtonTitle:@"Okay" otherButtonTitles:nil,nil];
        [alert show];
    }

}

- (void)deleteCardAtIndexPath:(NSIndexPath *)indexPath
{
    [self.game deleteCardAtIndex:indexPath.item];
    [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self updateUI];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.game numberOfCards];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    
    [self updateCell:cell usingCard:card animate:NO];
    return  cell;
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
        //abstract
}


- (GameResult *)gameResult
{
    if(!_gameResult) _gameResult = [[GameResult alloc] init];

    return _gameResult;
}


- (CardMatchingGame *)game
{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                         usingDeck:self.deck];

    return _game;
}


- (Deck *)deck{ return nil;} //abstract

- (void)clearDeck{} //abstract

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{

    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];

    self.selectedCell = [self.cardCollectionView cellForItemAtIndexPath:indexPath];

    if(indexPath){
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        [self updateUI];
        self.gameResult.score = self.game.score;
    }
    
}


- (IBAction)dealCheck {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?"
                                                   message:@"Deal - will reset the game to start."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Deal", nil];
    alert.tag = 1;
    [alert show];
    
}

- (void)updateUI
{
    for(UICollectionViewCell *cell in [self.cardCollectionView visibleCells]){
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES];
    }
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.scoreLabel.text  = [NSString stringWithFormat:@"Score: %d", self.game.score];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1){
        if(buttonIndex == [alertView cancelButtonIndex] + 1){
            self.game = nil;
            self.gameResult = nil;
            self.flipCount = 0;
            self.scoreDescription.text = @"";
            [self clearDeck];

            [self.cardCollectionView reloadData];
//            [self updateUI];
        }
    }
    
}

- (void)viewDidLoad
{
    self.game.flipMode = self.flipMode;
}



@end
