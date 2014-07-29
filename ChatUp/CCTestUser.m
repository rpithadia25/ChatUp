//
//  CCTestUser.m
//  ChatUp
//
//  Created by Rakshit Pithadia on 7/29/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import "CCTestUser.h"

@implementation CCTestUser

+(void)saveTestUserToParse{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user15";
    newUser.password = @"password15";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSDictionary *profile = @{@"age" : @28, @"birthday" : @"11/22/1987", @"firstName" : @"Bruce", @"gender" : @"female", @"location" : @"Gotham City, United States", @"name" : @"Bruce Wayne"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"profilePicture1.jpg"];
                NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        PFObject *photo = [PFObject objectWithClassName:kCCPhotoClassKey];
                        [photo setObject:newUser forKey:kCCPhotoUserKey];
                        [photo setObject:photoFile forKey:kCCPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"Photo Saved Successfully");
                        }];
                    }
                }];
                
            }];
        }
    }];
}

@end
