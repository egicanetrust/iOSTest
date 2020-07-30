//
//  DKNetXXE.h
//  CheckmarxM1
//
//  Description: This class generates an XML file that contains the social security number (ssn). In addtion
//  to the ssn, the XML contains external entity declaration and use. The secure code path does not parse the
//  external entity, the unsecure path asks the user to enter the external entity path, then fethes the resource referenced by the path.
//
//  Created by Denis Krivitski on 17/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNet.h"
#import "DKXXEInputVC.h"

@interface DKNetXXE : DKNet <NSXMLParserDelegate,DKXXEInputVCDelegate>
@property BOOL isSsnElement;
@property (strong) NSData* externalEntityData;

@end
