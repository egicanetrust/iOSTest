//
//  DKNetDeviceIdentifier.h
//  CheckmarxM1
//
//  Description: This class sends the following device identifiers to the server in URL parameters:
//  - UDID
//  - IP Address
//  - MAC Address
//
//  Created by Denis Krivitski on 17/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNet.h"

@interface DKNetDeviceIdentifier : DKNet  <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@end
