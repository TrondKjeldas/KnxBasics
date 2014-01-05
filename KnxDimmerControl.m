//
//  KnxDimmerControl.m
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 05.08.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import "KnxDimmerControl.h"


@implementation KnxDimmerControl

-(id)initWithAddresses:(KnxGroupAddress*)onOffGa
                      :(KnxGroupAddress*)setValGa
                      :(KnxGroupAddress*)valReturnGa
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        gotInitialResponse = FALSE;
        
        onOffAddress  = [onOffGa retain];
        setValAddress = [setValGa retain];
        valRspAddress = [valReturnGa retain];
        
        onOffIF = [[KnxRouterInterface alloc] init];
        setValIF = [[KnxRouterInterface alloc] init];
        valRspIF = [[KnxRouterInterface alloc] init];
        
        if(!onOffIF || !setValIF || !valRspIF)
            NSLog(@"Unable to init router interfaces!");
        
        [onOffIF setRspHandler:nil withSelector:nil];
        [setValIF setRspHandler:nil withSelector:nil];
        [valRspIF setRspHandler:self withSelector:@selector(handleDimValTelegram:)];
        
        [self openConnections];
    }
    
    return self;
}

-(void)openConnections;
{
    //NSLog(@"%s: %s", __FILE__, __FUNCTION__);
    [onOffIF openConnection];
    [onOffIF submitTelegram:[[[KnxRequest alloc] initWriteRequestWithAddress:onOffAddress] autorelease]];
    
    [setValIF openConnection];
    [setValIF submitTelegram:[[[KnxRequest alloc] initWriteRequestWithAddress:setValAddress] autorelease]];
    
    [valRspIF openConnection];
    [valRspIF submitTelegram:[[[KnxRequest alloc] initWriteRequestWithAddress:valRspAddress] autorelease]];
    [valRspIF submitTelegram:[[[KnxRequest alloc] initReadRequest] autorelease]];
    
    [self performSelector:@selector(retryRead) withObject:nil afterDelay:1.0];
}

-(void)closeConnections
{
    //NSLog(@"%s: %s", __FILE__, __FUNCTION__);
    [onOffIF closeConnection];
    [setValIF closeConnection];
    [valRspIF closeConnection];
}

-(void)setOnOffRspHandler:(id)Id withSelector:(SEL)Selector andObject:(id)Obj
{
    rspOnOffHandlerId = Id;
    rspOnOffHandlerSelector = Selector;
    rspOnOffHandlerObj = Obj;
}

-(void)setLevelRspHandler:(id)Id withSelector:(SEL)Selector andObject:(id)Obj
{
    rspLevelHandlerId = Id;
    rspLevelHandlerSelector = Selector;
    rspLevelHandlerObj = Obj;
}

- (void)dealloc
{
    [onOffAddress release];
    [setValAddress release];
    [valRspAddress release];

    [onOffIF release];
    [setValIF release];
    
    [super dealloc];
}

- (void)handleDimValTelegram:(KnxResponse*)telegram
{    
    NSLog(@"Got telegram: len %lu, type 0x%.2x",
          [telegram length], [telegram type]);
    if([telegram type] == 0x25 && [telegram length] == 7)
    {
        if(!gotInitialResponse)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(retryRead) object:nil];
            gotInitialResponse = TRUE;
        }
        
        NSNumber *level = [[[NSNumber alloc] initWithInt:[telegram decodeToDimVal]] autorelease];
        //NSLog(@"New value: %u", [telegram decodeToDimVal]);
        [rspLevelHandlerId performSelector:rspLevelHandlerSelector
                                withObject:[[[NSArray alloc] initWithObjects:rspLevelHandlerObj, level, nil] retain]];
        [rspOnOffHandlerId performSelector:rspOnOffHandlerSelector withObject:[[[NSArray alloc] initWithObjects:rspOnOffHandlerObj, level, nil] retain]];
    }
    [telegram release];
}


-(void)onOff:(BOOL)on
{
    //NSLog(@"dimmerCtrl %@ -> %@", [onOffAddress stringAddress], on ? @"ON" : @"OFF");
    [onOffIF submitTelegram:[[[KnxRequest alloc] initWriteRequestWithOnOffValue:on?1:0] autorelease]];
}

-(void)setLevel:(unsigned int)level
{
    //NSLog(@"dimmerCtrl %@ -> %u", [onOffAddress stringAddress], level);    
    [setValIF submitTelegram:[[[KnxRequest alloc] initWriteRequestWithDimmerValue:level] autorelease]];
}

-(void)retryRead
{
    if(!gotInitialResponse)
    {
        //NSLog(@"dimmerCtrl retrying initial read...");
        
        [valRspIF submitTelegram:[[[KnxRequest alloc] initWriteRequestWithAddress:valRspAddress] autorelease]];
        [valRspIF submitTelegram:[[[KnxRequest alloc] initReadRequest] autorelease]];
        
        [self performSelector:@selector(retryRead) withObject:nil afterDelay:1.0];
    }
}

@end
