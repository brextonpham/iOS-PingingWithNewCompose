//
//  YakDetailVC.m
//  Pinging
//
//  Created by Brexton Pham on 7/28/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "YakDetailVC.h"

@interface YakDetailVC ()

@end

@implementation YakDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *yak = [self.message objectForKey:@"fileContents"];
    NSLog(@"%@", yak);
    self.yakLabel.text = [self.message objectForKey:@"fileContents"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
