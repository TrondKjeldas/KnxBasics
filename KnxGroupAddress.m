//
//  KnxGroupAddress.m
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 20.07.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import "KnxGroupAddress.h"


@implementation KnxGroupAddress

@synthesize address;
@synthesize stringAddress;

- (id)initFromString:(NSString*)addr
{
    self = [super init];
    if (self) {
        // Initialization code here.

        NSScanner *scanner = [NSScanner scannerWithString:addr];
        
        NSString *a = Nil;
        NSString *b = Nil;
        NSString *c = Nil;
        
        [scanner scanUpToString:@"/" intoString:&a];
        [scanner scanString:@"/" intoString:Nil];
        [scanner scanUpToString:@"/" intoString:&b];
        [scanner scanString:@"/" intoString:Nil];
        [scanner scanUpToString:@"/" intoString:&c];
        
        if( a && b && c)
        {
            UInt8 aa = [a longLongValue] & 0x1f;
            UInt8 bb = [b longLongValue] & 0x07;
            UInt8 cc = [c longLongValue] & 0xff;
            
            address = aa << 11 | bb << 8 | cc;
            stringAddress = [addr retain];
            
        }
        else if( a && b )
        {
            UInt8 aa = [a longLongValue] & 0x1f;
            UInt16 bb = [b longLongValue] & 0x07FF;
            
            address = aa << 11 | bb;
        }
        else
        {
            NSLog(@"Illegal address: %@", addr);
            [super release];
            return Nil;
        }        
    }
    
    return self;
}

- (void)dealloc
{
    [stringAddress release];
    [super dealloc];
}

@end


