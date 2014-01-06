//
//  KnxTelegram.m
//  
//  Created by Trond Kjeldås on 04.09.11. Copyright 2011, All rights reserved.
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
#import "KnxTelegram.h"


@implementation KnxTelegram


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        memset(bytes, 0, sizeof(bytes));
        size = 0;
    }    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(UInt8*)bytes
{
    return bytes;
}
-(size_t)bufsize
{
    return size;
}

-(size_t)length
{
    return ((bytes[0] << 8)| bytes[1]);
}
-(UInt16)type
{
    return ((bytes[2] << 8)| bytes[3]);   
}
-(UInt8*)payload
{
    return &bytes[2];
}

-(void)log
{
    char cs[5] = "";
    char cs2[256] = "";
    
    for(int i= 0; i < size; i++)
    {
        sprintf(cs, " %.2x", bytes[i]);
        strcat(cs2, cs);
    }

    //NSLog(@"Telegram: type %u, len %lu, data: %s",
    //           [self type], [self length], cs2);
}

@end
