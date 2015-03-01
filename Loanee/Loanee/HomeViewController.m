//
//  ViewController.m
//  Loanee
//
//  Created by Mary Jenel Myers on 2/28/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <Firebase/Firebase.h>

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property VENUser * currentUser;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareSWRevealVC];
    self.currentUser = [Venmo sharedInstance].session.user;
    [self loadUIElementsWithUserData];

}

-(void)loadUIElementsWithUserData
{
    NSURL * url = [NSURL URLWithString:self.currentUser.profileImageUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage * profilePicture = [UIImage imageWithData:data];
        self.imageView.image = profilePicture;
    }];
    self.userNameLabel.text = self.currentUser.username;
}

-(void)prepareSWRevealVC
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

@end
