//
//  KnxRouterInterface.m
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
#import "KnxRouterInterface.h"
#import "KnxResponse.h"
#include "KnxSubscription.h"

void writeTelegram(KnxRequest *request,NSOutputStream *tstream);


@implementation KnxRouterInterface

-(id)init
{
    self = [super init];
    if (self) {
        rstream = nil;
        tstream = nil;
        
        telegramQueue  =  [[NSMutableArray alloc] init];
        spaceAvailable = FALSE;
        
        /* Set up default handler... */
        rspHandlerId = self;
        rspHandlerSelector = @selector(handleTelegram:);
    }
    return self;
}

- (void)dealloc
{
    [self closeConnection];
    
    [super dealloc];
}

-(void)setRspHandler:(id)Id withSelector:(SEL)Selector
{
    rspHandlerId = Id;
    rspHandlerSelector = Selector;
}

-(void)submitTelegram:(KnxRequest*)telegram
{
    [telegram retain]; // Will eventually be released by writeTelegram

    if(spaceAvailable)
    {
        writeTelegram(telegram, tstream);                
        spaceAvailable = FALSE;
    }
    else
        [telegramQueue addObject:telegram];
}

-(id)dequeue
{
    if ([telegramQueue count] == 0) {
        return nil;
    }
    id queueObject = [[[telegramQueue objectAtIndex:0] retain] autorelease];
    [telegramQueue removeObjectAtIndex:0];
    return queueObject;
}

-(void)openConnection
{
    //NSLog(@"opening streams");
    //CFStreamCreatePairWithSocketToHost( NULL, CFSTR("192.168.1.77"), 1234, &is, &os);
    CFStreamCreatePairWithSocketToHost( NULL, CFSTR("192.168.1.51"), 6720, &is, &os);
    
    rstream = (NSInputStream*)is;
    [rstream setDelegate:self];
    [rstream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [rstream open];

    tstream = (NSOutputStream*)os;
    [tstream setDelegate:self];
    [tstream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [tstream open];
}

-(void)closeConnection
{
    [rstream close];
    [rstream release];
    [tstream close];
    [tstream release];
    //NSLog(@"streams closed and released");
}

void writeTelegram(KnxRequest *request,NSOutputStream *tstream)
{
  //NSLog(@"Writing telegram on stream (telegram retainCount %lu", [request retainCount]);
    [tstream write:[request bytes]
         maxLength:[request bufsize]];
    [request release];
    
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{    
    switch (streamEvent) {
        case NSStreamEventErrorOccurred:
            NSLog(@"Got error event");
/*            
            NSError *theError = [theStream streamError];
                        
            NSAlert *theAlert = [[NSAlert alloc] init]; // modal delegate releases
            [theAlert setMessageText:@"Error reading stream!"];
            [theAlert setInformativeText:[NSString stringWithFormat:@"Error %i: %@",
                                          [theError code], [theError localizedDescription]]];
            [theAlert addButtonWithTitle:@"Retry"];
            [theAlert addButtonWithTitle:@"Quit"];
            [theAlert beginSheetModalForWindow:[NSApp mainWindow]
                                 modalDelegate:self
                                didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                   contextInfo:nil];
*/            
            if (rstream != nil) {
                [rstream close];
                [rstream release];
            }
            if (tstream != nil) {
                [tstream close];
                [tstream release];
            }
            break;
        case NSStreamEventHasBytesAvailable:
        {
            static KnxResponse *rsp = Nil;
            uint8_t buff[100];
            uint8_t *payload = &buff[0];
            long len = 0;
            memset(payload,0,sizeof(buff));
            len = [(NSInputStream *)theStream read:payload maxLength:100];
            
            if(len) {
                size_t gone = 0;
                
                while(len>0)
                {
                    // NSLog(@"Got: len=%lu,"
                    //       "data=%.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x\n"
                    //       "     %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x",
                    //       len, payload[0],payload[1],payload[2],payload[3],payload[4],payload[5],
                    //       payload[6],payload[7],payload[8],payload[9],
                    //       payload[10],payload[11],payload[12],payload[13],payload[14],payload[15],
                    //       payload[16],payload[17],payload[18],payload[19]);
                    
                    if(rsp == Nil)
                    {
                        rsp = [[KnxResponse alloc] initWithBytes:payload toLength:len];
                        if( [rsp complete] )
                            gone = [rsp length] + 2;
                        else
                            gone = len;
                    }
                    else
                    {
                        gone = [rsp fill:payload toLength:len];
                    }
                    
                    if( [rsp complete] )
                    {
                        //NSLog(@"Delivering telegram");
                        if(rspHandlerId)
                            [rspHandlerId performSelector:rspHandlerSelector withObject:rsp];
                        else
                            [rsp release];
                        rsp = nil;
                    }
                    
                    //NSLog(@"this round took %lu", gone);
                    payload += gone;
                    len -= gone;
                }
            }
            else {
                NSLog(@"no buffer!");
            }
           
            break;
        }
        case NSStreamEventOpenCompleted:
            //NSLog(@"Got open completed");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"Got end encountered");
            break;
        case NSStreamEventNone:
            NSLog(@"Got none event");
            break;
        case NSStreamEventHasSpaceAvailable:
        {
            //NSLog(@"Got has space available");
            KnxRequest *request = [self dequeue];
            if(request != Nil)
            {
                [request retain]; // Will eventually be released by writeTelegram
                writeTelegram(request, tstream);                
                spaceAvailable = FALSE;
            }
            else
            {
                spaceAvailable = TRUE;
            }
            break;
        }
        default:
            NSLog(@"Got unknown event");
            break;
    }
}
@end
