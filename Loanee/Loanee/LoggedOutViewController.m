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
#define kBaseURL @"https://loanee.firebaseio.com/"

@interface LoggedOutViewController ()

@property Firebase * ref;
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
    self.ref = [[Firebase alloc] initWithUrl:kBaseURL];
//    if ([[Venmo sharedInstance] isSessionValid]) {
//
//        [self presentLoggedInVC];
//    }
}

- (void)presentLoggedInVC {
   // [self performSegueWithIdentifier:@"presentLoggedInVC" sender:self];
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
                                 //auth firebase
                                 [self.ref authWithOAuthProvider:@"venmo" token:[Venmo sharedInstance].session.accessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                     if (error != nil) {
                                         // there was an error authenticating with Firebase
                                         NSLog(@"Error logging in to Firebase: %@", error);
                                         // display an alert showing the error message
                                         NSString *message = [NSString stringWithFormat:@"There was an error logging into Firebase using Venmo: %@",
                                                              [error localizedDescription]];
                                         NSLog(@"%@", message);
                                     } else {
                                         // all is fine, set the current user and update UI
                                         [self updateUIAndSetCurrentUser:authData];
                                     }
                                     [self presentLoggedInVC];
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


// sets the user and updates the UI
- (void)updateUIAndSetCurrentUser:(FAuthData *)currentUser
{
    // set the user
    self.currentUser = currentUser;
    if (currentUser == nil) {
        int x;
    } else {
        // update the status label to show which user is logged in using which provider
        NSString *statusText;
        if ([currentUser.provider isEqualToString:@"venmo"]) {
            statusText = [NSString stringWithFormat:@"Logged in as %@ (Venmo)",
                          currentUser.providerData[@"displayName"]];
        }
    }//uhuw4
}

// Log out
- (IBAction)unwindFromLoggedInVC:(UIStoryboardSegue *)segue {
    [[Venmo sharedInstance] logout];
}


@end
