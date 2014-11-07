//
//  TaskCell.m
//  HootieHoo
//
//  Created by Alex Koshy on 11/4/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TaskCell

- (void)awakeFromNib {
    // Initialization code
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                  target:self
                                                selector:@selector(updateLabels)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLabels {
    double duration = [self.task.duration doubleValue];
    self.task.duration = [NSNumber numberWithDouble:duration - 1];
    NSInteger timeInterval = [self.task.duration integerValue];
    NSInteger minutes = (timeInterval / 60) % 60;
    NSInteger hours = (timeInterval / 3600);
    self.timestampLabel.text = [NSString stringWithFormat:@"%ldhr %ld min",(long)hours,(long)minutes];

}

@end
