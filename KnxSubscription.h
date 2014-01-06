//
//  KnxSubscription.h
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
#import <Foundation/Foundation.h>
#import "KnxGroupAddress.h"
#import "KnxRequest.h"
#import "KnxResponse.h"

#import "KnxRouterInterface.h"

@interface KnxSubscription : KnxRouterInterface {

    id        owner;
    SEL       ownerNotifySelector;
    
    
    KnxGroupAddress *gaddr;
    NSString        *gtype;
    
    KnxRequest *reqToBeSent;
    BOOL        subscriptionDone; 
}



-(KnxSubscription*)initWithAddress:(KnxGroupAddress*)address andType:(NSString*)type andTarget:(id)target andSelector:(SEL)aSelector;

-(void)read;

- (void)handleTelegram:(KnxResponse*)telegram;


@end
