//
//  KnxDimmerControl.h
//
//  Created by Trond Kjeldås on 05.08.11. Copyright 2011, All rights reserved.
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
