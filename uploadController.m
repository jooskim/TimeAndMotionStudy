//
//  uploadController.m
//  test7
//
//  Created by Joosung Kim on 5/23/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import "uploadController.h"

@interface uploadController ()

@end

@implementation uploadController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize dataList,tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataList = [[NSMutableArray alloc] init];
    [self loadMetaData:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return dataList.count;
}


-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }

    cell.textLabel.text = [dataList objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dataList objectAtIndex:indexPath.row]]];
        NSError *error;
        if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error]){
            NSLog(@"Error deleting plist: %@",error);
        }
        
        NSString *plistPathMeta = [documentsDirectory stringByAppendingPathComponent:@"metaData.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPathMeta])
        {
            // if not in documents, get property list from main bundle CHECK D capitalisation
            plistPathMeta = [[NSBundle mainBundle] pathForResource:@"metaData" ofType:@"plist"];
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPathMeta];
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        // convert static property list into dictionary object
        NSMutableArray *arrayTemp = (NSMutableArray *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        if (!arrayTemp)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }else{
            int indexToDelete = [arrayTemp indexOfObject:[NSString stringWithFormat:@"%@",[dataList objectAtIndex:indexPath.row]]];
            [arrayTemp removeObjectAtIndex:indexToDelete];
            NSData *newPlistDataMeta = [NSPropertyListSerialization dataFromPropertyList: arrayTemp format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
            if(newPlistDataMeta){
                [newPlistDataMeta writeToFile:plistPathMeta atomically:YES];
                NSLog(@"Row %d deleted from metaData.plist",indexToDelete);
            }else{
                NSLog(@"Error in updating metaData.plist");
            }
            
            [dataList removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

    
    }
}

-(IBAction)toggleEdit:(id)sender{
    if([tableView isEditing]){
        [tableView setEditing:NO animated:YES];
        [self.editButton setTitle: @"Edit"];
    }else{
        [tableView setEditing:YES animated:YES];
        [self.editButton setTitle: @"Done"];
    }

}
-(void) loadMetaData:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"metaData.plist"];
    
    // check to see if data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle CHECK D capitalisation
        plistPath = [[NSBundle mainBundle] pathForResource:@"metaData" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSMutableArray *arrayTemp = (NSMutableArray *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!arrayTemp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }else{
        int i = 0;
        for(i=0; i<arrayTemp.count; i++){
            [dataList addObject: [arrayTemp objectAtIndex:i]];
        }
        NSLog(@"%d",[arrayTemp count]);
    }
    
}


- (void)dealloc {
    [_editButton release];
    [super dealloc];
}
@end
