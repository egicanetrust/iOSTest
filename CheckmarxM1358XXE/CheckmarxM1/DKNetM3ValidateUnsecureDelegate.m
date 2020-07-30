//
//  DKNetM3ValidateUnsecureDelegate.m
//  CheckmarxM1
//
//  Created by Denis Krivitski on 17/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNetM3ValidateUnsecureDelegate.h"

@implementation DKNetM3ValidateUnsecureDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

// Bypasses server certificate validation
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}


@end
