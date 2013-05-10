//
//  DetailTaskController.m
//  test7
//
//  Created by Joosung Kim on 4/27/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import "DetailTaskController.h"

@interface DetailTaskController ()
@property (retain, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (retain, nonatomic) IBOutlet UIView *locationPartialView;

@end

@implementation DetailTaskController

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
    [_titleBar release];
    [_locationPartialView release];
    [super dealloc];
}
@end
