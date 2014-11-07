//
//  TaskCell.h
//  HootieHoo
//
//  Created by Alex Koshy on 11/4/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *clockIcon;
@property (strong, nonatomic) IBOutlet UIImageView *checkbox;

@property (strong, nonatomic) Task *task;

@end
