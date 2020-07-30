//
//  DKNet.m
//  CheckmarxM1
//
//  Description: This abstract class defines a unified interface for downloading data from network.
//
//  Created by Denis Krivitski on 10/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNet.h"
#import "DKNetM3NSURL.h"
#import "DKNetM8Cache.h"
#import "DKNetM3Validate.h"
#import "DKNetDeviceIdentifier.h"
#import "DKNetXXE.h"

@interface DKNet ()
@end


@implementation DKNet
@synthesize delegate = _delegate;
@synthesize secure = _secure;
@synthesize downloadedData = _downloadedData;



-(id)initWithSecure:(BOOL) secure andDelegate:(id<DKNetDelegate>) delegate;
{
    self=[super init];
    if (self)
    {
        _secure = secure;
        _delegate = delegate;
        _downloadedData = [[NSMutableData alloc] init];
    }
    return self;
}

+(DKNet*)netWithSecure:(BOOL) secure andDelegate:(id<DKNetDelegate>) delegate
{
    DKNet* result = nil;
    
    //int choise = (random() % 5);
    static int choise = 0;
    
    switch (choise % 5) {
        case 0:
            result = [[DKNetM3NSURL alloc] initWithSecure:secure andDelegate:delegate];
            break;
        case 1:
            result = [[DKNetM8Cache alloc] initWithSecure:secure andDelegate:delegate];
            break;
        case 2:
            result = [[DKNetM3Validate alloc] initWithSecure:secure andDelegate:delegate];
            break;
        case 3:
            result = [[DKNetDeviceIdentifier alloc] initWithSecure:secure andDelegate:delegate];
            break;
        case 4:
            result = [[DKNetXXE alloc] initWithSecure:secure andDelegate:delegate];
            break;
            
        default:
            break;
    }
    
    choise++;
    
    return result;
}

-(void)start
{
    // This method must be overriden by subclasses
}

@end
