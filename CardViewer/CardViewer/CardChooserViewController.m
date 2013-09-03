//
//  CardChooserViewController.m
//  CardViewer
//
//  Created by Majid Mvulle on 8/6/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "CardChooserViewController.h"
#import "CardDisplayViewController.h"

@interface CardChooserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *suitSegmentedControl;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@end

@implementation CardChooserViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowCard"]){
        if([segue.destinationViewController isKindOfClass:[CardDisplayViewController class]]){
            CardDisplayViewController *cdvc = (CardDisplayViewController *)segue.destinationViewController;
            cdvc.suit = self.suit;
            cdvc.rank = self.rank;
        }
    }
}
- (void)setRankLabel:(UILabel *)rankLabel
{
    _rankLabel = rankLabel;
}
- (IBAction)rankSlider:(UISlider *)sender {
    self.rank = round(sender.value);
    self.rankLabel.text = [NSString stringWithFormat:@"%d",self.rank];
}

- (NSString *)suit
{
    _suit = [self.suitSegmentedControl titleForSegmentAtIndex:self.suitSegmentedControl.selectedSegmentIndex];
    return _suit;
}

@end
