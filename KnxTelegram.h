//
//  KnxTelegram.h
//  
//
//  Created by Trond Kjeldås on 04.09.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KnxTelegram : NSObject {
@protected
    UInt8 bytes[256];
    size_t size;
}

- (id)init;
- (void)dealloc;

-(UInt8*)bytes;
-(size_t)bufsize;

-(size_t)length;
-(UInt16)type;
-(UInt8*)payload;

-(void)log;

@end
