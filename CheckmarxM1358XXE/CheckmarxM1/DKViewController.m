//
//  DKViewController.m
//  CheckmarxM1
//
//  Created by Denis Krivitski on 2/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKViewController.h"

@interface DKViewController ()

@end

@implementation DKViewController
@synthesize isSecure = _isSecure;
@synthesize pasteboardContents = _pasteboardContents;
@synthesize downloadedDataM8 = _downloadedDataM8;
@synthesize downloadedDataM3 = _downloadedDataM3;
@synthesize m8Connection = _m8Connection;
@synthesize m3Connection = _m3Connection;
@synthesize ssnTextField;
@synthesize passwordTextField;
@synthesize secureSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self secureSwitchChanged:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    

}

- (void)viewDidUnload
{
    [self setSsnTextField:nil];
    [self setPasswordTextField:nil];
    [self setSecureSwitch:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)saveButtonPressed:(id)sender
{
    NSLog(@"SSN: %@, pass: %@",self.ssnTextField.text, self.passwordTextField.text);
    
    NSURL* fileUrl = [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    fileUrl = [fileUrl URLByAppendingPathComponent:@"PersonalData.txt"];
    NSLog(@"PersonalData.txt path: %@",[fileUrl path]);
    
    NSString* ssn = self.ssnTextField.text;
    NSString* pass = self.passwordTextField.text;
    
    NSString* saveString = [NSString stringWithFormat:@"ssn=%@, pass=%@",ssn,pass];
    NSData* data = [saveString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (self.isSecure)
    {
        //////////////////////////////////////////////////
        // Secure handling of data
        //////////////////////////////////////////////////
        
        
        // Write to encrypted file
        
        NSError* error;
        if ([data writeToFile:[fileUrl path] options:NSDataWritingFileProtectionComplete error:&error] == NO)
        {
            NSLog(@"Write to file error: %@",error);
        }
        
        // Write to keychain
        
        NSDictionary* kcAttrib = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword, (__bridge id)kSecValueData : data};
        CFTypeRef kcResult=NULL;
        OSStatus ret = SecItemAdd((__bridge CFDictionaryRef)(kcAttrib), &kcResult);
        NSLog(@"KC Item Add: %ld result: %@",ret,kcResult);
        
        
        // The below commented-out code can be used to read the secret from keychain
        /*
        NSDictionary* query = @{ (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword ,
        (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
        (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanFalse
        };
        kcResult = NULL;
        ret = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &kcResult);
        NSLog(@"Item copy matching(%ld): result: %@",ret, [NSString stringWithUTF8String:[ ((__bridge NSData*)kcResult) bytes]]);
        */

        
    } else {
        
        //////////////////////////////////////////////////
        // Insecure handling of data
        //////////////////////////////////////////////////
        
        // Write to plain text file
        
        NSError* error;
        if ([data writeToFile:[fileUrl path] options:NSDataWritingFileProtectionNone error:&error] == NO)
        {
            NSLog(@"Write to file error: %@",error);
        }
        
        // Store in User-Defauls database
        
        NSUserDefaults *credentials = [NSUserDefaults standardUserDefaults];
        [credentials setObject:saveString forKey:@"SSN and password"];
        [credentials synchronize];
        
        // Secret data is logged to system log
        
        NSLog(@"The following user credentials were saved: %@",saveString);
        
    }
    

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)secureSwitchChanged:(id)sender
{
    self.isSecure = self.secureSwitch.on;
    
    if (self.isSecure)
    {
        // Disables auto-correction on Social Security Number text field
        // Auto-correction mechanism sends keystrokes to the system for
        // typos detection
        self.ssnTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
    } else {
        // Enables auto-correction on Social Security Number
        self.ssnTextField.autocorrectionType = UITextAutocorrectionTypeYes;

    }
}



-(void)didEnterBackground:(NSNotification *)notification
{
    if (self.isSecure)
    {
        // Hide secrets before the application is going to background to prevent
        // the secrets to be stored in screenshot
        self.ssnTextField.hidden = YES;
        self.passwordTextField.hidden = YES;
        
        // Clear the pasteboard before the application is switched to background
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        self.pasteboardContents = pasteboard.string;
        pasteboard.string = @"";
    }
}

-(void)didBecomeActive:(NSNotification *)notification
{
    if (self.isSecure)
    {
        // Show the hidded secret fields
        self.ssnTextField.hidden = NO;
        self.passwordTextField.hidden = NO;
    
        // return the cleared pasteboard data back
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.pasteboardContents;
        
    }
}



- (IBAction)loadSSNM3ButtonPressed:(id)sender
{
    DKNet* net = [DKNet netWithSecure:self.isSecure andDelegate:self];
    [net start];
}

-(void) net:(DKNet *)net receivedData:(NSData *)data
{
    self.ssnTextField.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
