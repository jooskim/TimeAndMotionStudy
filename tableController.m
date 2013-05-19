//
//  tableController.m
//  test7
//
//  Created by Joosung Kim on 5/18/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import "tableController.h"

@interface tableController ()

@end

@implementation tableController {
    // Array for active activities
    NSArray *activeAct;
}

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
    activeAct = [NSArray arrayWithObjects:@"test1",@"test2",@"test3", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UILabel *activityTime = (UILabel *)[cell viewWithTag:103];
    return cell;
}
@end
