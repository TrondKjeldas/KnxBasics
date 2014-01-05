//
//  KnxSubscription.m
//  KnxSubscriber
//
//  Created by Trond Kjeldås on 20.07.11.
//  Copyright 2011 Systemsoft AS. All rights reserved.
//

#import "KnxSubscription.h"
#import "KnxGroupAddress.h"

@implementation KnxSubscription

-(KnxSubscription*)initWithAddress:(KnxGroupAddress*)address andType:(NSString*)type andTarget:(id)target andSelector:(SEL)aSelector
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        owner               = target;
        ownerNotifySelector = aSelector;
        
        gaddr = [address retain];
        gtype = type;
        
        
        reqToBeSent = nil;
        subscriptionDone = FALSE;

        [self openConnection];
        
        [self submitTelegram:[[[KnxRequest alloc] initSubscriptionRequestWithAddress:gaddr] autorelease]];
        
        
    }
    
    return self;
}

- (void)dealloc
{
    [gaddr release];
    [gtype release];
    
    [super dealloc];
}

/*- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    NSLog(@"Alert ended %ld", (long)returnCode);  
    if( returnCode == NSAlertFirstButtonReturn )
    {
        NSLog(@"retrying...");
        [self openConnection];
    }
    else
    {
        [NSApp terminate:self];
    }    
}
*/

- (void)handleTelegram:(KnxResponse*)telegram
{    
    //NSLog(@"Got telegram");

    if(subscriptionDone)
    {
        NSNumber *val;
        if( [gtype isEqualToString:@"Temperature"] )
            val = [NSNumber numberWithFloat:[telegram decodeToFloat]];
        else
            val = [NSNumber numberWithFloat:[telegram decodeToBit]];
        
        [owner performSelector :ownerNotifySelector withObject:val];
        //NSLog(@"Notified!");
    }
    else
    {            
        if([telegram bufsize] < 4 || [telegram length] != 2)
        {
            NSLog(@"invalid length: %ld", [telegram length]);
        }
        else
        {
            if( [telegram type] != 0x22 )
            {
                NSLog(@"Connection not accepted");
            }
            else
            {
                NSLog(@"Connection accepted");
                subscriptionDone = TRUE;
            }
        }
    }
    
    [telegram release];
}

-(void)read
{
    NSLog(@"submitting read read request");
    [self submitTelegram:[[[KnxRequest alloc] initReadRequest] autorelease]];  
}

@end
