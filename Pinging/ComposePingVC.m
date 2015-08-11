//
//  ComposePingVC.m
//  Pinging
//
//  Created by Brexton Pham on 7/29/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "ComposePingVC.h"
#import "PingContactCell.h"

@interface ComposePingVC ()

@end

@implementation ComposePingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *verifiedPicture1 = [UIImage imageNamed:@"icon-badge1.png"];
    UIImage *verifiedPicture2 = [UIImage imageNamed:@"icon-color-badge2.png"];
    UIImage *verifiedPicture3 = [UIImage imageNamed:@"icon-color2-badge3.png"];
    self.verifiedPictures = [[NSMutableArray alloc] initWithObjects:verifiedPicture1, verifiedPicture2, verifiedPicture3, nil];
    
    UIImage *notVerifiedPicture1 = [UIImage imageNamed:@"icon-color4.png"];
    UIImage *notVerifiedPicture2 = [UIImage imageNamed:@"icon-purple5.png"];
    UIImage *notVerifiedPicture3 = [UIImage imageNamed:@"icon6.png"];
    self.notVerifiedPictures = [[NSMutableArray alloc] initWithObjects:notVerifiedPicture1, notVerifiedPicture2, notVerifiedPicture3, nil];
    
    self.recipients = [[NSMutableArray alloc] init];
    self.nonVerifiedRecipients = [[NSMutableArray alloc] init];
    self.navigationBarView.layer.borderColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1].CGColor;
    self.navigationBarView.layer.borderWidth = 0.5f;
    
    self.previewYakView.layer.borderColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1].CGColor;
    self.previewYakView.layer.borderWidth = 0.5f;
    
    self.sendBarView.layer.borderColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1].CGColor;
    self.sendBarView.layer.borderWidth = 0.5f;
    
    self.contactsTableView.layer.borderColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1].CGColor;
    self.contactsTableView.layer.borderWidth = 0.5f;
    
    self.previewYakLabel.text = [self.message objectForKey:@"fileContents"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.friends = objects;
            [self.contactsTableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    PingContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.contactNameLabel.text = user.username;
    cell.contactPhoneLabel.text = [user objectForKey:@"phone"];
    
    if ([[user objectForKey:@"verificationStatus"] isEqualToString:@"True"]) {
        [cell.contactsLogo setImage:self.verifiedPictures[arc4random_uniform(3)]];
         } else {
             [cell.contactsLogo setImage:self.notVerifiedPictures[arc4random_uniform(3)]];
         }
    
    
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.contactsTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PingContactCell *cell = [self.contactsTableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if ([[user objectForKey:@"verificationStatus"] isEqualToString:@"False"]) {
            NSLog(@"verification status: %@", [user objectForKey:@"verificationStatus"]);
            [self.nonVerifiedRecipients addObject:[user objectForKey:@"phone"]];
            NSLog(@"phone number added: %@", [user objectForKey:@"phone"]);
            //NSLog(@"nonVerifiedRecipients count: %@", [self.nonVerifiedRecipients count]);
        } else {
            [self.recipients addObject:user.objectId];
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
        [self.nonVerifiedRecipients removeObject:[user objectForKey:@"phone"]];
    }
}

- (IBAction)sendButton:(id)sender {
    [self uploadYak];
    
    NSLog(@"send button pressed");
    if ([self.nonVerifiedRecipients count] != 0) {
        //NSLog(@"%@", [self.nonVerifiedRecipients count]);
        if ([MFMessageComposeViewController canSendText]) {
            NSLog(@"hi");
            [self displaySMSComposerSheet];
            NSLog(@"hi1");
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Device not configured to send SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadYak {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    NSString *yak = [self.message objectForKey:@"fileContents"];
    NSLog(@"this is the ping %@",yak);
    
    //obtain data if yak actually exists
    if ([yak length] != 0) {
        fileData = [yak dataUsingEncoding:NSUTF8StringEncoding];
        fileName = @"yak";
        fileType = @"string";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) { //Alerts if yak doesn't save properly in Parse
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Your ping REALLY didn't get delivered." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"]; //Creating classes to save message to in parse
            [message setObject:yak forKey:@"fileContents"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message setObject:@"ping" forKey:@"pingOrNah"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Ping has not been delivered." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                } else {
                    //IT WORKED.
                }
            }];
        }
    }];
}

- (void)reset {
    self.message = nil;
    [self.recipients removeAllObjects];
}

- (void)displaySMSComposerSheet {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    //picker.recipients = [NSArray arrayWithObjects:@"1234", @"2345", nil];
    picker.recipients = [[NSArray alloc] initWithArray:self.nonVerifiedRecipients copyItems:YES];
    picker.body = @"I'm sharing a yak with you! Check it out :) http://yak.co/7384";
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    //self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            //self.feedbackMsg.text = @"Result: SMS sending canceled";
            break;
        case MessageComposeResultSent:
            //self.feedbackMsg.text = @"Result: SMS sent";
            break;
        case MessageComposeResultFailed:
            //self.feedbackMsg.text = @"Result: SMS sending failed";
            break;
        default:
            //self.feedbackMsg.text = @"Result: SMS not sent";
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UICollectionViewDatasource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger totalRecipients = [self.recipients count] + [self.nonVerifiedRecipients count];
    return totalRecipients;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"contactCollectionViewCell";
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell.delegate = self;
    
    CGFloat red = (float)rand() / (float)RAND_MAX;
    CGFloat green = (float)rand() / (float)RAND_MAX;
    CGFloat blue = (float)rand() / (float)RAND_MAX;
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    
    return cell;
}

@end
