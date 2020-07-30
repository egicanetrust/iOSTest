//
//  DKNetXXE.m
//  CheckmarxM1
//
//  Created by Denis Krivitski on 17/09/12.
//  Copyright (c) 2012 DDK Mobile. All rights reserved.
//

#import "DKNetXXE.h"

@implementation DKNetXXE

-(void)start
{
    if (self.isSecure)
    {
        [self xxeInput:@""];
    } else {
        // Presents a user interface with a text field for entering the external entity path
        // When the user taps the Done button, xxxInput: method is called
        DKXXEInputVC* inputVC = [[DKXXEInputVC alloc] initWithNibName:@"DKXXEInputVC" bundle:nil];
        inputVC.delegate = self;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:inputVC animated:YES];
    }
}


-(void)xxeInput:(NSString *)input
{
      
    NSString* xmlString = @"bla bla";
    
    // here the %@ format string is replaced by the contents of input argument
    NSString* xmlStringWithXXE = [NSString stringWithFormat:xmlString,input];
        
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:[xmlStringWithXXE dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    
    if (self.isSecure)
    {
        parser.shouldResolveExternalEntities = NO; // The default is NO
    } else {
        parser.shouldResolveExternalEntities = YES;
    }
    self.isSsnElement = NO;
    self.externalEntityData = [[NSData alloc] init];
    [parser parse];

}

// This delegate method is called when the parser encounters external entity declaration in the DOCTYPE block.
// The method gives the delegate the opportunity to fetch the contents of external entity. There is no other
// way to fetch extenal entity contents except using this delegate method.
// This method is called when shouldResolveExternalEntities is set to YES

/* See below an excerpt from XMLParser class documentation.
   Doc source: https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/XMLParsing/Articles/ValidatingXML.html
 
 Resolving External DTD Entities
 -------------------------------
 An XML document, in the DOCTYPE declaration that occurs near its beginning, often identifies an external DTD file whose declarations prescribe its logical structure. For example, the following DOCTYPE declaration says that the DTD related to the root element “addresses” can be located by the system identifier “addresses.dtd”.
 
 Example:   <!DOCTYPE addresses SYSTEM "addresses.dtd">
 
 Often the system identifier assumes a standard file-system location for DTDs—for example, /System/Library/DTDs. At the start of processing, the NSXMLParser delegate is given an opportunity to resolve this external entity and give the parser a list of DTD declarations to parse.
 
 When you prepare the NSXMLParser instance, send it the setShouldResolveExternalEntities: with an argument of YES.
 Implement the delegation method parser:resolveExternalEntityName:systemID: to return the declarations in the external DTD file as an NSData object.
 If the DTD declarations are internal to an XML document, then the delegate will receive the DTD-declaration messages automatically (assuming, of course, that it implements the related methods).
 
 */

-(void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
    NSLog(@"foundExternalEntityDeclarationWithName: %@ %@",name,systemID);
    
    if (self.isSecure)
    {
        // Here the secure implementation needs to sanitize the
        // path to external entity
        // systemID contains the path to external entity
        // This sanitation is a double security measure. Since shouldResolveExternalEntities
        // is set to NO in the secure code path, this method will not be called at all.
        if ([self isXXEPathSafe:systemID] == NO)
        {
            // if sanitation fails, throw an exception
            // LEON @throw [[NSException alloc] initWithName:@"XML Parser encountered unsafe external entity reference" reason:nil userInfo:nil];
        }
    }
    // Get the contents of file referenced by systemID
    self.externalEntityData = [NSData dataWithContentsOfURL:[NSURL URLWithString:systemID]];
}

// This delegate method is called each time the external entity is used in the xml file.
// The method receives the entity name and should return the data that should be substituted in place of entity.

-(NSData*)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID
{
    NSLog(@"resolveExternalEntityName: %@",name);
    return self.externalEntityData;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"didStartElement: %@",elementName);
    if ([elementName isEqualToString:@"ssn"])
    {
        self.isSsnElement = YES;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ssn"])
    {
        self.isSsnElement = NO;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"foundCharacters: >%@<",string);
    if (self.isSsnElement)
    {
        [self.delegate net:self receivedData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
}


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"parseErrorOccurred: %@",parseError);
}

-(BOOL) isXXEPathSafe:(NSString*)path
{
    
    // path sanitation code goes here
    
    return YES;
}


@end
