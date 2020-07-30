//
//  DKXXEInputVC.m
//  CheckmarxM1
//
//  Created by Denis Krivitski on 18/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKXXEInputVC.h"

@interface DKXXEInputVC ()

@end

@implementation DKXXEInputVC
@synthesize xxeTextField;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setXxeTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    [self.delegate xxeInput:self.xxeTextField.text];
}

@end
