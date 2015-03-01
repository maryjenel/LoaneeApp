//
//  venmoUser.h
//  Loanee
//
//  Created by Gustavo Couto on 2015-02-28.
//  Copyright (c) 2015 makr.space. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VENUser.h>

@interface venmoUser : NSObject

@property NSString * userName;
@property NSString * firstName;
@property NSString * lastName;
@property NSString * displayName;
@property NSString * about;
@property NSString * profileImageUrlString;
@property NSString * primaryPhone;
@property NSString * email;
@property NSString * externalId;


-(instancetype)initWithVenUser:(VENUser *) user;
+(NSDictionary *)toDictonary:(VENUser *) user;
@end
