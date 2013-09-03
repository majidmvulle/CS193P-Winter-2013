//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Majid Mvulle on 8/7/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonTitle;
@property (strong, nonatomic) UIPopoverController *urlPopover;

@end

@implementation ImageViewController

#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"Show URL"]){
        return (self.imageURL && !self.urlPopover.popoverVisible) ? YES : NO;
    }else{
      return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Show URL"]){
        if([segue.destinationViewController isKindOfClass:[AttributedStringViewController class]]){
            AttributedStringViewController *asvc = (AttributedStringViewController *)segue.destinationViewController;
            asvc.text = [[NSAttributedString alloc] initWithString:[self.imageURL description]];
            if([segue isKindOfClass:[UIStoryboardPopoverSegue class]]){
                self.urlPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
            }
        }
    }
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.barButtonTitle.title = title;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];

}


-(UIImageView *)imageView
{
    if(!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];

    return _imageView;
}

- (void)resetImage
{
    if(self.scrollView){
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;

        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];

        if(image){
            self.scrollView.zoomScale = 1.0; //Normal zoom
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);

        }

    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
    [self resetImage];
    self.barButtonTitle.title = self.title;
}
@end
