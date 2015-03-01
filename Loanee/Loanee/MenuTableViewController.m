//
//  MenuTableViewController.m
//  Loanee
//
//  Created by Mary Jenel Myers on 2/28/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()


@end

@implementation MenuTableViewController
{
    NSArray *menuItems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"home", @"inviteFriends", @"friends", @"pending", @"settings"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController *)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row]capitalizedString];

}





@end
