//
//  DKNetM3ValidateUnsecureDelegate.h
//  CheckmarxM1
//
//  Description: Delegate for DKNetM3Validate unsecure connection. This delegate implements the following
//  two methods in order to bypass server certificate authentication:
//  connection:didReceiveAuthenticationChallenge: and connection:canAuthenticateAgainstProtectionSpace:
//  If those methods are not implemented, the verification takes place by default.
//
//  Created by Denis Krivitski on 17/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNetM3Validate.h"

@interface DKNetM3ValidateUnsecureDelegate : DKNetM3Validate

@end
