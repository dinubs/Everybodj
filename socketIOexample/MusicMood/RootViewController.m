//
//  RootViewController.m
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/22/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [_mySongs setFont:[UIFont fontWithName:@"FontAwesome" size:26.0]];
    NSString *tmp = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-user"];
    _mySongs.titleLabel.numberOfLines = 3;
    _mySongs.titleLabel.textAlignment = NSTextAlignmentCenter;
    _mySongs.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_mySongs setTitle:[NSString stringWithFormat:@"%@\n\nMy Songs", tmp] forState:UIControlStateNormal];
    [_searchSongs setFont:[UIFont fontWithName:@"FontAwesome" size:26.0]];
    tmp = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-search"];
    _searchSongs.titleLabel.numberOfLines = 3;
    _searchSongs.titleLabel.textAlignment = NSTextAlignmentCenter;
    _searchSongs.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_searchSongs setTitle:[NSString stringWithFormat:@"%@\n\nSearch Songs", tmp] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
