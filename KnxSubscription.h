//
//  KnxSubscription.h
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 20.07.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
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
