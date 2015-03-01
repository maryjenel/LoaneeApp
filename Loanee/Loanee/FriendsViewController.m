//
//  FriendsViewController.m
//  Loanee
//
//  Created by Mary Jenel Myers on 2/28/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "FriendsViewController.h"
#import "SWRevealViewController.h"
#import <Firebase/Firebase.h>
#import <Venmo-iOS-SDK/Venmo.h>
#import <SDWebImage/UIImageView+WebCache.h>
#define kBaseURL @"https://loanee.firebaseio.com/user"


@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property VENUser * currentUser;
@property (nonatomic)  NSMutableArray * friendsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsArray = [NSMutableArray new];
    [self prepareSWRevealVC];
    self.currentUser = [Venmo sharedInstance].session.user;
    [self requestFriendsFromVenmo];
    [self queryForFriendUserNameAndPicture];
}


-(void) queryForFriendUserNameAndPicture
{
    Firebase * ref = [[Firebase alloc] initWithUrl:kBaseURL];
    ref = [ref childByAppendingPath:[NSString stringWithFormat:@"%@/friends", [Venmo sharedInstance].session.user.username]];

    [[ref queryOrderedByKey]  observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
         NSLog(@"%@ was %@", snapshot.key, snapshot.value[@"profile_picture_url"]);
        [self.friendsArray addObject:@{snapshot.key : snapshot.value[@"profile_picture_url"]}];
        [self.tableView reloadData];
     }];

}

-(void)requestFriendsFromVenmo
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.venmo.com/v1/users/%@/friends?access_token=%@", self.currentUser.externalId, [Venmo sharedInstance].session.accessToken]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError * error;
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray * friends = json[@"data"];
        Firebase * ref = [[Firebase alloc] initWithUrl:kBaseURL];
        ref = [ref childByAppendingPath:[NSString stringWithFormat:@"%@/friends", [Venmo sharedInstance].session.user.username]];
        for (NSDictionary * friend in friends)
        {
            Firebase * friendRef = [ref childByAppendingPath:friend[@"username"]];
            NSMutableDictionary * dictionaryWithoutUser  = [[NSMutableDictionary alloc] initWithDictionary:friend];

            [dictionaryWithoutUser removeObjectForKey:@"username"];
            [friendRef setValue:dictionaryWithoutUser];
        }

    }];




}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * user = self.friendsArray[indexPath.row];
    for(id key in user)
    {
        cell.textLabel.text = [key description];
        [cell.imageView sd_setImageWithURL:user[key] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }


    return cell;
}

-(void)prepareSWRevealVC
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton setTarget: self.revealViewController];
        [self.menuButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

@end
