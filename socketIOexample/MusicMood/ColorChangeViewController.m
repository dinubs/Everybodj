//
//  ColorChangeViewController.m
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/19/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import "ColorChangeViewController.h"
#import "ColorSpaceUtilities.h"

@interface ColorChangeViewController ()

@end

@implementation ColorChangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"everybodj.herokuapp.com" onPort:3000];
    
    self.view.backgroundColor = [UIColor blackColor];
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 20)];
    
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setTextAlignment:NSTextAlignmentCenter];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [yourLabel setText:@"Swipe Up and Down to Change the Wave Color"];
    [self.view addSubview:yourLabel];
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    [self getColor:&touchLocation];
}

-(void)getColor:(CGPoint *)location {
    CGFloat s = 1.0;
    CGFloat l = 1.0;
    CGFloat h = (location->y / self.view.frame.size.height);

    self.view.backgroundColor = [UIColor colorWithHue:h saturation:s brightness:l alpha:1.0];
    NSString *query = [NSString stringWithFormat:@"hsl(%f , 100%% , 50%%)", h * 360];

    [_socketIO sendEvent:@"change_stroke" withData:query];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    [self getColor:&touchLocation];
}

-(void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"everybodj.herokuapp.com" onPort:3000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
