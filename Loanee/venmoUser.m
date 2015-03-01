//
//  venmoUser.m
//  Loanee
//
//  Created by Gustavo Couto on 2015-02-28.
//  Copyright (c) 2015 makr.space. All rights reserved.
//

#import "venmoUser.h"

@implementation venmoUser


-(instancetype)initWithVenUser:(VENUser *) user
{
    self = [super init];
    if (self) {

        self.userName = user.username;
        self.firstName = user.firstName;
        self.lastName = user.lastName;
        self.displayName = user.displayName;
        self.about = user.about;
        self.profileImageUrlString = user.profileImageUrl;
        self.primaryPhone = user.primaryPhone;
        self.email = user.primaryEmail;
        self.externalId = user.externalId;
    }
    return self;
}



+(NSDictionary *)toDictonary:(VENUser *) user {
    NSDictionary * myDictionary = [[NSDictionary alloc] init];
    myDictionary = @{@"firstName":user.firstName,
                     @"lastName":user.lastName,
                     @"displayName":user.displayName,
                     @"about":user.about,
                     @"profileImageUrl":user.profileImageUrl,
                     @"primaryPhone":user.primaryPhone,
                     @"primaryEmail":user.primaryEmail,
                     @"externalId":user.externalId};
    return myDictionary;

}
@end
