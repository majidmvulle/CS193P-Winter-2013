//
//  AttributesViewController.m
//  Attributes
//
//  Created by Majid Mvulle on 7/10/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "AttributesViewController.h"

@interface AttributesViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *selectedWordStepper;
@property (weak, nonatomic) IBOutlet UILabel *selectedWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation AttributesViewController


- (NSArray *)wordList
{
    NSArray *wordList = [[self.label.attributedText string] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    if([wordList count]){
        return wordList;
    }else{
        return @[@""];
    }
    
}


- (NSString *)selectedWord
{
    return [self wordList][(int)self.selectedWordStepper.value];
}


- (IBAction)updateSelectedWord {
    self.selectedWordStepper.maximumValue = [[self wordList] count] - 1;
    self.selectedWordLabel.text = [self selectedWord];
}


- (void)addLabelAttributes:(NSDictionary *)attributes range:(NSRange)range
{
    
    if(range.location != NSNotFound){
        NSMutableAttributedString *mutableAttributedString = [self.label.attributedText mutableCopy];
        [mutableAttributedString addAttributes:attributes
                                         range:range];
        
        self.label.attributedText = mutableAttributedString;
    }
}

- (void)addSelectedWordAttributes:(NSDictionary *)attributes
   {
   NSRange range = [[self.label.attributedText string] rangeOfString:[self selectedWord]];
   
   [self addLabelAttributes:attributes range:range];

   }

- (IBAction)underline {
    
    [self addSelectedWordAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
}
- (IBAction)ununderline {
        [self addSelectedWordAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}];
}
- (IBAction)outline {
    
    [self addSelectedWordAttributes:@{NSStrokeWidthAttributeName:@(1), NSStrokeColorAttributeName:[UIColor redColor]}];
}
- (IBAction)unoutline {
    [self addSelectedWordAttributes:@{NSStrokeWidthAttributeName:@(0)}];
}


- (IBAction)changeColor:(UIButton *)sender {
    [self addSelectedWordAttributes:@{NSForegroundColorAttributeName:sender.backgroundColor}];
}

- (IBAction)changeFont:(UIButton *)sender {
    CGFloat fontSize = [UIFont systemFontSize];
    
    NSDictionary *attributes = [self.label.attributedText
                                attributesAtIndex:0 effectiveRange:NULL];
    UIFont *existingFont = attributes[NSFontAttributeName];
    
    if(existingFont) fontSize = existingFont.pointSize;
    
    UIFont *font = [sender.titleLabel.font fontWithSize:fontSize];
    
    [self addSelectedWordAttributes:@{NSFontAttributeName:font}];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self updateSelectedWord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
