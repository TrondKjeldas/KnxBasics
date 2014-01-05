//
//  KnxGroupAddress.h
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 20.07.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KnxGroupAddress : NSObject {
@private
    
    UInt16 address; 
    
}

@property (assign) UInt16 address;    
@property (readonly) NSString *stringAddress;

- (id)initFromString:(NSString*)addr;


@end
