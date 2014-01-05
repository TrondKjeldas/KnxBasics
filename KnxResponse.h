//
//  KnxResponse.h
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 20.07.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KnxTelegram.h"

@interface KnxResponse : KnxTelegram {
@private
}


- (id)initWithBytes:(UInt8*)byteptr toLength:(size_t)length;

-(size_t)fill:(UInt8*)byteptr toLength:(size_t)length;


-(BOOL)complete;

-(float)decodeToFloat;
-(float)decodeToBit;
-(unsigned int)decodeToDimVal;


@end
