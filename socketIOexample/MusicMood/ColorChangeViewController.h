//
//  ColorChangeViewController.h
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/19/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketRocket/SocketIO.h"

@interface ColorChangeViewController : UIViewController <SocketIODelegate>
@property (nonatomic, strong) SocketIO *socketIO;
@end
