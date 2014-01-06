//
//  KnxRequest.m
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
#import "KnxRequest.h"

@implementation KnxRequest

- (id)initSubscriptionRequestWithAddress:(KnxGroupAddress*)address
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        bytes[4] = (([address address]>>8)&0xff);
        bytes[5] = ([address address]&0xff);
        bytes[6] = 0x00;
        bytes[2] = 0;
        bytes[3] = 34;
        
        // Add length...
        bytes[0] = 0;
        bytes[1] = 5;        
        size = 7;
    }
    
    return self;
}

- (id)initReadRequest;
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        bytes[2] = 0;
        bytes[3] = 37;
        bytes[4] = 0;
        bytes[5] = 0;
        
        // Add length...
        bytes[0] = 0;
        bytes[1] = 4;        
        size = 6;
    }
    return self;
}

- (id)initReadRequestWithAddress:(KnxGroupAddress*)address
{
    self = [super init];
    if (self) {
        // Unused
    }
    return self;    
}
- (id)initWriteRequestWithAddress:(KnxGroupAddress*)address
{
    self = [super init];
    if (self) {
        
        bytes[2] = 0;
        bytes[3] = 34;
        bytes[4] = (([address address]>>8)&0xff);
        bytes[5] = ([address address]&0xff);
        bytes[6] = 0;
        
        // Add length...
        bytes[0] = 0;
        bytes[1] = 5;        
        size = 7;
    }
    return self;
}

- (id)initWriteRequestWithOnOffValue:(unsigned int)value
{
    self = [super init];
    if (self) {
        
        bytes[2] = 0;
        bytes[3] = 37;
 
        bytes[4] = 0;
        bytes[5] = value | 0x80;
        
        // Add length...
        bytes[0] = 0;
        bytes[1] = 4;        
        size = 6;
    }
    return self;        
}

- (id)initWriteRequestWithDimmerValue:(unsigned int)value
{
    self = [super init];
    if (self) {

        bytes[2] = 0;
        bytes[3] = 37;
        
        bytes[4] = 0;
        bytes[5] = 0x80;
        bytes[6] = (value * 255) / 100; /* Convert range from 0-100 to 8bit */
        
        // Add length...
        bytes[0] = 0;
        bytes[1] = 5;        
        size = 7;
    }
    return self;
}

@end
