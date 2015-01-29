//
//  HomeViewController.m
//  HootieHoo
//
//  Created by Alex Koshy on 10/17/14.
//  Copyright (c) 2014 Pioneer Mobile Application. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Task.h"
#import "AddTaskViewController.h"
#import "Date.h"
#import "TaskCell.h"
#import <QuartzCore/QuartzCore.h>

NSInteger const kSTATE_PAUSE = 1;
NSInteger const kSTATE_PLAY = 2;

@interface HomeViewController () {
    UIColor *lightGreenColor;
    UIColor *selectedTextColor;
    
    // TODO: Remove sample data
    NSMutableArray *taskNames;
    NSMutableArray *taskHours;
}

@property (nonatomic, strong) NSMutableArray *oldTasks;
@property (nonatomic, strong) NSMutableArray *futureTasks;

@property (nonatomic, strong) TaskCell *selectedTaskCell;
@property (nonatomic, assign) NSInteger selectedTaskIndex;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        lightGreenColor = [UIColor colorWithRed:(104/255.0)
                                            green:(224/255.0)
                                             blue:(192/255.0) alpha:1.0];
        selectedTextColor = [UIColor colorWithRed:( 82/255.0)
                                            green:(163/255.0)
                                             blue:(134/255.0) alpha:1.0];
        
        // TODO: Remove sample data
        taskNames = [NSMutableArray new];
        taskHours = [NSMutableArray new];
        for (int i = 1; i <= 15; i++) {
            NSString *str = [NSString stringWithFormat:@"Task %i", i];
            [taskNames addObject:str];
            
            NSInteger num = (i % 3) + 1;
            NSString *str2;
            if (num == 1) {
                str2 = [NSString stringWithFormat:@"%ihr", num];
            } else {
                str2 = [NSString stringWithFormat:@"%ihrs", num];
            }
            [taskHours addObject:str2];
        }
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.oldTasks = [NSMutableArray new];
    self.futureTasks = [NSMutableArray new];
    
    [self configureTableView];
    [self configureTopView];
    [self createBarButtonItems];
    [self registerNibs];
    
    Date *today = [Date today];
    self.title = [NSString stringWithFormat:@"%@ %i", today.monthShortName, today.day];
    
    self.selectedTaskIndex = -1;
    self.playButton.tag = kSTATE_PLAY;
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}

#pragma mark - Initialization

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 60;
}
- (void)configureTopView {
    [self.detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.detailButton.backgroundColor = lightGreenColor;
    self.detailButton.layer.cornerRadius = 5;
}
- (void)createBarButtonItems {
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                   target:self
                                                                   action:@selector(addButtonPressed)];
    self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(editButtonPressed)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                      target:self
                                                                      action:@selector(cancelButtonPressed)];
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(doneButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.leftBarButtonItem = self.editButton;
}
- (void)registerNibs {
    
    // Register custom cell
    UINib *nib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"CustomCell"];
}

#pragma mark - Task Management

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
    
    //First Clear Arrays
    [self.oldTasks removeAllObjects];
    [self.futureTasks removeAllObjects];
    
    // Iterate through array, and seperate into old and future tasks
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
    [self.tableView reloadData];
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

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Remove sample data
    //return taskHours.count;
    if (section == 0) {
        return [self.oldTasks count];
    }
    else {
        return [self.futureTasks count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Initialize custom cell
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    if (!cell) {
        cell = [[TaskCell alloc] init];
    }
    Task *task;
    if (indexPath.section == 0) {
        task = [self.oldTasks objectAtIndex:indexPath.row];
    }
    else {
        task = [self.futureTasks objectAtIndex:indexPath.row];
    }
    cell.task = task;
    cell.nameLabel.text = task.name;
        
    if (indexPath.row == self.selectedTaskIndex) {
        [self selectCell:cell];
    } else {
        [self deselectCell:cell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table View Section

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? [self.oldTasks count] : [self.futureTasks count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? @"Old Tasks" : @"New Tasks";

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // Retrieve section title
    NSString *oldSectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    NSString *sectionTitle = [NSString stringWithFormat:@"   %@",oldSectionTitle];
    
    // Edit label properties to span view width
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 30);
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    label.text = [sectionTitle uppercaseString];
    
    // Create view to be returned
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    
    return view;
}

#pragma mark - Table View Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Swap Top Info
    // TODO: Remove sample data
    self.taskName.text = taskNames[indexPath.row];
    // TODO: Change timestamp
    
    // Deselect previously selected cell
    [self deselectCell:self.selectedTaskCell];
    
    // Select new cell
    if (self.selectedTaskIndex != indexPath.row) {
        
        self.selectedTaskCell = (TaskCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self selectCell:self.selectedTaskCell];
        
        // Set new selection index
        self.selectedTaskIndex = indexPath.row;
    } else {
        self.selectedTaskIndex = -1;
    }
    
}
- (void)selectCell:(TaskCell *)cell {
    
    cell.nameLabel.textColor = selectedTextColor;
    cell.timestampLabel.textColor = selectedTextColor;
    cell.checkbox.image = [UIImage imageNamed:@"checked.png"];
    cell.clockIcon.image = [UIImage imageNamed:@"clock-highlighted.png"];
}
- (void)deselectCell:(TaskCell *)cell {
    
    cell.nameLabel.textColor = [UIColor blackColor];
    cell.timestampLabel.textColor = [UIColor blackColor];
    cell.checkbox.image = [UIImage imageNamed:@"unchecked.png"];
    cell.clockIcon.image = [UIImage imageNamed:@"clock.png"];
}

#pragma mark - Bar Button Interaction

- (void)addButtonPressed {
    AddTaskViewController *vc = [[AddTaskViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)editButtonPressed {
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}
- (void)cancelButtonPressed {
    self.navigationItem.leftBarButtonItem = self.editButton;
    self.navigationItem.rightBarButtonItem = self.addButton;
}
- (void)doneButtonPressed {
    self.navigationItem.leftBarButtonItem = self.editButton;
    self.navigationItem.rightBarButtonItem = self.addButton;
}

#pragma mark - Table View Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Override to support conditional editing of the table view.
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Override to support editing the table view.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Override to support rearranging the table view.
    return;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Override to support conditional rearranging of the table view.
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Actions

- (IBAction)clickedPlayButton:(UIButton *)button {
    
    if (button.tag == kSTATE_PLAY) {
        // Switch to Pause
        [button setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        button.tag = kSTATE_PAUSE;
    }
    else if (button.tag == kSTATE_PAUSE) {
        // Switch to Play
        [button setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        button.tag = kSTATE_PLAY;
    }
}

@end
