//
//  MySongViewController.m
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/14/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import "MySongViewController.h"

@interface MySongViewController ()

@end

@implementation MySongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self                              = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.songArray                    = [[NSMutableArray alloc] init];
    NSArray *archivedArray            = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"song"]];
    [self.songArray addObjectsFromArray:archivedArray];
    dict                               = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"", @"hello",
                                          @"", @"",
                                          nil];
    [allObject insertObject:@"" atIndex:[allObject count]];
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
    // Audio Background Usage
    NSError *sessionError             = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    AVAudioSession *session           = [AVAudioSession sharedInstance];

    NSError *setCategoryError         = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {

    }
    [_playPause setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    [_deleteSong setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];

    UIButton *button                  = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:@"No Song Selected" forState:UIControlStateNormal];
    button.titleLabel.font            = [UIFont fontWithName:@"Helvetica" size:12.0f];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *tmpbutton        = [[UIBarButtonItem alloc] init];
    tmpbutton                         = [_currentSong initWithCustomView:button];
    
}
-(void)viewDidDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_songArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {

    static NSString *CellIdentifier   = @"Cell";
    UITableViewCell *cell             = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    cell                              = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:CellIdentifier];
    }
    NSDictionary *tmpDict             = [_songArray objectAtIndex:indexPath.row];
    NSString *tmp                     = [NSString stringWithFormat:@"%@ by %@", [tmpDict objectForKey:@"title"], [tmpDict objectForKey:@"artist"]];
    cell.textLabel.text               = tmp;
    return cell;
}

- (IBAction)handleClick:(id)sender {
    if(_play == NO) {
    _play                             = YES;
        [self.player pause];
    _playPause.title                  = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-play"];
    } else {
    _play                             = NO;
        [self.player play];
    _playPause.title                  = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-pause"];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _deleteSong.title                 = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-eraser"];
    _playPause.title                  = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-pause"];
    NSDictionary *tmpdict             = [[NSDictionary alloc] init];

    indexPath                         = [self.tableView indexPathForSelectedRow];
    self.index                        = indexPath.row;
    tmpdict                           = [_songArray objectAtIndex:indexPath.row];
    NSString *str                     = [NSString stringWithFormat:@"http://static.echonest.com/infinite_jukebox_data/%@.json", [tmpdict objectForKey:@"id"]];

    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    id jsonObjects                    = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSDictionary *start               = jsonObjects;
    NSDictionary *response            = [start objectForKey:@"response"];
    NSDictionary *track               = [response objectForKey:@"track"];
    NSDictionary *info                = [track objectForKey:@"info"];
    _song                             = info;
    NSString *tmp                     = [NSString stringWithFormat:@"%@", [_song objectForKey:@"title"]];
    for (NSDictionary *song in _data) {
    NSString *datatmp                 = [NSString stringWithFormat:@"%@", [song objectForKey:@"title"]];
        if ([tmp isEqualToString:datatmp]) {
    _saveSong.title                   = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-check"];
        }
    }
    NSString *newString               = [[info objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.songUrl                      = [NSURL URLWithString:newString];

    self.playerItem                   = [AVPlayerItem playerItemWithURL:self.songUrl];
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.player                       = [AVPlayer playerWithPlayerItem:self.playerItem];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.player play];

    UIButton *button                  = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:[NSString stringWithFormat:@"%@ by %@",[tmpdict objectForKey:@"title"], [tmpdict objectForKey:@"artist"]] forState:UIControlStateNormal];
    button.titleLabel.font            = [UIFont fontWithName:@"Helvetica" size:12.0f];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *tmpbutton        = [[UIBarButtonItem alloc] init];
    tmpbutton                         = [_currentSong initWithCustomView:button];
}


-(void)itemDidFinishPlaying:(NSNotification *) notification {
    _saveSong.title                   = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-download"];
    _playPause.title                  = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-pause"];

    self.index++;
    if (self.index == [_songArray count]) {
    self.index                        = 0;
    }
    NSDictionary *tmpdict             = [_songArray objectAtIndex:self.index];

    NSString *str                     = [NSString stringWithFormat:@"http://static.echonest.com/infinite_jukebox_data/%@.json", [tmpdict objectForKey:@"id"]];

    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    id jsonObjects                    = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSDictionary *start               = jsonObjects;
    NSDictionary *response            = [start objectForKey:@"response"];
    NSDictionary *track               = [response objectForKey:@"track"];
    NSDictionary *info                = [track objectForKey:@"info"];
    _song                             = info;
    NSString *tmp                     = [NSString stringWithFormat:@"%@", [_song objectForKey:@"title"]];
    for (NSDictionary *song in _data) {
    NSString *datatmp                 = [NSString stringWithFormat:@"%@", [song objectForKey:@"title"]];
        if ([tmp isEqualToString:datatmp]) {
    _saveSong.title                   = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-check"];
        }
    }
    NSString *newString               = [[info objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.songUrl                      = [NSURL URLWithString:newString];

    self.playerItem                   = [AVPlayerItem playerItemWithURL:self.songUrl];
    self.player                       = [AVPlayer playerWithPlayerItem:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.player play];

    UIButton *button                  = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:[NSString stringWithFormat:@"%@ by %@",[tmpdict objectForKey:@"title"], [tmpdict objectForKey:@"artist"]] forState:UIControlStateNormal];
    button.titleLabel.font            = [UIFont fontWithName:@"Helvetica" size:12.0f];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *tmpbutton        = [[UIBarButtonItem alloc] init];
    tmpbutton                         = [_currentSong initWithCustomView:button];
}


- (IBAction)deleteSong:(id)sender {
    [self.songArray removeObjectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    [self.tableView reloadData];
    [self.player pause];
    NSData *tmpArray                  = [NSKeyedArchiver archivedDataWithRootObject:self.songArray];
    NSUserDefaults *data              = [NSUserDefaults standardUserDefaults];
    [data setObject:tmpArray forKey:@"song"];
    [data synchronize];

    UIButton *button                  = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:@"No Song Selected" forState:UIControlStateNormal];
    button.titleLabel.font            = [UIFont fontWithName:@"Helvetica" size:12.0f];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *tmpbutton        = [[UIBarButtonItem alloc] init];
    tmpbutton                         = [_currentSong initWithCustomView:button];
    _deleteSong.title                 = @"";
    _playPause.title                  = @"";

}

@end
