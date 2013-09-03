//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Majid Mvulle on 6/25/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) UIImage *cardImage;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreDescription;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) NSUInteger currentCardButtonIndex;
@end

@implementation PlayingCardViewController

- (GameResult *)gameResult
{
    if(!_gameResult) _gameResult = [[GameResult alloc]init];
    
    return _gameResult;
}

- (CardMatchingGame *)game
{    
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                        usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


- (IBAction)flipCard:(UIButton *)sender
{
    NSUInteger index = 0;

    [self.game flipCardAtIndex:index];

    self.currentCardButtonIndex = index;

    self.scoreDescription.attributedText = self.game.scoreText;
    self.flipCount++;
    self.gameResult.score = self.game.score;

    [self updateUI];
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    [self setCardImage:[UIImage imageNamed:@"Angel-Back-Squeezers-Red.jpg" ]];
    _cardButtons = cardButtons;
    
    [self updateUI];

}

- (void)updateUI
{

    self.game.flipMode = NUMBER_OF_CARDS_TO_MATCH - 2;
    
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
        [self updateUI];
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.game.flipMode = NUMBER_OF_CARDS_TO_MATCH - 2;
}

@end
