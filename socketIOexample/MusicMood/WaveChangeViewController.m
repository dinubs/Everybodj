//
//  WaveChangeViewController.m
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/20/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import "WaveChangeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WaveChangeViewController ()

@end

@implementation WaveChangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"everybodj.herokuapp.com" onPort:3000];
    [self setUpView];
}

-(void)setUpView {
    self.view.backgroundColor = [UIColor blackColor];
    UILabel *yourLabel        = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 20)];

    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setTextAlignment:NSTextAlignmentCenter];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [yourLabel setText:@"Change the Wave Types"];
    [self.view addSubview:yourLabel];

    // Do any additional setup after loading the view.
    UIButton *original        = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [original addTarget:self
               action:@selector(changeWave:)
     forControlEvents:UIControlEventTouchUpInside];
    [original setTitle:@"Original" forState:UIControlStateNormal];
    [original setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [original setTag:0];
    [[original layer] setBorderWidth:2.0f];
    [[original layer] setBorderColor:[UIColor whiteColor].CGColor];
    [original setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    original.frame            = CGRectMake(80.0, 90.0, 160.0, 40.0);
    [self.view addSubview:original];
    // Do any additional setup after loading the view.
    UIButton *circle          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [circle addTarget:self
               action:@selector(changeWave:)
     forControlEvents:UIControlEventTouchUpInside];
    [circle setTitle:@"Circles" forState:UIControlStateNormal];
    [circle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [circle setTag:1];
    [[circle layer] setBorderWidth:2.0f];
    [[circle layer] setBorderColor:[UIColor whiteColor].CGColor];
    [circle setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    circle.frame              = CGRectMake(80.0, 140.0, 160.0, 40.0);
    [self.view addSubview:circle];

    // Do any additional setup after loading the view.
    UIButton *equalizer       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [equalizer addTarget:self
               action:@selector(changeWave:)
     forControlEvents:UIControlEventTouchUpInside];
    [equalizer setTitle:@"Equalizer" forState:UIControlStateNormal];
    [equalizer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [equalizer setTag:2];
    [[equalizer layer] setBorderWidth:2.0f];
    [[equalizer layer] setBorderColor:[UIColor whiteColor].CGColor];
    [equalizer setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    equalizer.frame           = CGRectMake(80.0, 190.0, 160.0, 40.0);
    [self.view addSubview:equalizer];

    // Do any additional setup after loading the view.
    UIButton *dots            = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dots addTarget:self
               action:@selector(changeWave:)
     forControlEvents:UIControlEventTouchUpInside];
    [dots setTitle:@"Dots" forState:UIControlStateNormal];
    [dots setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dots setTag:3];
    [[dots layer] setBorderWidth:2.0f];
    [[dots layer] setBorderColor:[UIColor whiteColor].CGColor];
    [dots setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    dots.frame                = CGRectMake(80.0, 240.0, 160.0, 40.0);
    [self.view addSubview:dots];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeWave:(id)sender {

    NSString *query = [NSString stringWithFormat:@"%ld", (long)[sender tag]];
    [_socketIO sendEvent:@"change_wave" withData:query];

}

-(void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"everybodj.herokuapp.com" onPort:3000];
}

@end
