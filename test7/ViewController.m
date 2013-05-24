//
//  ViewController.m
//  test7
//
//  Created by Joosung Kim on 4/26/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//
//  Edited by Jay Jeong on 4/28/13
//  Copyright (c) 2013 Jay Jeong. All rights reserved.


#import "ViewController.h"


@interface ViewController ()
@property (retain, nonatomic) IBOutlet UIView *taskList;
@property (retain, nonatomic) IBOutlet UIView *locationList;
@property (retain, nonatomic) IBOutlet UINavigationItem *headerMain;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UINavigationBar *taskBar;

@end

@implementation ViewController

@synthesize scrollView, taskList, locationList, tableView, activeAct,globalLocation;
NSInteger *globalCounter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // create inside content size of scrollview
    CGSize contentSize = CGSizeMake(scrollView.frame.size.width *2, scrollView.frame.size.height);
    
    // set up scrollview content size
    [scrollView setContentSize:contentSize];

    // create scrollview size for setting up page view size
    CGSize scrollViewSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
    
    // create frame for each page view
    CGRect firstViewFrame = CGRectMake(0.0f,
                                       0.0f,
                                       scrollViewSize.width,
                                       scrollViewSize.height);
    CGRect SecondViewFrame = CGRectMake(scrollViewSize.width,
                                       0.0f,
                                       scrollViewSize.width,
                                       scrollViewSize.height);
    
    // set up frame to each page view
    [locationList setFrame:firstViewFrame];
    [taskList setFrame:SecondViewFrame];
    
    // add views on the scroll view
    [scrollView addSubview:taskList];
    [scrollView addSubview:locationList];
   
//    [scrollView addSubview: self.taskList];
//    [scrollView setContentSize:self.taskList.frame.size];
    self.observerName.text = self.valObsName;
    self.observeeName.text = self.valObsEEName;
    self.observeSite.text = self.valObsSite;
    
    // initialize the global counter with 0
    globalCounter = (int) 0;
}

- (void)viewDidLayoutSubviews
{
    activeAct = [[NSMutableArray alloc] init];
    [tableView setEditing:YES];

}
- (void)viewDidAppear
{
    [scrollView setContentSize:CGSizeMake(770, 740)];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_observerName release];
//    [_observeSite release];
    [_detailTitle release];
    [_partialV2 release];
    [_partialV1 release];
    [_partialV3 release];
    [_partialV4 release];
    [_headerMain release];
    [_activityContainer release];
    [_taskBar release];
    [super dealloc];
}
- (IBAction)changeLocation:(id)sender {
    self.detailTitle.title = @"Location";
    self.partialV1.hidden = NO;
    self.partialV2.hidden = YES;
    self.partialV3.hidden = YES;
    self.partialV4.hidden = YES;
}
- (IBAction)taskComp:(id)sender {
    self.detailTitle.title = @"Computer";
    self.partialV1.hidden = YES;
    self.partialV2.hidden = NO;
    self.partialV3.hidden = YES;
    self.partialV4.hidden = YES;
}

- (IBAction)taskPaper:(id)sender {
    self.detailTitle.title = @"Paper";
    self.partialV1.hidden = YES;
    self.partialV2.hidden = YES;
    self.partialV3.hidden = NO;
    self.partialV4.hidden = YES;
}

- (IBAction)taskInteraction:(id)sender {
    self.detailTitle.title = @"Interaction";
    self.partialV1.hidden = YES;
    self.partialV2.hidden = YES;
    self.partialV3.hidden = YES;
    self.partialV4.hidden = NO;
}

- (IBAction)endObservation:(id)sender {
    UIAlertView *exitConfirm = [[UIAlertView alloc] initWithTitle:@"End Observation" message:@"Are you sure to end the current observation?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [exitConfirm show];
    [exitConfirm release];
    
}

/*
- (IBAction)changeViewTask:(id)sender {
    locationList.hidden = YES;
    taskList.hidden = NO;
    self.headerMain.title = @"Task";
}

- (IBAction)changeViewLocation:(id)sender {
    taskList.hidden = YES;
    locationList.hidden = NO;
    self.headerMain.title = @"Location";
}
*/


@synthesize lblLocation;
@synthesize observerName;
@synthesize observeeName;
@synthesize observeSite;
@synthesize btnLocation;

- (IBAction)changeLabelLocation_exam:(id)sender {
    UIButton *button = (UIButton *)sender;
//    lblLocation.text = [NSString stringWithFormat:@"Exam Room %@", button.titleLabel.text];
    [self.btnLocation setTitle:[NSString stringWithFormat:@"Exam Room %@", button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (Exam Room %@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // checks whether there is more than an active task in the array, and if there is, update the locations of the items in the  array
    if(activeAct.count == 0){
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
    
}
- (IBAction)changeLabelLocation_office:(id)sender {
    UIButton *button = (UIButton *)sender;
//    lblLocation.text = [NSString stringWithFormat:@"Office %@", button.titleLabel.text];
    [self.btnLocation setTitle:[NSString stringWithFormat:@"Office %@", button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (Office %@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}
- (IBAction)changeLabelLocation_procedure:(id)sender {
    UIButton *button = (UIButton *)sender;
//    lblLocation.text = [NSString stringWithFormat:@"Procedure Room %@", button.titleLabel.text];
    [self.btnLocation setTitle:[NSString stringWithFormat:@"Procedure Room %@", button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (Procedure Room %@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}
- (IBAction)changeLabelLocation_nurse:(id)sender {
    UIButton *button = (UIButton *)sender;
//    lblLocation.text = [NSString stringWithFormat:@"Nurse Station %@", button.titleLabel.text];
    [self.btnLocation setTitle:[NSString stringWithFormat:@"Nurse Station %@", button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (Nurse Station %@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}
- (IBAction)changeLabelLocation_lab:(id)sender {
    UIButton *button = (UIButton *)sender;
//    lblLocation.text = [NSString stringWithFormat:@"Lab %@", button.titleLabel.text];
    [self.btnLocation setTitle:[NSString stringWithFormat:@"Lab %@", button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (Lab %@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}
- (IBAction)changeLabelLocation_other:(id)sender {
    UIButton *button = (UIButton *)sender;
//    lblLocation.text = [NSString stringWithFormat:@"%@", button.titleLabel.text];
    [self.btnLocation setTitle:[NSString stringWithFormat:@"%@", button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (%@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        [self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}

- (void) updateLocationOfArray:(id)sender {
    int count = 0;
    for (count = 0; count < [activeAct count]; count++){
        // gets the current time
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
        NSArray *currentArr = [activeAct objectAtIndex:count];
        NSLog(@"%@,%@,%@,%@,%@,%@,%@",[currentArr objectAtIndex:0],@"update of location",@"",self.btnLocation.titleLabel.text,timeFormatted,@"",@"");
    }
}
- (IBAction)scrollToLocation:(id)sender {
    [self scrollToPage:0];
}

-(void)scrollToPage:(NSInteger)page
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * page, 0.0f) animated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex]){
        NSLog(@"Cancel");
    }else{
        [self allTasksDone:nil];
        [self performSegueWithIdentifier:@"logoutSegue" sender: self];
        
    }
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return activeAct.count;
}

-(void) taskDone:(id) sender {
    // gets the cell information from the superview
    UITableViewCell *owingCell = (UITableViewCell *)[sender superview];
    NSIndexPath *pathToCell = [tableView indexPathForCell:owingCell];
    
    // gets the current time
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];

    // log starts
    NSArray *nowArr = [activeAct objectAtIndex:pathToCell.row];
//    NSLog(@"%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:1],self.lblLocation.text,[nowArr objectAtIndex:2],self.observerName.text,self.observeeName.text,timeFormatted);
    NSLog(@"%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,timeFormatted,@"",@"");
    [activeAct removeObjectAtIndex:pathToCell.row];
    [tableView deleteRowsAtIndexPaths:@[pathToCell] withRowAnimation:UITableViewRowAnimationFade];
}

-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    UIButton *doneButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [doneButton addTarget:self action:@selector(taskDone:) forControlEvents:UIControlEventTouchDown];
    UIImage *doneBtnImg = [UIImage imageNamed:@"button_check_s.png"];
    doneButton.frame = CGRectMake(180,18,24,24);
    [doneButton setBackgroundImage:doneBtnImg forState:UIControlStateNormal];
    [cell addSubview:doneButton];
    
    
    // get the current row of the data
    NSArray *nowArr = [activeAct objectAtIndex:indexPath.row];
    // activity name
    UILabel *activityName = (UILabel *)[cell viewWithTag:102];
    activityName.text = [nowArr objectAtIndex:1];
    // activity time
    UILabel *activityTime = (UILabel *)[cell viewWithTag:103];
    activityTime.text = [nowArr objectAtIndex:2];
    // category
    UILabel *currentCat = (UILabel *)[cell viewWithTag:99];
    if([[nowArr objectAtIndex:3] intValue] >= 1000 && [[nowArr objectAtIndex:3] intValue] < 1100){
        currentCat.text = @"Parent Activity";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1100 && [[nowArr objectAtIndex:3] intValue] < 1200){
        currentCat.text = @"Phone";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1200 && [[nowArr objectAtIndex:3] intValue] < 1300){
        currentCat.text = @"Personal";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1300 && [[nowArr objectAtIndex:3] intValue] < 1400){
        currentCat.text = @"Talking/Rounding";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1400 && [[nowArr objectAtIndex:3] intValue] < 1500){
        currentCat.text = @"Walking/Moving";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1500 && [[nowArr objectAtIndex:3] intValue] < 1600){
        currentCat.text = @"Waiting for";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1600 && [[nowArr objectAtIndex:3] intValue] < 1700){
        currentCat.text = @"Looking for People";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1700 && [[nowArr objectAtIndex:3] intValue] < 1800){
        currentCat.text = @"Reading Paper Resources";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1800 && [[nowArr objectAtIndex:3] intValue] < 1900){
        currentCat.text = @"Writing Paper Resources";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1900 && [[nowArr objectAtIndex:3] intValue] < 2000){
        currentCat.text = @"Writing Computer Resources";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 2000 && [[nowArr objectAtIndex:3] intValue] < 2100){
        currentCat.text = @"Looking for Paper Resources";
    };
    if([[nowArr objectAtIndex:3] intValue] >= 2100 && [[nowArr objectAtIndex:3] intValue] < 2200){
        currentCat.text = @"Reading Computer Resources";
    };
    //}
    //test code
    //cell.textLabel.text = [activeAct objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)triggerTask:(id)sender {    
//    if([self.lblLocation.text isEqualToString:@"-"]){
    if([self.btnLocation.titleLabel.text isEqualToString:@"-"]){
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to select location first!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
        [error release];
    }else{
        UIButton *button = (UIButton *) sender;
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
        NSString *tagNum = [NSString stringWithFormat:@"%d", button.tag];
        NSArray *curSel = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",(int)globalCounter],button.titleLabel.text, timeFormatted, tagNum, nil];
        
        // makes a log in the console
//        NSLog(@"%@,%@,%d,%@,%@,%@",timeFormatted,self.lblLocation.text,button.tag,self.observerName.text,self.observeeName.text,@"n/a");
        NSLog(@"%@,%@,%d,%@,%@,%@,%@",[NSString stringWithFormat:@"%d",(int)globalCounter],@"creation",button.tag,self.btnLocation.titleLabel.text,timeFormatted,self.observerName.text,self.observeeName.text);
        globalCounter = (NSInteger *) ((int)globalCounter + 1);
        [activeAct insertObject:curSel atIndex:0];
        [tableView reloadData];
    }
}

- (IBAction)allTasksDone:(id)sender {
    for(int i = 0; i<activeAct.count; i++){
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];

        NSArray *nowArr = [activeAct objectAtIndex:i];
//        NSLog(@"%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:1],self.lblLocation.text,[nowArr objectAtIndex:2],self.observerName.text,self.observeeName.text,timeFormatted);
        NSLog(@"%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,timeFormatted,@"",@"");
    }
    [activeAct removeAllObjects];
    [tableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
        
        NSArray *nowArr = [activeAct objectAtIndex:indexPath.row];
//        NSLog(@"%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:1],self.lblLocation.text, [nowArr objectAtIndex:2], self.observerName.text, self.observeeName.text,@"canceled");
        NSLog(@"%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"cancellation",@"",self.btnLocation.titleLabel.text,timeFormatted,@"",@"");
        [activeAct removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
