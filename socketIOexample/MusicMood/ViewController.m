//
//  ViewController.m
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/10/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import "ViewController.h"
#import "SongViewController.h"

@interface View

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    allObject                          = [[NSMutableArray alloc] init];
    _data                              = [[NSMutableArray alloc] init];
    // Define keys
    titleName                          = @"title";
    trId                               = @"trid";
    self.index                         = 1;
    NSArray *archivedArray             = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"song"]];
    [self.data addObjectsFromArray:archivedArray];

    [_playPause setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    [_saveSong setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];

    UIButton *button                   = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:@"No Song Selected" forState:UIControlStateNormal];
    button.titleLabel.font             = [UIFont fontWithName:@"Helvetica" size:12.0f];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *tmpbutton         = [[UIBarButtonItem alloc] init];
    tmpbutton                          = [_currentSong initWithCustomView:button];

    _searchBar.autocorrectionType      = UITextAutocorrectionTypeNo;
    _play                              = NO;    
}


-(void)viewDidDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl)
    {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {
            [player play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {
            [player pause];
        }
    }
}

- (IBAction)handleClick:(id)sender {
    if(_play == NO) {
    _play                              = YES;
        [player pause];
    _playPause.title                   = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-play"];
    } else {
    _play                              = NO;
        [player play];
    _playPause.title                   = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-pause"];
    }
}

-(IBAction)handleSave:(id)sender {
    NSString *tmp                      = [NSString stringWithFormat:@"%@", [_song objectForKey:@"title"]];
    for (NSDictionary *song in _data) {
    NSString *datatmp                  = [NSString stringWithFormat:@"%@", [song objectForKey:@"title"]];
        if ([tmp isEqualToString:datatmp]) {
            return;
    _saveSong.title                    = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-check"];
        }
    }
    [self.data addObject:self.song];
    _saveSong.title                    = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-check"];
    NSData *tmpArray                   = [NSKeyedArchiver archivedDataWithRootObject:_data];
    NSUserDefaults *data               = [NSUserDefaults standardUserDefaults];
    [data setObject:tmpArray forKey:@"song"];
    [data synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier    = @"Cell";
    UITableViewCell *cell              = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Use the default cell style.
    cell                               = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle
                                      reuseIdentifier : CellIdentifier];
    }
    NSDictionary *tmpDict              = [allObject objectAtIndex:indexPath.row];
    NSString *cellValue                = [tmpDict objectForKey:titleName];
    cell.textLabel.text                = cellValue;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allObject.count;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Define keys
    titleName                          = @"title";
    trId                               = @"trid";
    NSString *originalString           = searchBar.text;
    NSString *newString                = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // Create array to hold dictionaries
    NSString *str                      = [NSString stringWithFormat:@"http://labs.echonest.com/Uploader/search?q=%@&results=100", newString];
    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    id jsonObjects                     = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    // values in foreach loop
    NSInteger index                    = 0;
    for (NSDictionary *dataDict in jsonObjects) {
    NSString *title                    = [NSString stringWithFormat:@"%@ by %@",[dataDict objectForKey:@"title"],[dataDict objectForKey:@"artist"]];
    NSString *trid                     = [dataDict objectForKey:@"trid"];
    dict                               = [NSDictionary dictionaryWithObjectsAndKeys:
                title, titleName,
                trid, trId,
                nil];
        [_tableView numberOfRowsInSection:0];
    NSIndexPath *indexPath             = [NSIndexPath indexPathForRow:index inSection:0];
        [allObject insertObject:dict atIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        index++;
    }
    searchBar.text=@"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _saveSong.title                    = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-download"];
    _playPause.title                   = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-pause"];
    NSDictionary *tmpdict              = [[NSDictionary alloc] init];

    indexPath                          = [self.tableView indexPathForSelectedRow];
    self.index                         = indexPath.row;
    tmpdict                            = [allObject objectAtIndex:self.index];
    NSString *str                      = [NSString stringWithFormat:@"http://static.echonest.com/infinite_jukebox_data/%@.json", [tmpdict objectForKey:@"trid"]];

    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    id jsonObjects                     = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSDictionary *start                = jsonObjects;
    NSDictionary *response             = [start objectForKey:@"response"];
    NSDictionary *track                = [response objectForKey:@"track"];
    NSDictionary *info                 = [track objectForKey:@"info"];
    _song                              = info;
    NSString *tmp                      = [NSString stringWithFormat:@"%@", [_song objectForKey:@"title"]];
    for (NSDictionary *song in _data) {
    NSString *datatmp                  = [NSString stringWithFormat:@"%@", [song objectForKey:@"title"]];
        if ([tmp isEqualToString:datatmp]) {
    _saveSong.title                    = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-check"];
        }
    }
    NSString *newString                = [[info objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.songUrl                       = [NSURL URLWithString:newString];
    
    self.playerItem                    = [AVPlayerItem playerItemWithURL:self.songUrl];
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    player                             = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    [player play];
    
    UIButton *button1                  = [UIButton buttonWithType:UIButtonTypeCustom];

    [button1 setTitle:[tmpdict objectForKey:@"title"] forState:UIControlStateNormal];
    button1.titleLabel.font            = [UIFont fontWithName:@"Helvetica" size:12.0f];
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *tmpbutton         = [[UIBarButtonItem alloc] init];
    tmpbutton                          = [_currentSong initWithCustomView:button1];
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    _saveSong.title                    = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-download"];
    _playPause.title                   = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-pause"];

    self.index++;
    NSDictionary *tmpdict              = [allObject objectAtIndex:self.index];

    NSString *str                      = [NSString stringWithFormat:@"http://static.echonest.com/infinite_jukebox_data/%@.json", [tmpdict objectForKey:@"trid"]];
    //applications Documents dirctory path
    NSArray *paths                     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory       = [paths objectAtIndex:0];

    NSURL *url=[NSURL URLWithString:str];
    NSData *data=[NSData dataWithContentsOfURL:url];
    id jsonObjects                     = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSDictionary *start                = jsonObjects;
    NSDictionary *response             = [start objectForKey:@"response"];
    NSDictionary *track                = [response objectForKey:@"track"];
    NSDictionary *info                 = [track objectForKey:@"info"];
    _song                              = info;
    NSString *tmp                      = [NSString stringWithFormat:@"%@", [_song objectForKey:@"title"]];
    for (NSDictionary *song in _data) {
    NSString *datatmp                  = [NSString stringWithFormat:@"%@", [song objectForKey:@"title"]];
        if ([tmp isEqualToString:datatmp]) {
    _saveSong.title                    = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-check"];
        }
    }
    NSString *newString                = [[info objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.songUrl                       = [NSURL URLWithString:newString];

    self.playerItem                    = [AVPlayerItem playerItemWithURL:self.songUrl];
    player                             = [AVPlayer playerWithPlayerItem:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [player play];
    UIButton *button1                  = [UIButton buttonWithType:UIButtonTypeCustom];

    [button1 setTitle:[tmpdict objectForKey:@"title"] forState:UIControlStateNormal];
    button1.titleLabel.font            = [UIFont fontWithName:@"Helvetica" size:12.0f];
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *tmpbutton         = [_currentSong initWithCustomView:button1];

}
@end
