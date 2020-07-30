//
//  DKNetM3NSURL.h
//  CheckmarxM1
//
//  Description: Network access class that uses: NSURL framework,
//  uses HTTPS with validated vs non-validated sertificates
//
//  Created by Denis Krivitski on 10/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNet.h"

@interface DKNetM3Validate : DKNet <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@end
