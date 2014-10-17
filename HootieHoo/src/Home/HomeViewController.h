//
//  HomeViewController.h
//  HootieHoo
//
//  Created by Alex Koshy on 10/17/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
