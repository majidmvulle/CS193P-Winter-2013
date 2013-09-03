//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Majid Mvulle on 8/7/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"
#import "SpotCache.h"
#import "FlickrFetcher.h"

@interface ImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *photoTitle;
@property (nonatomic, strong) NSString *photoID;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonTitle;
@property (strong, nonatomic) UIPopoverController *urlPopover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@end

@implementation ImageViewController

- (void)setupPhoto:(NSDictionary *)photo
{

    BOOL isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO;

    self.imageURL = photo[isPad ? PAD_IMAGE_URL : PHONE_IMAGE_URL];
    self.photoID = photo[PHOTO_ID];
    self.photoTitle = photo[PHOTO_TITLE];

}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.barButtonItem = barButtonItem;
    [_navBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
}


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

- (void)setPhotoTitle:(NSString *)photoTitle
{
    _photoTitle = photoTitle;
    _navBar.topItem.title = photoTitle;
    self.title = photoTitle;
}

- (void)setImageURL:(NSURL *)imageURL
{
    
    _imageURL = imageURL;
    [self resetImage];

}


- (UIImageView *)imageView
{
    if(!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];

    return _imageView;
}

- (NSData *)imageData
{
    NSData *imageData = nil;

        SpotCache *cache = [[SpotCache alloc] initWithFileName:self.photoID];

        if([cache isFileExists]){
            imageData = [cache getFileFromCache];
            NSLog(@"File exists in Cache");

        }

        if(!imageData){
            imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                //save to cache
            dispatch_queue_t cacheQ = dispatch_queue_create("Cache Save", NULL);

            dispatch_async(cacheQ, ^{
                [cache saveFileToCacheWithData:imageData];
            });

        }
    

    return imageData;
}

- (void)resetImage
{
    self.spinner.hidesWhenStopped = YES;

    if(self.scrollView && self.imageURL && self.photoID){
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;

        dispatch_queue_t imageQ = dispatch_queue_create("Image Downloader", NULL);

        [self.spinner startAnimating];
        dispatch_async(imageQ, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

            NSData *data = [self imageData];
            UIImage *image = [[UIImage alloc] initWithData:data];

            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                if(image){
                    self.scrollView.zoomScale = 1.0; //Normal zoom
                    self.scrollView.contentSize = image.size;
                    self.imageView.image = image;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);

                }

                [self.spinner stopAnimating];
            });
            
            
        });

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
    self.title = self.photoTitle;
    self.navBar.topItem.title = self.photoTitle;
    [self.navBar.topItem setLeftBarButtonItem:self.barButtonItem animated:YES];

}

@end
