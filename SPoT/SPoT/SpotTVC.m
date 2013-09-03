//
//  SpotTVC.m
//  SPoT
//
//  Created by Majid Mvulle on 8/9/13.
//  Copyright (c) 2013 Majid Mvulle. All rights reserved.
//

#import "SpotTVC.h"

@implementation SpotTVC

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (NSString *)titleForRow:(NSUInteger)row{ return nil; }//abstract

- (NSString *)subtitleForRow:(NSUInteger)row{ return nil; }//abstract


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self titleForRow:indexPath.item];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.item];
    
    return cell;
}

@end
