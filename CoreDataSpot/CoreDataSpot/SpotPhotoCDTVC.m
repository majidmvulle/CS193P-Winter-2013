//
//  SpotPhotoCDTVC.m
//  CoreDataSpot
//
//  Created by Majid Mvulle on 8/20/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SpotPhotoCDTVC.h"
#import "SpotPhotoCell.h"
#import "Photo.h"

@interface SpotPhotoCDTVC ()
@property (nonatomic, readwrite) CGFloat cellHeight;

@end

@implementation SpotPhotoCDTVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath && [segue.identifier isEqualToString:@"setupPhoto:"]){
            if([segue.destinationViewController respondsToSelector:@selector(setupPhoto:)]){
                Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];

                NSDictionary *photoDetails = [NSDictionary dictionaryWithObjects:@[[NSURL URLWithString:photo.padImageURL],
                                              [NSURL URLWithString:photo.phoneImageURL],
                                              photo.unique, photo.title]
                                                                         forKeys:@[PAD_IMAGE_URL,
                                              PHONE_IMAGE_URL,
                                              PHOTO_ID, PHOTO_TITLE]];

                [segue.destinationViewController performSelector:@selector(setupPhoto:) withObject:photoDetails];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"photocell"];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"setupPhoto:" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (CGFloat)cellHeight
{
    if(!_cellHeight){
        SpotPhotoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"photocell"];
        _cellHeight = cell.bounds.size.height;
    }

    return _cellHeight;
}




@end
