//
//  RootViewController.h
//  MusicMood
//
//  Created by Gavin Dinubilo on 7/22/14.
//  Copyright (c) 2014 Gavin Dinubilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"

@interface RootViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mySongs;
@property (weak, nonatomic) IBOutlet UIButton *searchSongs;
@property (weak, nonatomic) IBOutlet UIButton *controller;

@end
