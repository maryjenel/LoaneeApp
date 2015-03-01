//
//  InviteFriendsViewController.m
//  Loanee
//
//  Created by Mary Jenel Myers on 2/28/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "SWRevealViewController.h"
@interface InviteFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton setTarget: self.revealViewController];
        [self.menuButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
