//
//  DKViewController.h
//  CheckmarxM1
//
//  Created by Denis Krivitski on 2/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKNet.h"

@interface DKViewController : UIViewController<UITextFieldDelegate, DKNetDelegate>
@property (assign, nonatomic) BOOL isSecure;
@property (strong, nonatomic) NSString* pasteboardContents;
@property (strong, atomic) NSMutableData* downloadedDataM8;
@property (strong, atomic) NSMutableData* downloadedDataM3;
@property (strong, atomic) NSURLConnection* m8Connection;
@property (strong, atomic) NSURLConnection* m3Connection;

@property (weak, nonatomic) IBOutlet UITextField *ssnTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *secureSwitch;




@end
