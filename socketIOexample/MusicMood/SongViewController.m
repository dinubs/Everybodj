//
//  SongViewController.m
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/11/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import "SongViewController.h"

@interface SongViewController ()

@end

@implementation SongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self                       = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title                 = [self.song objectForKey:@"title"];
    NSLog(@"%@", self.song);
    [self getSongFromWeb];
    // Audio Background Usage
    NSError *sessionError      = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    AVAudioSession *session    = [AVAudioSession sharedInstance];

    NSError *setCategoryError  = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {

    }
    // End Audio Background

    _playPause.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    _playPause.titleLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-play"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)getSongFromWeb {
    NSString *str              = [NSString stringWithFormat:@"http://static.echonest.com/infinite_jukebox_data/%@.json", [self.song objectForKey:@"trid"]];
    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    id jsonObjects             = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSDictionary *start        = jsonObjects;
    NSDictionary *response     = [start objectForKey:@"response"];
    NSDictionary *track        = [response objectForKey:@"track"];
    NSDictionary *info         = [track objectForKey:@"info"];
    NSLog(@"%@", info);
    NSString *newString        = [[info objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.songUrl               = [NSURL URLWithString:newString];
    NSLog(@"%@", self.songUrl);

    self.playerItem            = [AVPlayerItem playerItemWithURL:self.songUrl];
    self.player                = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player                = [AVPlayer playerWithURL:self.songUrl];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.player play];
}

@end
