//
//  WaveChangeViewController.h
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/20/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketRocket/SocketIO.h"

@interface WaveChangeViewController : UIViewController <SocketIODelegate>
@property (nonatomic, strong) SocketIO *socketIO;

@end
