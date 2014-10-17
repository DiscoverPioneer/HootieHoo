//
//  Task.h
//  HootieHoo
//
//  Created by Phil Scarfi on 10/17/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * completed;

@end
