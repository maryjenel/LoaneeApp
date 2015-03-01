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
#define kBaseURL @"https://loanee.firebaseio.com/user"


@interface FriendsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property VENUser * currentUser;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSWRevealVC];
    self.currentUser = [Venmo sharedInstance].session.user;
    [self requestFriendsFromVenmo];

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

            [dictionaryWithoutUser removeObjectForKey:@"userName"];
            [friendRef setValue:dictionaryWithoutUser];
        }

    }];
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
