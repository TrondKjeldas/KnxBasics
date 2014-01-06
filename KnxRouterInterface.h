//
//  KnxRouterInterface.h
//
//  Created by Trond Kjeldås on 24.07.11. Copyright 2011, All rights reserved.
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
#import "KnxRequest.h"

@interface KnxRouterInterface : NSObject  < NSStreamDelegate > {
    
    NSInputStream * rstream;
    NSOutputStream * tstream;
    CFReadStreamRef  is;
    CFWriteStreamRef  os;
    
    NSMutableArray *telegramQueue;
    BOOL            spaceAvailable;
    
    id  rspHandlerId;
    SEL rspHandlerSelector;
}

-(id)init;

-(void)openConnection;
-(void)closeConnection;

-(void)submitTelegram:(KnxRequest*)telegram;

-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;

-(void)setRspHandler:(id)Id withSelector:(SEL)Selector;
@end
