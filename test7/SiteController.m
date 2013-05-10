//
//  SiteController.m
//  test7
//
//  Created by Joosung Kim on 4/27/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import "SiteController.h"

@interface SiteController ()

-(IBAction) changeObserverName:(id)sender;
-(IBAction) changeObserveSite:(id)sender;

@end

@implementation SiteController

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

- (IBAction)changeObserverName:(id)sender {
    UIButton *button = (UIButton *)sender;
//    vController.observerName.text = [NSString stringWithFormat:@"%@", button.titleLabel.text];
}
- (IBAction)changeObserverSite:(id)sender {
    UIButton *button = (UIButton *)sender;
//    vController.observeSite.text = [NSString stringWithFormat:@"%@", button.titleLabel.text];
}

@end
