//
//  ViewController.m
//  socketIOexample
//
//  Created by Htain Lin Shwe on 21/10/13.
//  Copyright (c) 2013 saturngod. All rights reserved.
//

#import "ViewController.h"
#import "SocketIOPacket.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"localhost" onPort:3000];
    [_socketIO sendEvent:@"join" withData:@"iOSuser"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark -
# pragma mark socket.IO-objc delegate methods

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"socket.io connected.");
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent()");
    
    if([packet.name isEqualToString:@"message"])
    {
        NSArray* args = packet.args;
        NSDictionary* arg = args[0];
        
    }
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"onError() %@", error);
}


- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}


@end