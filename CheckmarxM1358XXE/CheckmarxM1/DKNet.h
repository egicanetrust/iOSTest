//
//  DKNet.h
//  CheckmarxM1
//
//  Created by Denis Krivitski on 10/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DKNet;

// Protocol for returning received data to client class
@protocol DKNetDelegate <NSObject>
@required
-(void) net:(DKNet*)net receivedData:(NSData*)data;
@end

// Class interface definition
@interface DKNet : NSObject
@property (strong, atomic) id<DKNetDelegate> delegate;
@property (assign, atomic, getter = isSecure) BOOL secure;
@property (strong, atomic) NSMutableData* downloadedData;

// Factory method that instantiates a concrete subclass
+(DKNet*)netWithSecure:(BOOL) secure andDelegate:(id<DKNetDelegate>) delegate;

-(id)initWithSecure:(BOOL) secure andDelegate:(id<DKNetDelegate>) delegate;

// starts the network connection
-(void) start;

@end
