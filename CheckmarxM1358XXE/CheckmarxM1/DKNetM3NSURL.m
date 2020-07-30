//
//  DKNetM3NSURL.m
//  CheckmarxM1
//
//  Created by Denis Krivitski on 10/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNetM3NSURL.h"

@implementation DKNetM3NSURL

-(void)start
{
    if (self.isSecure)
    {
        NSURL* url = [NSURL URLWithString:@"https://s3.amazonaws.com/www.ddkmobile.com/checkmarx/ssn.txt"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    } else {
        NSURL* url = [NSURL URLWithString:@"http://s3.amazonaws.com/www.ddkmobile.com/checkmarx/ssn.txt"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
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


@end
