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

@end

@implementation ViewController
NSArray *activeAct;

@synthesize scrollView, taskList, locationList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [scrollView addSubview: self.taskList];
    [scrollView setContentSize:self.taskList.frame.size];
    self.observerName.text = self.valObsName;
    self.observeeName.text = self.valObsEEName;
    self.observeSite.text = self.valObsSite;
    self.observeFloor.text = self.valObsFloor;
    
}

- (void)viewDidLayoutSubviews
{
    activeAct = [NSArray arrayWithObjects:@"test1",@"test2",@"test3",@"buwak", nil];

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
    [observeFloor release];
    [_headerMain release];
    [_activityContainer release];
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

- (IBAction)triggerTask:(id)sender {
    if([self.lblLocation.text isEqualToString:@"-"]){
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to select location first!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
        [error release];
    }
}


@synthesize lblLocation;
@synthesize observerName;
@synthesize observeeName;
@synthesize observeSite;

- (IBAction)changeLabelLocation_exam:(id)sender {
    UIButton *button = (UIButton *)sender;
    lblLocation.text = [NSString stringWithFormat:@"Exam Room %@", button.titleLabel.text];
}
- (IBAction)changeLabelLocation_office:(id)sender {
    UIButton *button = (UIButton *)sender;
    lblLocation.text = [NSString stringWithFormat:@"Office %@", button.titleLabel.text];
}
- (IBAction)changeLabelLocation_procedure:(id)sender {
    UIButton *button = (UIButton *)sender;
    lblLocation.text = [NSString stringWithFormat:@"Procedure Room %@", button.titleLabel.text];
}
- (IBAction)changeLabelLocation_nurse:(id)sender {
    UIButton *button = (UIButton *)sender;
    lblLocation.text = [NSString stringWithFormat:@"Nurse Station %@", button.titleLabel.text];
}
- (IBAction)changeLabelLocation_lab:(id)sender {
    UIButton *button = (UIButton *)sender;
    lblLocation.text = [NSString stringWithFormat:@"Lab %@", button.titleLabel.text];
}
- (IBAction)changeLabelLocation_other:(id)sender {
    UIButton *button = (UIButton *)sender;
    lblLocation.text = [NSString stringWithFormat:@"%@", button.titleLabel.text];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex]){
        NSLog(@"Cancel");
    }else{
        [self performSegueWithIdentifier:@"logoutSegue" sender: self];
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [activeAct count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    
    UILabel *activityName = (UILabel *)[cell viewWithTag:102];
    activityName.text = [activeAct objectAtIndex:indexPath.row];

    //UILabel *activityTime = (UILabel *)[cell viewWithTag:103];

    
    //test code
    //cell.textLabel.text = [activeAct objectAtIndex:indexPath.row];
    return cell;
}

@end
