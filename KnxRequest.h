//
//  KnxRequest.h
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 20.07.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KnxGroupAddress.h"


#import "KnxTelegram.h"

@interface KnxRequest : KnxTelegram {
@private
}

- (id)initSubscriptionRequestWithAddress:(KnxGroupAddress*)address;

- (id)initReadRequest;
- (id)initReadRequestWithAddress:(KnxGroupAddress*)address;

- (id)initWriteRequestWithAddress:(KnxGroupAddress*)address;
- (id)initWriteRequestWithOnOffValue:(unsigned int)value;
- (id)initWriteRequestWithDimmerValue:(unsigned int)value;


@end
