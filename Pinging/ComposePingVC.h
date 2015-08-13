//
//  ComposePingVC.h
//  Pinging
//
//  Created by Brexton Pham on 7/29/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface ComposePingVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, strong) PFObject *message;
@property (strong, nonatomic) NSMutableArray *verifiedPictures;
@property (strong, nonatomic) NSMutableArray *notVerifiedPictures;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *nonVerifiedRecipients;
@property (strong, nonatomic) NSMutableArray *contactPictureArray;
@property (strong, nonatomic) NSDictionary *dictionary;
@property BOOL textDismissed;
@property int number;

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet UILabel *previewYakLabel;
@property (strong, nonatomic) IBOutlet UIView *previewYakView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIView *sendBarView;
@property (weak, nonatomic) IBOutlet UICollectionView *recipientsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *recipientsCollectionFlowLayout;



- (IBAction)sendButton:(id)sender;
- (IBAction)backButton:(id)sender;
- (void)uploadYak;

@end
