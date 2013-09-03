//
//  AttributedStringViewController.m
//  Shutterbug
//
//  Created by Majid Mvulle on 8/9/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "AttributedStringViewController.h"

@interface AttributedStringViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AttributedStringViewController

-(void)setText:(NSAttributedString *)text
{
    _text = text;
    self.textView.attributedText = text;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.attributedText = self.text;
}

@end
