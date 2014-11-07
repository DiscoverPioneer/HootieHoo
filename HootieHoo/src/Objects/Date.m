//
//  Date.m
//  HootieHoo
//
//  Created by Alex Koshy on 11/2/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import "Date.h"

@implementation Date

- (Date *)init {
    
    self = [super init];
    if (!self) {
        
    }
    return self;
}

+ (Date *)today {
    
    Date *today = [[Date alloc] init];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay) fromDate:date];

    //NSLog(@"day: %d", [components day]);
    today.day = [components day];
    today.month = [components month];
    today.year = [components year];
    
    NSArray *monthNames = @[@"January",@"February",@"March",
                            @"April",  @"May",     @"June",
                            @"July",   @"August",  @"September",
                            @"October",@"November",@"December"];
    NSArray *monthShortNames = @[@"Jan",@"Feb",@"Mar",
                                 @"Apr",@"May",@"Jun",
                                 @"Jul",@"Aug",@"Sep",
                                 @"Oct",@"Nov",@"Dec"];
    
    today.monthName = monthNames[today.month-1];
    today.monthShortName = monthShortNames[today.month-1];
    
    
    return today;
}

@end
