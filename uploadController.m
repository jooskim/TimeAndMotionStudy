//
//  uploadController.m
//  test7
//
//  Created by Joosung Kim on 5/23/13.
//  Copyright (c) 2013 Joosung Kim. All rights reserved.
//

#import "uploadController.h"
#import "NetworkManager.h"
#include <CFNetwork/CFNetwork.h>

enum {
    kSendBufferSize = 32768
};

@interface uploadController () <NSStreamDelegate>

// things for IB

@property (nonatomic, strong, readwrite) IBOutlet UITextField *               urlText;
@property (nonatomic, strong, readwrite) IBOutlet UITextField *               usernameText;
@property (nonatomic, strong, readwrite) IBOutlet UITextField *               passwordText;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *                   statusLabel;
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView *   activityIndicator;
@property (nonatomic, strong, readwrite) IBOutlet UIBarButtonItem *           cancelButton;

- (IBAction)sendAction:(UIView *)sender;
- (IBAction)cancelAction:(id)sender;

// Properties that don't need to be seen by the outside world.

@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;



@end

@implementation uploadController
{
    uint8_t                     _buffer[kSendBufferSize];
}

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@ selected", cell.textLabel.text);
    
    // Show the confirmation.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: NSLocalizedString(@"Upload Observation Data",nil)
                          message: [NSString stringWithFormat: @"Are you sure you want to upload %@?", cell.textLabel.text]
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"Cancel",nil)
                          otherButtonTitles: NSLocalizedString(@"Upload",nil), nil];
    [alert show];
    [alert release];
    
}


// Called when an alertview button is touched
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            // NSLog(@"Cancel button clicked by the user");
        }
            break;
            
        case 1:
        {
            //NSLog(@"Upload button clicked by the user");
            
            // Upload the data
            //    assert( [sender isKindOfClass:[UIView class]] );
            
            if ( ! self.isSending ) {
                NSString *  filePath;
                
                // User the tag on the UIButton to determine which image to send.
                
                //        assert(sender.tag >= 0);
                //        filePath = [[NetworkManager sharedInstance] pathForTestImage:(NSUInteger) sender.tag];
                //        assert(filePath != nil);
                
                NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
                //                NSLog(@"%@", cell.textLabel.text);
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0];
                filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", cell.textLabel.text]];
                
                [self startSend:filePath];
            }
            
        }
            break;
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




//------------------------------------------------------------------------------------------------
#pragma mark * Status management

// These methods are used by the core transfer code to update the UI.

- (void)sendDidStart
{
    self.statusLabel.text = @"Sending";
    self.cancelButton.enabled = YES;
    [self.activityIndicator startAnimating];
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void)updateStatus:(NSString *)statusString
{
    assert(statusString != nil);
    self.statusLabel.text = statusString;
}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"File upload succeeded";
    }
    
    // Show success alert message
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: statusString
                          message: nil
                          delegate: self
                          cancelButtonTitle: nil
                          otherButtonTitles: @"OK",nil, nil];
    [alert show];
    [alert release];
    
    self.statusLabel.text = statusString;
    self.cancelButton.enabled = NO;
    [self.activityIndicator stopAnimating];
    [[NetworkManager sharedInstance] didStopNetworkOperation];
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

// Because buffer is declared as an array, you have to use a custom getter.
// A synthesised getter doesn't compile.

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (BOOL)isSending
{
    return (self.networkStream != nil);
}

- (void)startSend:(NSString *)filePath
{
    BOOL                    success;
    NSURL *                 url;
    
    assert(filePath != nil);
    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    //    assert( [filePath.pathExtension isEqual:@"png"] || [filePath.pathExtension isEqual:@"jpg"] );
    
    assert(self.networkStream == nil);      // don't tap send twice in a row!
    assert(self.fileStream == nil);         // ditto
    
    // First get and check the URL.d
    
    //    url = [[NetworkManager sharedInstance] smartURLForString:self.urlText.text];
    url = [NSURL URLWithString:@"ftp://jayjeong%40kpcaa.us:tnmstudy2013!@kpcaa.us"];
    success = (url != nil);
    
    if (success) {
        // Add the last part of the file name to the end of the URL to form the final
        // URL that we're going to put to.
        
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                                );
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        //        self.statusLabel.text = @"Invalid URL";
        NSLog(@"Invalid URL");
    } else {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a CFFTPStream for the URL.
        
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        assert(self.networkStream != nil);
        
        if ([self.usernameText.text length] != 0) {
            success = [self.networkStream setProperty:self.usernameText.text forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            success = [self.networkStream setProperty:self.passwordText.text forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
        }
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Tell the UI we're sending.
        
        //        [self sendDidStart];
    }
}

- (void)stopSendWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self sendDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            [self updateStatus:@"Sending"];
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self stopSendWithStatus:@"File read error"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

#pragma mark * Actions

- (IBAction)sendAction:(UIView *)sender
{
    assert( [sender isKindOfClass:[UIView class]] );
    
    if ( ! self.isSending ) {
        NSString *  filePath;
        
        // User the tag on the UIButton to determine which image to send.
        
        assert(sender.tag >= 0);
        filePath = [[NetworkManager sharedInstance] pathForTestImage:(NSUInteger) sender.tag];
        assert(filePath != nil);
        
        [self startSend:filePath];
    }
}

- (IBAction)cancelAction:(id)sender
{
#pragma unused(sender)
    [self stopSendWithStatus:@"Cancelled"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
// A delegate method called by the URL text field when the editing is complete.
// We save the current value of the field in our settings.
{
    NSString *  defaultsKey;
    NSString *  newValue;
    NSString *  oldValue;
    
    if (textField == self.urlText) {
        defaultsKey = @"PutURLText";
    } else if (textField == self.usernameText) {
        defaultsKey = @"Username";
    } else if (textField == self.passwordText) {
        defaultsKey = @"Password";
    } else {
        assert(NO);
        defaultsKey = nil;          // quieten warning
    }
    
    newValue = textField.text;
    oldValue = [[NSUserDefaults standardUserDefaults] stringForKey:defaultsKey];
    
    // Save the URL text if it's changed.
    
    assert(newValue != nil);        // what is UITextField thinking!?!
    assert(oldValue != nil);        // because we registered a default
    
    if ( ! [newValue isEqual:oldValue] ) {
        [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:defaultsKey];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
// A delegate method called by the URL text field when the user taps the Return
// key.  We just dismiss the keyboard.
{
#pragma unused(textField)
    assert( (textField == self.urlText) || (textField == self.usernameText) || (textField == self.passwordText) );
    [textField resignFirstResponder];
    return NO;
}



@end