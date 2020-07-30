//
//  DKNetM3NSURL.m
//  CheckmarxM1
//
//  Created by Denis Krivitski on 10/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNetM3Validate.h"
#import "DKNetM3ValidateUnsecureDelegate.h"

@implementation DKNetM3Validate

-(void)start
{
    if (self.isSecure)
    {
        // The url: https://denis-mac.local/ssn.txt is hosted on my local machine with self signed certificate
        
        NSURL* url = [NSURL URLWithString:@"https://denis-mac.local/ssn.txt"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        // This delegate DOES NOT implement server sertificate validation bypass, thus will generate an error while
        // connecting to a server with bad certificate.
        [NSURLConnection connectionWithRequest:request delegate:self];
    } else {
        NSURL* url = [NSURL URLWithString:@"https://denis-mac.local/ssn.txt"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        // This delegate implements methods that override server cerfiticate validation
        DKNetM3ValidateUnsecureDelegate* delegate  = [[DKNetM3ValidateUnsecureDelegate alloc] initWithSecure:self.isSecure andDelegate:self.delegate];
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate net:self receivedData:self.downloadedData];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



@end
