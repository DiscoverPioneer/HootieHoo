//
//  ViewController.m
//  HootieHoo
//
//  Created by Phil Scarfi on 10/17/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//


#import "ViewController.h"
#import "AppDelegate.h"
#import "Task.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *oldTasks;
@property (nonatomic, strong) NSMutableArray *futureTasks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.oldTasks = [NSMutableArray new];
    self.futureTasks = [NSMutableArray new];
    
    [self loadData];
}

- (void)loadData {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Task"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    //Iterate through array, and seperate into old and future tasks
    for (NSManagedObject *object in objects) {
        Task *task = (Task *)object;
        BOOL completed = [task.completed boolValue];
        if (completed) {
            [self.oldTasks addObject:task];
        }
        else {
            [self.futureTasks addObject:task];
        }
    }
}

- (void)saveTaskWithName:(NSString *)name andDuration:(NSNumber *)duration {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *futureTask;
    futureTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:context];
    
    [futureTask setValue:name forKey:@"name"];
    [futureTask setValue:duration forKey:@"duration"];
    [futureTask setValue:[NSNumber numberWithBool:NO] forKey:@"completed"];
    
    Task *lastTask;
    if ([self.futureTasks count] != 0) {
        lastTask = [self.futureTasks lastObject];
    }
    else if ([self.oldTasks count] != 0) {
        lastTask = [self.oldTasks lastObject];
    }
    
    if (lastTask) {
        int number = [lastTask.number intValue];
        number++;
        [futureTask setValue:[NSNumber numberWithInt:number] forKey:@"number"];
    }
    else {
        [futureTask setValue:[NSNumber numberWithInt:1] forKey:@"number"];
    }

    //Save
    NSError *error;
    [context save:&error];
  
}

- (void)finishTask:(Task *)task {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *futureTask;
    futureTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:context];
    
    [futureTask setValue:[NSNumber numberWithBool:YES] forKey:@"completed"];
    
    
    
    //Save
    NSError *error;
    [context save:&error];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [self.oldTasks count];
            break;
        case 1:
            return 5;
            //return [self.futureTasks count];
            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

@end
