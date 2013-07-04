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
@property (retain, nonatomic) IBOutlet UIView *taskList2;
@property (retain, nonatomic) IBOutlet UIView *locationList;
@property (retain, nonatomic) IBOutlet UIView *locMilesCity;
@property (retain, nonatomic) IBOutlet UIView *locCodyClinic;
@property (retain, nonatomic) IBOutlet UIView *locCabinCreek;
@property (retain, nonatomic) IBOutlet UINavigationItem *headerMain;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UINavigationBar *taskBar;

@end

@implementation ViewController

@synthesize scrollView, taskList, taskList2, locationList, locMilesCity, locCodyClinic, locCabinCreek, tableView, activeAct, globalLocation, exportArr, isMultitasking, interruptBtn;
NSInteger *globalCounter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // create inside content size of scrollview
    CGSize contentSize = CGSizeMake(scrollView.frame.size.width *3, scrollView.frame.size.height);
    
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
    CGRect ThirdViewFrame = CGRectMake(scrollViewSize.width*2,
                                       0.0f,
                                       scrollViewSize.width,
                                       scrollViewSize.height);
    
    // set up frame to each page view
    [locationList setFrame:firstViewFrame];
    [taskList setFrame:SecondViewFrame];
    [taskList2 setFrame:ThirdViewFrame];
    
    // add views on the scroll view
    [scrollView addSubview:taskList];
    [scrollView addSubview:taskList2];

    if([self.valObsSite isEqualToString:@"Miles City"]){
        locCodyClinic.hidden = YES;
        locCabinCreek.hidden = YES;
        locationList.hidden = YES;
        [scrollView addSubview:locMilesCity];
    }else if([self.valObsSite isEqualToString:@"Cody Clinic"]){
        locMilesCity.hidden = YES;
        locCabinCreek.hidden = YES;
        locationList.hidden = YES;
        [scrollView addSubview:locCodyClinic];
    }else if([self.valObsSite isEqualToString:@"Cabin Creek"]){
        locCodyClinic.hidden = YES;
        locMilesCity.hidden = YES;
        locationList.hidden = YES;
    }else{
        locMilesCity.hidden = YES;
        locCodyClinic.hidden = YES;
        locCabinCreek.hidden = YES;
        [scrollView addSubview:locationList];
    }
   
//    [scrollView addSubview: self.taskList];
//    [scrollView setContentSize:self.taskList.frame.size];
    self.observerName.text = self.valObsName;
    self.observeeName.text = self.valObsEEName;
    self.observeSite.text = self.valObsSite;
    
    // initialize the global counter with 0
    globalCounter = (int) 0;
    
    // initialize export array
    exportArr = [[NSMutableArray alloc] init];
}

- (void)viewDidLayoutSubviews
{
    activeAct = [[NSMutableArray alloc] init];
    [tableView setEditing:NO];

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

- (IBAction)changeLocMiles:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *prefix;
    
    if(button.tag >= 1000 && button.tag < 1100){
        prefix = @"Pulm";
    }else if(button.tag >= 1100 && button.tag < 1200){
        prefix = @"Rece";
    }else if(button.tag >= 1200 && button.tag < 1300){
        prefix = @"Lab";
    }else if(button.tag >= 1300 && button.tag < 1400){
        prefix = @"Infu";
    }else if(button.tag >= 1400 && button.tag < 1500){
        prefix = @"FaPP";
    }else if(button.tag >= 1500 && button.tag < 1600){
        prefix = @"Conf";
    }else if(button.tag >= 1600 && button.tag < 1700){
        prefix = @"Tamm";
    }else{
        prefix = @"Error_CheckTheList";
    }
    
    [self.btnLocation setTitle:[NSString stringWithFormat:@"%@_%@", prefix, button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (%@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}

- (IBAction)changeLocCC:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *prefix;
    
    if(button.tag >= 1000 && button.tag < 1100){
        prefix = @"CC";
    }else if(button.tag >= 1100 && button.tag < 1200){
        prefix = @"SV";
    }else if(button.tag >= 1200 && button.tag < 1300){
        prefix = @"CD";
    }else{
        prefix = @"Error_CheckTheList";
    }
    
    [self.btnLocation setTitle:[NSString stringWithFormat:@"%@_%@", prefix, button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (%@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }

}
- (IBAction)changeLabelLocation_exam:(id)sender {
    UIButton *button = (UIButton *)sender;
//    lblLocation.text = [NSString stringWithFormat:@"Exam Room %@", button.titleLabel.text];
    [self.btnLocation setTitle:[NSString stringWithFormat:@"Exam Room %@", button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (Exam Room %@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // checks whether there is more than an active task in the array, and if there is, update the locations of the items in the  array
    if(activeAct.count == 0){
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
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
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
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
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
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
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
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
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
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
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}

- (void) updateLocationOfArray:(id)sender {
    int count = 0;
    for (count = 0; count < [activeAct count]; count++){
        // gets the current time
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
        [dateFormatterD setDateFormat:@"MMddyyyy"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
        NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
        NSArray *currentArr = [activeAct objectAtIndex:count];
        NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[currentArr objectAtIndex:0],@"update of location",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
        // put this information into the export array
        NSArray *tempStorage = [[NSArray alloc] initWithObjects:[currentArr objectAtIndex:0],@"update of location",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
        [exportArr addObject:tempStorage];
        if(exportArr.count > 0){
            NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
        }
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
        [self saveData: nil];
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
    NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
    [dateFormatterD setDateFormat:@"MMddyyyy"];

    NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
    NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
    
    // log starts
    NSArray *nowArr = [activeAct objectAtIndex:pathToCell.row];
//    NSLog(@"%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:1],self.lblLocation.text,[nowArr objectAtIndex:2],self.observerName.text,self.observeeName.text,timeFormatted);
    NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
    
    // unhighlight the task button
    UIButton *selectedBtn;
    if ([[nowArr objectAtIndex:3] integerValue] < 1700 )
    {
        selectedBtn = (UIButton *)[taskList viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
    } else {
        // for alias button (Personal-Socializing/chtting)
        if ([[nowArr objectAtIndex:3] integerValue] == 1906)
        {
            selectedBtn = (UIButton *)[taskList viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
            [selectedBtn setSelected:NO];
        }
        selectedBtn = (UIButton *)[taskList2 viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
    }
    [selectedBtn setSelected:NO];
    
    // put this information into the export array
    NSArray *tempStorage = [[NSArray alloc] initWithObjects:[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
    [exportArr addObject:tempStorage];
    if(exportArr.count > 0){
        NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
    }

    [activeAct removeObjectAtIndex:pathToCell.row];
    [tableView deleteRowsAtIndexPaths:@[pathToCell] withRowAnimation:UITableViewRowAnimationFade];
}
-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    /* remove check_button - 06/26/2013
    UIButton *doneButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [doneButton addTarget:self action:@selector(taskDone:) forControlEvents:UIControlEventTouchDown];
    UIImage *doneBtnImg = [UIImage imageNamed:@"button_check_s.png"];
    doneButton.frame = CGRectMake(180,18,24,24);
    [doneButton setBackgroundImage:doneBtnImg forState:UIControlStateNormal];
    [cell addSubview:doneButton];
    */
    
    // get the current row of the data
    NSArray *nowArr = [activeAct objectAtIndex:indexPath.row];
    // get the sequence number
    UILabel *sequenceNumber = (UILabel *)[cell viewWithTag:105];
    sequenceNumber.text = [nowArr objectAtIndex:0];
    [sequenceNumber setTextColor:[UIColor blackColor]];
    // activity name
    UILabel *activityName = (UILabel *)[cell viewWithTag:102];
    activityName.text = [nowArr objectAtIndex:1];
    [activityName setTextColor:[UIColor blackColor]];
    // activity time
    UILabel *activityTime = (UILabel *)[cell viewWithTag:103];
    activityTime.text = [nowArr objectAtIndex:2];
    // initialize the imageview
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:104];
    UIImage *img;
    
    // category
    //UILabel *currentCat = (UILabel *)[cell viewWithTag:99];
    if([[nowArr objectAtIndex:3] intValue] >= 1000 && [[nowArr objectAtIndex:3] intValue] < 1100){
        img = [UIImage imageNamed:@"colorCat6.png"];
        imgView.image = img;
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1100 && [[nowArr objectAtIndex:3] intValue] < 1200){
        img = [UIImage imageNamed:@"colorCat9.png"];
        imgView.image = img;
        [sequenceNumber setTextColor:[UIColor whiteColor]];
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1200 && [[nowArr objectAtIndex:3] intValue] < 1300){
        img = [UIImage imageNamed:@"colorCat5.png"];
        imgView.image = img;
        [sequenceNumber setTextColor:[UIColor whiteColor]];
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1300 && [[nowArr objectAtIndex:3] intValue] < 1400){
        img = [UIImage imageNamed:@"colorCat7.png"];
        imgView.image = img;
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1400 && [[nowArr objectAtIndex:3] intValue] < 1500){
        img = [UIImage imageNamed:@"colorCat4.png"];
        imgView.image = img;
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1500 && [[nowArr objectAtIndex:3] intValue] < 1600){
        img = [UIImage imageNamed:@"colorCat2.png"];
        imgView.image = img;
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1600 && [[nowArr objectAtIndex:3] intValue] < 1700){
        img = [UIImage imageNamed:@"colorCat3.png"];
        imgView.image = img;
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1700 && [[nowArr objectAtIndex:3] intValue] < 1800){
        img = [UIImage imageNamed:@"colorCat8.png"];
        imgView.image = img;
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1800 && [[nowArr objectAtIndex:3] intValue] < 1900){
        img = [UIImage imageNamed:@"colorCat10.png"];
        imgView.image = img;
        [sequenceNumber setTextColor:[UIColor whiteColor]];
    };
    if([[nowArr objectAtIndex:3] intValue] >= 1900 && [[nowArr objectAtIndex:3] intValue] < 2000){
        img = [UIImage imageNamed:@"colorCat11.png"];
        imgView.image = img;
    };
    if([[nowArr objectAtIndex:3] intValue] >= 2000 && [[nowArr objectAtIndex:3] intValue] < 2100){
        img = [UIImage imageNamed:@"colorCat12.png"];
        imgView.image = img;
        [sequenceNumber setTextColor:[UIColor whiteColor]];
    };
    
    //}
    //test code
    //cell.textLabel.text = [activeAct objectAtIndex:indexPath.row];
    return cell;
}
- (IBAction)onMultitaskChange:(id)sender {
    UISwitch *multitask = (UISwitch *)sender;
    if(multitask.isOn == NO){
        // see if there exists an item in the active tasks list

        if([activeAct count] != 0){
            while(activeAct.count > 1){
                NSDate *currentDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
                [dateFormatterD setDateFormat:@"MMddyyyy"];
                NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
                NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
                
                NSArray *nowArr = [activeAct objectAtIndex:1];
                //NSLog(@"%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:1],self.lblLocation.text,[nowArr objectAtIndex:2],self.observerName.text,self.observeeName.text,timeFormatted);
                
                // unhighlight the task button
                UIButton *selectedBtn;
                if ([[nowArr objectAtIndex:3] integerValue] < 1700 )
                {
                    selectedBtn = (UIButton *)[taskList viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
                } else {
                    // for alias button (Personal-Socializing/chtting)
                    if ([[nowArr objectAtIndex:3] integerValue] == 1906)
                    {
                        selectedBtn = (UIButton *)[taskList viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
                        [selectedBtn setSelected:NO];
                    }

                    selectedBtn = (UIButton *)[taskList2 viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
                }
                [selectedBtn setSelected:NO];
                
                NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
                
                // put this information into the export array
                NSArray *tempStorage = [[NSArray alloc] initWithObjects:[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
                [exportArr addObject:tempStorage];
                if(exportArr.count > 0){
                    NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
                }
                
                NSIndexPath *delCellPath = [NSIndexPath indexPathForRow:1 inSection:0];
                
                
                [activeAct removeObjectAtIndex:1];
                [tableView deleteRowsAtIndexPaths:@[delCellPath] withRowAnimation:UITableViewRowAnimationFade];
            }

        }
    }
}

- (void)progEndTask:(NSTimer*)theTimer{
    NSString *tag = (NSString *)[theTimer userInfo];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
    [dateFormatterD setDateFormat:@"MMddyyyy"];
    NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
    NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
    
    for(int i = 0; i<activeAct.count; i++){
        NSArray *curArr = [activeAct objectAtIndex:i];
        NSString *curTaskId = [curArr objectAtIndex:3];
        NSString *buttonTag = tag;
        //NSLog(@"button clicked: %@, original: %@",buttonTag, curTaskId);
        if([curTaskId isEqualToString:buttonTag] == YES){
            //button.titleLabel.text = [[NSString alloc] initWithFormat:@"%d",i];
            NSArray *selArr = [activeAct objectAtIndex:i];
            NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[selArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
            // put this information into the export array
            NSArray *tempStorage = [[NSArray alloc] initWithObjects:[selArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
            [exportArr addObject:tempStorage];
            if(exportArr.count > 0){
                NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
            }
            
            NSIndexPath *delCellPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            
            [activeAct removeObjectAtIndex:i];
            // unhighlight the task button
            UIButton *btnToUnselect;
            if ([tag integerValue] < 1700 )
            {
                btnToUnselect = (UIButton *)[taskList viewWithTag: [tag integerValue]];
            } else {
                // for alias button (Personal-Socializing/chtting)
                if ([tag integerValue] == 1906)
                {
                    btnToUnselect = (UIButton *)[taskList viewWithTag: [tag integerValue]];
                    [btnToUnselect setSelected:NO];
                }

                btnToUnselect = (UIButton *)[taskList2 viewWithTag: [tag integerValue]];
            }
            [btnToUnselect setSelected:NO];
            break;
        }else{
        }
    }
}
- (IBAction)triggerTask:(id)sender {
//    if([self.lblLocation.text isEqualToString:@"-"]){
    if([self.btnLocation.titleLabel.text isEqualToString:@"-"]){
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to select location first!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
        [error release];

        // scroll to location page
        [self scrollToPage:0];
    }else{
        UIButton *button = (UIButton *) sender;
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
        [dateFormatterD setDateFormat:@"MMddyyyy"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
        NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
        NSString *tagNum = [NSString stringWithFormat:@"%d", button.tag];
        NSArray *curSel = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",(int)globalCounter],button.titleLabel.text, timeFormatted, tagNum, nil];
        //
        UIImage *btnBg = nil;
        if(button.tag >= 1000 && button.tag < 1100){
            btnBg = [UIImage imageNamed:@"colorCat6.png"];
        }else if(button.tag >= 1100 && button.tag < 1200){
            btnBg = [UIImage imageNamed:@"colorCat9.png"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }else if(button.tag >= 1200 && button.tag < 1300){
            btnBg = [UIImage imageNamed:@"colorCat5.png"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }else if(button.tag >= 1300 && button.tag < 1400){
            btnBg = [UIImage imageNamed:@"colorCat7.png"];
        }else if(button.tag >= 1400 && button.tag < 1500){
            btnBg = [UIImage imageNamed:@"colorCat4.png"];
        }else if(button.tag >= 1500 && button.tag < 1600){
            btnBg = [UIImage imageNamed:@"colorCat2.png"];
        }else if(button.tag >= 1600 && button.tag < 1700){
            btnBg = [UIImage imageNamed:@"colorCat3.png"];
        }else if(button.tag >= 1700 && button.tag < 1800){
            btnBg = [UIImage imageNamed:@"colorCat8.png"];
        }else if(button.tag >= 1800 && button.tag < 1900){
            btnBg = [UIImage imageNamed:@"colorCat10.png"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }else if(button.tag >= 1900 && button.tag < 2000){
            btnBg = [UIImage imageNamed:@"colorCat11.png"];
        }else if(button.tag >= 2000 && button.tag < 2100){
            btnBg = [UIImage imageNamed:@"colorCat12.png"];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }else{
            btnBg = [UIImage imageNamed:@"colorCat1.png"];
        }
        [button setBackgroundImage:btnBg forState:UIControlStateSelected];
        
            if(isMultitasking.isOn == YES){ // if the multitasking mode is on
                if(button.selected == YES){ // if the button is already highlighted
                    [button setSelected:NO];
                    
                    // for alias button (Personal-Socializing/chtting)
                    if (button.tag == 1906)
                    {
                        if ([button.titleLabel.text isEqual: @"Personal - Socializing/chatting"]) {
                            button = (UIButton *)[taskList2 viewWithTag: 1906];
                        } else {
                            button = (UIButton *)[taskList viewWithTag: 1906];
                        }
                        [button setSelected:NO];
                        [button setBackgroundImage:btnBg forState:UIControlStateSelected];
                    }

                    // gets the current time
                    NSDate *currentDate = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                    NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
                    [dateFormatterD setDateFormat:@"MMddyyyy"];
                    
                    NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
                    NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
                    
                    for(int i = 0; i<activeAct.count; i++){
                        NSArray *curArr = [activeAct objectAtIndex:i];
                        NSString *curTaskId = [curArr objectAtIndex:3];
                        NSString *buttonTag = [[NSString alloc] initWithFormat:@"%d", button.tag];
                        //NSLog(@"button clicked: %@, original: %@",buttonTag, curTaskId);
                        if([curTaskId isEqualToString:buttonTag] == YES){
                            //button.titleLabel.text = [[NSString alloc] initWithFormat:@"%d",i];
                            NSArray *selArr = [activeAct objectAtIndex:i];
                            NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[selArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
                            // put this information into the export array
                            NSArray *tempStorage = [[NSArray alloc] initWithObjects:[selArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
                            [exportArr addObject:tempStorage];
                            if(exportArr.count > 0){
                                NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
                            }
                            
                            NSIndexPath *delCellPath = [NSIndexPath indexPathForRow:i inSection:0];
                            
                            
                            [activeAct removeObjectAtIndex:i];
                            [tableView deleteRowsAtIndexPaths:@[delCellPath] withRowAnimation:UITableViewRowAnimationFade];
                            break;
                        }else{
                            //button.titleLabel.text = @"meh";
                        }
                    }
                    
                    
                    
                }else{ // if the button is not highlighted
                    [button setSelected:YES];
                    
                    // for alias button (Personal-Socializing/chtting)
                    if (button.tag == 1906)
                    {
                        if ([button.titleLabel.text isEqual: @"Personal - Socializing/chatting"]) {
                            button = (UIButton *)[taskList2 viewWithTag: 1906];
                        } else {
                            button = (UIButton *)[taskList viewWithTag: 1906];
                        }
                        [button setSelected:YES];
                        [button setBackgroundImage:btnBg forState:UIControlStateSelected];
                    }


                    
                    // code for the tasks that only lasts for a second
                    // 여기에 추가 task 버튼 tag 넣어주세요

// for flashing events -> removed
//                    if(button.tag == 1202 || button.tag == 1301 || button.tag == 1316){
//                        NSLog(@"%@,%@,%d,%@,%@,%@,%@,%@",[NSString stringWithFormat:@"%d",(int)globalCounter],@"creation",button.tag,self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text);
//                        NSArray *tempStorage = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", (int)globalCounter],@"creation",[NSString stringWithFormat:@"%d",button.tag],self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text, nil];
//                        [exportArr addObject:tempStorage];
//                        if(exportArr.count > 0){
//                            NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
//                        }
//                        globalCounter = (NSInteger *) ((int)globalCounter + 1);
//                        [activeAct insertObject:curSel atIndex:0];
//                        
//                        // delete the currently selected task after 1 second
//                        NSTimer *delTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progEndTask:) userInfo:[[NSString alloc] initWithFormat:@"%d",button.tag] repeats:NO];
//                        
//
//                    }else{
                        // makes a log in the console
                        //        NSLog(@"%@,%@,%d,%@,%@,%@",timeFormatted,self.lblLocation.text,button.tag,self.observerName.text,self.observeeName.text,@"n/a");
                        NSLog(@"%@,%@,%d,%@,%@,%@,%@,%@",[NSString stringWithFormat:@"%d",(int)globalCounter],@"creation",button.tag,self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text);
                        
                        // put this information into the export array
                        NSArray *tempStorage = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", (int)globalCounter],@"creation",[NSString stringWithFormat:@"%d",button.tag],self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text, nil];
                        [exportArr addObject:tempStorage];
                        if(exportArr.count > 0){
                            NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
                        }
                        globalCounter = (NSInteger *) ((int)globalCounter + 1);
                        [activeAct insertObject:curSel atIndex:0];
                        [tableView reloadData];
//                    }
                    
                    
                }
            }else{ // multitasking mode off
                if(button.selected == NO){
                    if([activeAct count]!=0){
                        [self allTasksDone:nil];
                    }
                    [button setSelected:YES];
                    
                    // for alias button (Personal-Socializing/chtting)
                    if (button.tag == 1906)
                    {
                        if ([button.titleLabel.text isEqual: @"Personal - Socializing/chatting"]) {
                            button = (UIButton *)[taskList2 viewWithTag: 1906];
                        } else {
                            button = (UIButton *)[taskList viewWithTag: 1906];
                        }
                        [button setSelected:YES];
                        [button setBackgroundImage:btnBg forState:UIControlStateSelected];
                    }

                    // code for the tasks that only lasts for a second
                    // 여기에 추가 task 버튼 tag 넣어주세요

// for flashing events -> removed 
//                    if(button.tag == 1202 || button.tag == 1301 || button.tag == 1316){
//                        NSLog(@"%@,%@,%d,%@,%@,%@,%@,%@",[NSString stringWithFormat:@"%d",(int)globalCounter],@"creation",button.tag,self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text);
//                        NSArray *tempStorage = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", (int)globalCounter],@"creation",[NSString stringWithFormat:@"%d",button.tag],self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text, nil];
//                        [exportArr addObject:tempStorage];
//                        if(exportArr.count > 0){
//                            NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
//                        }
//                        globalCounter = (NSInteger *) ((int)globalCounter + 1);
//                        [activeAct insertObject:curSel atIndex:0];
//                        
//                        // delete the currently selected task after 1 second
//                        NSTimer *delTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progEndTask:) userInfo:[[NSString alloc] initWithFormat:@"%d",button.tag] repeats:NO];
//                        
//                    }else{
                        // makes a log in the console
                        //        NSLog(@"%@,%@,%d,%@,%@,%@",timeFormatted,self.lblLocation.text,button.tag,self.observerName.text,self.observeeName.text,@"n/a");
                        NSLog(@"%@,%@,%d,%@,%@,%@,%@,%@",[NSString stringWithFormat:@"%d",(int)globalCounter],@"creation",button.tag,self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text);
                        
                        // put this information into the export array
                        NSArray *tempStorage = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", (int)globalCounter],@"creation",[NSString stringWithFormat:@"%d",button.tag],self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,self.observerName.text,self.observeeName.text, nil];
                        [exportArr addObject:tempStorage];
                        if(exportArr.count > 0){
                            NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
                        }
                        globalCounter = (NSInteger *) ((int)globalCounter + 1);
                        [activeAct insertObject:curSel atIndex:0];
                        [tableView reloadData];
//                    }
                    
                }else{
                    [button setSelected:NO];

                    // for alias button (Personal-Socializing/chtting)
                    if (button.tag == 1906)
                    {
                        if ([button.titleLabel.text isEqual: @"Personal - Socializing/chatting"]) {
                            button = (UIButton *)[taskList2 viewWithTag: 1906];
                        } else {
                            button = (UIButton *)[taskList viewWithTag: 1906];
                        }
                        [button setSelected:NO];
                        [button setBackgroundImage:btnBg forState:UIControlStateSelected];
                    }

                    // gets the current time
                    NSDate *currentDate = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                    NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
                    [dateFormatterD setDateFormat:@"MMddyyyy"];
                    
                    NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
                    NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
                    
                    //button.titleLabel.text = [[NSString alloc] initWithFormat:@"%d",i];
                    NSArray *selArr = [activeAct objectAtIndex:0];
                    NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[selArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
                    // put this information into the export array
                    NSArray *tempStorage = [[NSArray alloc] initWithObjects:[selArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
                    [exportArr addObject:tempStorage];
                    if(exportArr.count > 0){
                        NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
                    }
                    NSIndexPath *delCellPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [activeAct removeObjectAtIndex:0];
                    [tableView deleteRowsAtIndexPaths:@[delCellPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
    }
}

- (IBAction)allTasksDone:(id)sender {
    for(int i = 0; i<activeAct.count; i++){
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
        [dateFormatterD setDateFormat:@"MMddyyyy"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
        NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];

        NSArray *nowArr = [activeAct objectAtIndex:i];
        //NSLog(@"%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:1],self.lblLocation.text,[nowArr objectAtIndex:2],self.observerName.text,self.observeeName.text,timeFormatted);
        
        // unhighlight the task button
        UIButton *selectedBtn;
        if ([[nowArr objectAtIndex:3] integerValue] < 1700 )
        {
            selectedBtn = (UIButton *)[taskList viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
        } else {
            // for alias button (Personal-Socializing/chtting)
            if ([[nowArr objectAtIndex:3] integerValue] == 1906)
            {
                selectedBtn = (UIButton *)[taskList viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
                [selectedBtn setSelected:NO];
            }
            
            selectedBtn = (UIButton *)[taskList2 viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
        }
        [selectedBtn setSelected:NO];
        
        NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
        
        // put this information into the export array
        NSArray *tempStorage = [[NSArray alloc] initWithObjects:[nowArr objectAtIndex:0],@"end of task",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
        [exportArr addObject:tempStorage];
        if(exportArr.count > 0){
            NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
        }
    }
    [activeAct removeAllObjects];
    [tableView reloadData];
    
}
-(void) interruptTimer:(NSTimer *)theTimer{
    NSString *tag = (NSString *)[theTimer userInfo];
    int targetId = -1;
    
    for(int i = 0; i<activeAct.count; i++){
        NSArray *curArr = [activeAct objectAtIndex:i];
        NSString *curTaskId = [curArr objectAtIndex:3];
        NSString *buttonTag = tag;
        //NSLog(@"button clicked: %@, original: %@",buttonTag, curTaskId);
        if([curTaskId isEqualToString:buttonTag] == YES){
            targetId = i;
            break;
        }else{
        }
    }
    if(targetId > -1){
        UITableViewCell *targetCell = (UITableViewCell *)[(UITableView *)tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetId inSection:0]];
        UILabel *targetCellLabel = (UILabel *)[targetCell viewWithTag:102];
        [targetCellLabel setTextColor:[UIColor blackColor]];
        [tableView reloadData];
        
    }else{
        NSLog(@"Warning: the task is already terminated");
    }
}
- (IBAction)interrupt:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIImage *imgTest = [UIImage imageNamed:@"fill_red.png"];
    [btn setBackgroundImage:imgTest forState:UIControlStateSelected];
    
    if([btn isSelected]==YES){
        //[btn setSelected:NO];
    }else{
        if([activeAct count] != 0){
            //[btn setSelected:YES];
            
            UITableViewCell *topCell = (UITableViewCell *)[(UITableView *)tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UILabel *topCellLabel = (UILabel *)[topCell viewWithTag:102];
            [topCellLabel setTextColor:[UIColor redColor]];
            topCellLabel.text = [[NSString alloc] initWithFormat:@"(INTERRUPTING)%@",topCellLabel.text];
            
                NSDate *currentDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
                [dateFormatterD setDateFormat:@"MMddyyyy"];
                NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
                NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
                
                NSArray *nowArr = [activeAct objectAtIndex:0];
            
            NSTimer *setTimerToRevert = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(interruptTimer:) userInfo:[nowArr objectAtIndex:3] repeats:NO];
                NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"interruption",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
                
                [interruptBtn setSelected:NO];
                
                // put this information into the export array
                NSArray *tempStorage = [[NSArray alloc] initWithObjects:[nowArr objectAtIndex:0],@"interruption",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
                [exportArr addObject:tempStorage];
                if(exportArr.count > 0){
                    NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
                }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:@"There is no active task that can be interrupted!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

- (IBAction)changeLocCody:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *prefix;
    
    if(button.tag >= 1000 && button.tag < 1100){
        prefix = @"Rece";
    }else if(button.tag >= 1100 && button.tag < 1200){
        prefix = @"WP";
    }else if(button.tag >= 1200 && button.tag < 1300){
        prefix = @"NP";
    }else if(button.tag >= 1300 && button.tag < 1400){
        prefix = @"Ped";
    }else if(button.tag >= 1400 && button.tag < 1500){
        prefix = @"SP";
    }else if(button.tag >= 1500 && button.tag < 1600){
        prefix = @"Infu";
    }else if(button.tag >= 1600 && button.tag < 1700){
        prefix = @"PhyT";
    }else if(button.tag >= 1700 && button.tag < 1800){
        prefix = @"Other";
    }else{
        prefix = @"Error_CheckTheList";
    }
    
    [self.btnLocation setTitle:[NSString stringWithFormat:@"%@_%@", prefix, button.titleLabel.text] forState:UIControlStateNormal];
    NSString *navTitle = [[NSString alloc] initWithFormat:@"Select Task (%@)",button.titleLabel.text];
    globalLocation = button.titleLabel.text;
    // runs a method that updates the current array of active tasks
    if(activeAct.count == 0){
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }else{
        [self updateLocationOfArray:sender];
        //[self.taskBar.topItem setTitle:navTitle];
        [self scrollToPage:1];
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSDateFormatter *dateFormatterD = [[NSDateFormatter alloc] init];
        [dateFormatterD setDateFormat:@"MMddyyyy"];
        NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
        NSString *dateFormatted = [dateFormatterD stringFromDate:currentDate];
        
        NSArray *nowArr = [activeAct objectAtIndex:indexPath.row];
//        NSLog(@"%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:1],self.lblLocation.text, [nowArr objectAtIndex:2], self.observerName.text, self.observeeName.text,@"canceled");
        // unhighlight the task button
        UIButton *selectedBtn;
        if ([[nowArr objectAtIndex:3] integerValue] < 1700 )
        {
            selectedBtn = (UIButton *)[taskList viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
        } else {
            selectedBtn = (UIButton *)[taskList2 viewWithTag: [[nowArr objectAtIndex:3] integerValue]];
        }
        [selectedBtn setSelected:NO];
        
        
        NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[nowArr objectAtIndex:0],@"cancellation",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"");
        
        // put this information into the export array
        NSArray *tempStorage = [[NSArray alloc] initWithObjects:[nowArr objectAtIndex:0],@"cancellation",@"",self.btnLocation.titleLabel.text,dateFormatted,timeFormatted,@"",@"", nil];
        [exportArr addObject:tempStorage];
        if(exportArr.count > 0){
            NSLog(@"successfully stored the current action. # of items: %d", [exportArr count]);
        }
        [activeAct removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(IBAction) saveData:(id)sender {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddyyyy-HHmmss"];
    NSString *timeFormatted = [dateFormatter stringFromDate:currentDate];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *observerDeHyp = [observerName.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *observeeDeHyp = [observeeName.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *observeSiteDeHyp = [observeSite.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@-%@-%@.plist",timeFormatted,observeSiteDeHyp,observerDeHyp,observeeDeHyp]];
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:exportArr format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData){
        [plistData writeToFile:plistPath atomically:YES];
        // write meta data. could we change it in a way it appends to the existing file?
        NSString *observerDeHyp = [observerName.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *observeeDeHyp = [observeeName.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *observeSiteDeHyp = [observeSite.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *plistPathMeta = [documentsPath stringByAppendingPathComponent:@"metaData.plist"];
        NSString *errorMeta = nil;
        
        BOOL metaExists = [[NSFileManager defaultManager] fileExistsAtPath:plistPathMeta];
        
        NSMutableArray *metaInfo = [[NSMutableArray alloc] init];
        
        if(metaExists == YES){
            metaInfo = [[NSMutableArray alloc] initWithContentsOfFile: plistPathMeta];
            [metaInfo addObject: [NSString stringWithFormat:@"%@-%@-%@-%@.plist",timeFormatted,observeSiteDeHyp,observerDeHyp,observeeDeHyp]];
        }else{
            metaInfo = [[NSMutableArray alloc] initWithObjects: [NSString stringWithFormat:@"%@-%@-%@-%@.plist",timeFormatted,observeSiteDeHyp,observerDeHyp,observeeDeHyp], nil];
        }
        
        
        NSData *plistDataMeta = [NSPropertyListSerialization dataFromPropertyList: metaInfo format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorMeta];

        if(plistDataMeta){
            [plistDataMeta writeToFile:plistPathMeta atomically:YES];
        }else{
            NSLog(@"Error in saving meta data: %@", errorMeta);
        }
    }else{
        NSLog(@"Error in savedata: %@", error);
    }
}


-(IBAction) sendToFTP:(id)sender {
    
}
@end
