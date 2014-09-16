//
//  MySongViewController.h
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/14/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

@interface MySongViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    // A dictionary object
    NSDictionary *dict;
    // Define keys
    NSString *titleName;
    NSString *trId;
}
@property (weak, nonatomic  ) IBOutlet UITableView           *tableView;
@property (nonatomic, strong) NSMutableArray        *songArray;

@property (weak, nonatomic  ) IBOutlet UISearchBar           *searchBar;
@property (weak, nonatomic  ) IBOutlet UIBarButtonItem       *currentSong;
@property (weak, nonatomic  ) IBOutlet UIBarButtonItem       *playPause;
@property (weak, nonatomic  ) IBOutlet UIBarButtonItem       *saveSong;
@property (weak, nonatomic  ) IBOutlet UIBarButtonItem       *deleteSong;


@property (nonatomic, strong) NSDictionary          *song;
@property (nonatomic, strong) NSURL                 *songUrl;
@property (nonatomic, strong) AVPlayerItem          *playerItem;
@property (nonatomic, strong) AVAudioPlayer         *player;
@property (nonatomic        ) BOOL                  play;
@property (nonatomic, strong) NSMutableArray        *data;
@property (nonatomic        ) int                   index;
@end
