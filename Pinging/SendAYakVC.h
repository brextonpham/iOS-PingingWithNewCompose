//
//  SendAYakVC.h
//  Pinging
//
//  Created by Brexton Pham on 7/28/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MainFeedTVC.h"

@interface SendAYakVC : UIViewController {
    IBOutlet UIView *frameForCapture;
    IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) NSArray *allUsers;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *allUsersObjectIds;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIView *sendView;

- (IBAction)cancelButton:(id)sender;
- (IBAction)sendButton:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (void)uploadYak; 

@end
