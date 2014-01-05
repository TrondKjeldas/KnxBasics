//
//  KnxDimmerControl.h
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 05.08.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KnxGroupAddress.h"
#import "KnxRouterInterface.h"
#import "KnxResponse.h"

@interface KnxDimmerControl : NSObject {
@private
    KnxGroupAddress* onOffAddress;
    KnxGroupAddress* setValAddress;
    KnxGroupAddress* valRspAddress;
    
    KnxRouterInterface *onOffIF;
    KnxRouterInterface *setValIF;
    KnxRouterInterface *valRspIF;
    
    id  rspOnOffHandlerId;
    SEL rspOnOffHandlerSelector;
    id  rspOnOffHandlerObj;
    id  rspLevelHandlerId;
    SEL rspLevelHandlerSelector;
    id  rspLevelHandlerObj;
    
    BOOL gotInitialResponse;
}

-(id)initWithAddresses:(KnxGroupAddress*)onOffGa
                      :(KnxGroupAddress*)setValGa
                      :(KnxGroupAddress*)valReturnGa;

-(void)openConnections;
-(void)closeConnections;

-(void)handleDimValTelegram:(KnxResponse*)telegram;


-(void)onOff:(BOOL)on;
-(void)setLevel:(unsigned int)level;

-(void)setOnOffRspHandler:(id)Id withSelector:(SEL)Selector andObject:(id)Obj;
-(void)setLevelRspHandler:(id)Id withSelector:(SEL)Selector andObject:(id)Obj;

-(void)retryRead;

@end
