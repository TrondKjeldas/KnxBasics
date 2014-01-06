//
//  KnxGroupAddress.m
//
//  Created by Trond Kjeldås on 20.07.11. Copyright 2011, All rights reserved.
//
// This file is part of the KnxBasics library.
//
// The KnxBasics is free software: you can redistribute it and/or modify
// it under the terms of the Lesser GNU General Public License version 2.1,
// as published by the Free Software Foundation.
//
// The KnxBasics library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// Lesser GNU General Public License for more details.
//
// You should have received a copy of the Lesser GNU General Public License
// along with the KnxBasics library. If not, see <http://www.gnu.org/licenses/>.
//
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


