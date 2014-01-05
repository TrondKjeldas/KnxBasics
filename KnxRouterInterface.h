//
//  KnxRouterInterface.h
//  
//
//  Created by Trond Kjeldås on 24.07.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
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
