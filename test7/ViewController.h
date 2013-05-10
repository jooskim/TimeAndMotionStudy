//
//  ViewController.h
//  test7
//
//  Created by Joosung Kim on 4/26/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *observerName;
    IBOutlet UILabel *observeSite;
    IBOutlet UILabel *observeFloor;
    
}


@property (retain, nonatomic) IBOutlet UILabel *observerName;
@property (nonatomic) NSString *valObsName;
@property (retain, nonatomic) IBOutlet UILabel *observeSite;
@property (nonatomic) NSString *valObsSite;
@property (retain, nonatomic) IBOutlet UILabel *observeFloor;
@property (nonatomic) NSString * valObsFloor;
@property (retain, nonatomic) IBOutlet UILabel *lblLocation;

- (IBAction)changeLocation:(id)sender;
@property (retain, nonatomic) IBOutlet UINavigationItem *detailTitle;
@property (retain, nonatomic) IBOutlet UIView *partialV4;
@property (retain, nonatomic) IBOutlet UIView *partialV3;
@property (retain, nonatomic) IBOutlet UIView *partialV2;
@property (retain, nonatomic) IBOutlet UIView *partialV1;
- (IBAction)taskComp:(id)sender;
- (IBAction)taskPaper:(id)sender;
- (IBAction)taskInteraction:(id)sender;
- (IBAction)endObservation:(id)sender;



-(IBAction) changeLabelLocation_exam:(id)sender;
-(IBAction) changeLabelLocation_office:(id)sender;
-(IBAction) changeLabelLocation_procedure:(id)sender;
-(IBAction) changeLabelLocation_nurse:(id)sender;
-(IBAction) changeLabelLocation_lab:(id)sender;
-(IBAction) changeLabelLocation_other:(id)sender;

@end
