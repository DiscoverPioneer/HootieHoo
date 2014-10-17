//
//  AddTaskViewController.m
//  HootieHoo
//
//  Created by Alex Koshy on 10/17/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createBarButtonItems];
}

#pragma mark - Initialization 

- (void)createBarButtonItems {
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                         target:self
                                                                         action:@selector(cancelButtonPressed)];
    self.cancelButton = cancel;
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                            target:self
                                                                            action:@selector(doneButtonPressed)];
    self.doneButton = done;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}
- (void)cancelButtonPressed {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)doneButtonPressed {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
