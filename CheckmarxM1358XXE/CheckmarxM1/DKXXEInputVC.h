//
//  DKXXEInputVC.h
//  CheckmarxM1
//
//  Created by Denis Krivitski on 18/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKXXEInputVCDelegate
-(void) xxeInput:(NSString*)input;
@end


@interface DKXXEInputVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *xxeTextField;
@property (strong) id<DKXXEInputVCDelegate> delegate;

@end
