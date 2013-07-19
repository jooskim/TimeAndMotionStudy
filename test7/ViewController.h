//
//  ViewController.h
//  test7
//
//  Created by Joosung Kim on 4/26/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *observerName;
    IBOutlet UILabel *observeeName;
    IBOutlet UILabel *observeSite;
    IBOutlet UIButton *btnLocation;
}


@property (nonatomic) NSString *valObsName;
@property (nonatomic) NSString *valObsEEName;
@property (nonatomic) NSString *valObsSite;

@property (retain, nonatomic) IBOutlet UILabel *observerName;
@property (retain, nonatomic) IBOutlet UILabel *observeeName;
@property (retain, nonatomic) IBOutlet UILabel *observeSite;
@property (retain, nonatomic) IBOutlet UILabel *lblLocation;
@property (retain, nonatomic) IBOutlet UIButton *btnLocation;
@property (retain, nonatomic) IBOutlet UINavigationItem *detailTitle;
@property (retain, nonatomic) IBOutlet UIView *partialV4;
@property (retain, nonatomic) IBOutlet UIView *partialV3;
@property (retain, nonatomic) IBOutlet UIView *partialV2;
@property (retain, nonatomic) IBOutlet UIView *partialV1;
@property (retain, nonatomic) IBOutlet UIView *activityContainer;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISwitch *isMultitasking;
@property (retain, nonatomic) IBOutlet UIButton *interruptBtn;
@property (strong, nonatomic) NSMutableArray *activeAct;
@property (retain, nonatomic) NSString *globalLocation;
@property (retain, nonatomic) NSMutableArray *exportArr;
@property (retain, nonatomic) NSDate *nowDate;

- (IBAction)changeLocation:(id)sender;
- (IBAction)taskComp:(id)sender;
- (IBAction)taskPaper:(id)sender;
- (IBAction)taskInteraction:(id)sender;
- (IBAction)endObservation:(id)sender;
- (IBAction)changeViewTask:(id)sender;
- (IBAction)changeViewLocation:(id)sender;
- (IBAction)triggerTask:(id)sender;
- (IBAction)allTasksDone:(id)sender;
- (IBAction)interrupt:(id)sender;

- (IBAction)changeLocCody:(id)sender;
- (IBAction)changeLocMiles:(id)sender;
- (IBAction)changeLocCC:(id)sender;

-(IBAction) changeLabelLocation_exam:(id)sender;
-(IBAction) changeLabelLocation_office:(id)sender;
-(IBAction) changeLabelLocation_procedure:(id)sender;
-(IBAction) changeLabelLocation_nurse:(id)sender;
-(IBAction) changeLabelLocation_lab:(id)sender;
-(IBAction) changeLabelLocation_other:(id)sender;
-(IBAction) saveData:(id)sender;
-(IBAction) deleteData:(id)sender;
-(IBAction) sendToFTP:(id)sender;

@end
