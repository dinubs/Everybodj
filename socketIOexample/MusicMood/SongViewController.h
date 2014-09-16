//
//  SongViewController.h
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/11/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

@interface SongViewController : UIViewController
@property (weak, nonatomic  ) IBOutlet UIButton         *playPause;
@property (weak, nonatomic  ) IBOutlet UISlider         *volumeControl;

@property (weak, nonatomic  ) IBOutlet UILabel          *play;

@property (nonatomic, strong) NSDictionary     *song;
@property (nonatomic, strong) NSURL            *songUrl;
@property (nonatomic, strong) AVPlayerItem     *playerItem;
@property (nonatomic, strong) AVAudioPlayer    *player;
@end
