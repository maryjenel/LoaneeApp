//
//  LoggedOutViewController.m
//  Loanee
//
//  Created by Gustavo Couto on 2015-02-28.
//  Copyright (c) 2015 makr.space. All rights reserved.
//

#import "LoggedOutViewController.h"
#import <Firebase/Firebase.h>
#import <Venmo-iOS-SDK/Venmo.h>
#import "venmoUser.h"
#define kBaseURL @"https://loanee.firebaseio.com/user"

@interface LoggedOutViewController ()


@property FAuthData * currentUser;
@property VENUser * venUser;

@end

@implementation LoggedOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if ([[Venmo sharedInstance] isSessionValid]) {
//
//        [self presentLoggedInVC];
//    }
}

- (void)presentLoggedInVC {
   [self performSegueWithIdentifier:@"LoggedInVc" sender:self];
}

- (IBAction)logInButtonAction:(id)sender {
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile,
                                                 VENPermissionAccessFriends,
                                                 VENPermissionAccessEmail,
                                                 VENPermissionAccessBalance,
                                                 VENPermissionAccessPhone]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                 self.venUser = [Venmo sharedInstance].session.user;
                                 NSMutableDictionary * venUserDictionary = [[venmoUser toDictonary:self.venUser] mutableCopy];
                                 Firebase * ref = [[Firebase alloc] initWithUrl:kBaseURL];
                                 ref = [ref childByAppendingPath:[Venmo sharedInstance].session.user.username];

                                 [ref setValue:venUserDictionary withCompletionBlock:^(NSError *error, Firebase *ref) {
                                     if (error) {

                                         NSLog(@"Data could not be saved.");

                                     } else {
                                         NSLog(@"Data saved successfully.");
                                           [self presentLoggedInVC];
                                     }
                                 }];

                             }
                             else {
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization failed"
                                                                                     message:error.localizedDescription
                                                                                    delegate:self
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                 [alertView show];
                             }
                         }];
}


// Log out
- (IBAction)unwindFromLoggedInVC:(UIStoryboardSegue *)segue {
    [[Venmo sharedInstance] logout];
}


@end
