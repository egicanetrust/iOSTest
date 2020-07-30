//
//  DKNetM3NSURL.m
//  CheckmarxM1
//
//  Created by Denis Krivitski on 10/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNetM8Cache.h"

@implementation DKNetM8Cache

-(void)start
{
    NSURL* url = [NSURL URLWithString:@"http://www.ddkmobile.com/checkmarx/ssn.txt"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate net:self receivedData:self.downloadedData];
    if (self.isSecure)
    {
        // Clear cache of the received response.
        // Call to this method is redundant if the method connection:willCacheResponse: was defined and returned nil.
        // Or, otherwise, the connection:willCacheResponse: is redundant if removeCachedResponseForRequest is called.
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:connection.originalRequest];
    }

}

// Control of response caching
-(NSCachedURLResponse*) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    if (self.isSecure)
    {
        // By returning nil, this callback method instructs the cache manager not to save the URL response to cache
        return nil;
        
    } else {
        
        return cachedResponse;
    }
    
}

@end
