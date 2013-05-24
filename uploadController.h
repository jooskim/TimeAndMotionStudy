//
//  uploadController.h
//  test7
//
//  Created by Joosung Kim on 5/23/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uploadController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataList;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *editButton;

-(IBAction)toggleEdit:(id)sender;
@end
