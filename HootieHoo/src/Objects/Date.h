//
//  Date.h
//  HootieHoo
//
//  Created by Alex Koshy on 11/2/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Date : NSObject

@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger month;
@property (strong, nonatomic) NSString *monthName;
@property (strong, nonatomic) NSString *monthShortName;
@property (assign, nonatomic) NSInteger year;

+ (Date *)today;

@end
