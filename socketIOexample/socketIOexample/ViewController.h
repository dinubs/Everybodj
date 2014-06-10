//
//  ViewController.h
//  socketIOexample
//
//  Created by Htain Lin Shwe on 21/10/13.
//  Copyright (c) 2013 saturngod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import "SwipeView.h"
@interface ViewController : UIViewController <SocketIODelegate>
@property (nonatomic,strong) SocketIO* socketIO;
@property (weak, nonatomic) IBOutlet SwipeView *swipeview;

@end