//
//  CardDisplayViewController.m
//  CardViewer
//
//  Created by Majid Mvulle on 8/6/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "CardDisplayViewController.h"
#import "PlayingCardView.h"

@interface CardDisplayViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end

@implementation CardDisplayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.playingCardView.suit = self.suit;
    self.playingCardView.rank = self.rank;
    self.playingCardView.faceUp = YES;
    self.title = [[self rankAsString][self.rank] stringByAppendingString:self.suit];

}

- (NSArray *)rankAsString
{

  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];

}


@end
