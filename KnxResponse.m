//
//  KnxResponse.m
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
#import "KnxResponse.h"


@implementation KnxResponse

- (id)initWithBytes:(UInt8*)byteptr toLength:(size_t)length
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        if(length > sizeof(bytes) || length < 2)
        {
            [super release];
            return Nil;             
        }
        
        memcpy(bytes, byteptr, length);
        size = length;
        // Dont eat more than needed
        if( [self complete] )
            size = [self length] + 2;
    }
    
    return self;
}


-(size_t)fill:(UInt8*)byteptr toLength:(size_t)length
{
    if(size + length < sizeof(bytes))
    {   
        size_t old_size = size;
        memcpy(&bytes[size], byteptr, length);
        size += length;
        if([self complete])
        {
            // Now complete, ate what was needed...
            return (size - old_size);
        }
        // Need more, ate all...
        return length;
    }
    // No room, ate none
    return 0;
}

-(BOOL)complete
{
    //NSLog(@"need %lu, has %lu", [self length], size-2);
    return ([self length] <= (size - 2));
}

-(float)decodeToFloat
{
    if(size < 10 || [self length] != 8)
    {
        NSLog(@"invalid length: %ld (%ld)", size, [self length]);
    }
    else
    {
        if( [self type] != 0x25 )
        {
            NSLog(@"invalid frame");                            
        }
        else
        {   
            UInt8  z = bytes[8];
            UInt8  x = bytes[9];
            UInt32 i = (z*256) + x;
            
            UInt8 sign      = (i & 0x8000) >> 15;
            UInt8 exponent  = (i & 0x7800) >> 11;
            UInt16 mantissa = i & 0x7FF;
            float fval;
            
            if(sign)
            {
                mantissa = (~(mantissa-1)) & 0x7ff;
                //mantissa = -mantissa;
                fval = (float)((1<<exponent)*0.01*mantissa);
                fval *= -1;
            }
            else
            {
                fval = (float)((1<<exponent)*0.01*mantissa);
            }
            
            NSLog(@"Got float value: %f (i = 0x%x -> sign %hhu, mantissa %d (0x%x), exp %d (0x%x)",
                  fval, (unsigned int)i, sign, mantissa, mantissa, exponent, exponent);
            
            return fval;
        }
    } 
    return 0;
}

-(float)decodeToBit
{
    if(size < 8 || [self length] != 6)
    {
        NSLog(@"invalid length: %ld (%ld)", size, [self length]);
    }
    else
    {
        if( [self type] != 0x25 )
        {
            NSLog(@"invalid frame");                            
        }
        else
        {   
            UInt8  bit = bytes[7] & 0x01;
            
            //NSLog(@"Got bit value: %u", bit);
            
            return bit;
        }
    } 
    return 0;
}

-(unsigned int)decodeToDimVal
{
    [self log];
    if(size < 9 || [self length] != 7)
    {
        NSLog(@"invalid length: %ld (%ld)", size, [self length]);
    }
    else
    {
        if( [self type] != 0x25 )
        {
            NSLog(@"invalid frame");                            
        }
        else
        {   
            UInt8  byte = bytes[8];
            
            //NSLog(@"Got byte value: %u", byte);
            
            return (byte * 100) / 255;
        }
    } 
    return 0;
}



@end
