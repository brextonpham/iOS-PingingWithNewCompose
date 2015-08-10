//
//  Me2VC.h
//  Pinging
//
//  Created by Brexton Pham on 8/7/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Me2VC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;

@end
