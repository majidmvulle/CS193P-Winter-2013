//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Majid Mvulle on 7/15/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) NSMutableArray *gameResults; //of GameResults
@end

@implementation GameResultViewController


- (NSMutableArray *)gameResults
{
    if(!_gameResults) _gameResults = [GameResult allGameResults];
    return _gameResults;
}

- (IBAction)sort:(UIButton *)sender {
    switch (sender.tag) {
        case 1: //score
            [self.gameResults sortUsingSelector:@selector(compareByScore:)];
            break;
        case 2: //date
            [self.gameResults sortUsingSelector:@selector(compareByDate:)];
            break;
        case 3: //duration
            [self.gameResults sortUsingSelector:@selector(compareByDuration:)];
            break;            
        default:
            break;
    }
    
    [self updateUI];
    
}

- (void)updateUI
{
    NSString *displayText = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
    NSString *dateString = @"";
    
    for(GameResult *result in self.gameResults){
        
            dateString = [dateFormatter stringFromDate:result.end];
        
        displayText = [displayText stringByAppendingFormat:@"Score: %d (%@, %0g)\n",result.score, dateString, round(result.duration)];
    }
    
    self.display.text = displayText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.gameResults = nil; //reset local array
    [self updateUI];
}

- (void)setup
{
        //initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
