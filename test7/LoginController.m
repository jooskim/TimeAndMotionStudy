//
//  LoginController.m
//  test7
//
//  Created by Joosung Kim on 4/27/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import "LoginController.h"
#import "ViewController.h"

@interface LoginController ()
@property (retain, nonatomic) IBOutlet UILabel *obsSite;
@property (retain, nonatomic) IBOutlet UILabel *floor;
@property (retain, nonatomic) IBOutlet UILabel *obsRA;
- (IBAction)changeSite:(id)sender;
- (IBAction)changeFloor:(id)sender;
- (IBAction)changeRA:(id)sender;


- (IBAction)startObs:(id)sender;

@end

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_obsSite release];
    [_floor release];
    [_obsRA release];
    [super dealloc];
}

- (IBAction)changeSite:(id)sender {
    UIButton *button = (UIButton *) sender;
    self.obsSite.text = [[NSString alloc] initWithFormat:@"%@", button.titleLabel.text];
}

- (IBAction)changeFloor:(id)sender {
    UIButton *button = (UIButton *) sender;
    self.floor.text = [[NSString alloc] initWithFormat:@"%@", button.titleLabel.text];
}

- (IBAction)changeRA:(id)sender {
    UIButton *button = (UIButton *) sender;
    self.obsRA.text = [[NSString alloc] initWithFormat:@"%@", button.titleLabel.text];
}

- (IBAction)startObs:(id)sender {
    NSString *noneSel = @"-";
    

    if ([noneSel isEqualToString:self.obsSite.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:@"You have to select an observing site!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else if([noneSel isEqualToString:self.floor.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:@"You have to select a floor where the observation takes place!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else if([noneSel isEqualToString:self.obsRA.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:@"You have to select an observer!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loginSegue"]){
        ViewController *mainView = (ViewController *)segue.destinationViewController;
        mainView.valObsSite = self.obsSite.text;
        mainView.valObsName = self.obsRA.text;
        mainView.valObsFloor = self.floor.text;
    }
}


@end
