//
//  AddTaskViewController.m
//  HootieHoo
//
//  Created by Alex Koshy on 10/17/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Task.h"
#import "AppDelegate.h"

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
    
    [self saveTask];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveTask {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    task.name = self.nameTextField.text;
    task.completed = [NSNumber numberWithBool:NO];
    task.number = [NSNumber numberWithInt:-1];
    task.duration = [NSNumber numberWithDouble:self.durationPicker.countDownDuration];
    NSError *error;
    [context save:&error];
    if (error) {
        //Display alert
        NSLog(@"%@",[error localizedDescription]);
    }
}

@end
