//
//  NATViewController.m
//  CodeMaster
//
//  Created by Nate Berman on 4/27/14.
//  Copyright (c) 2014 Nate Berman. All rights reserved.
//

#import "NATViewController.h"
#import <AVFoundation/AVFoundation.h> //audio
#import <QuartzCore/QuartzCore.h> //animations

@interface NATViewController ()

@end

@implementation NATViewController

// keeep track of a gamestate
bool currentGame = NO;
// keep track of attempts
int attemptCount = 1;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // configure assets for app launch
    [self configureLaunch];
    
    // opening animation
    [self openDoors];
    
    // add some spice to the background
    [self randomLight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureLaunch {
    // programmatic setup to account for multiple screen sizes
    // create UIImage and define stretchable pixel location (middle pixel in each dimension)
    UIImage *frameImage = [[UIImage imageNamed:@"FrameVignette.png"] stretchableImageWithLeftCapWidth:159 topCapHeight:239];
    UIImageView *frameView = [[UIImageView alloc] initWithImage:frameImage];
    // size based on screen size
    // 4inch
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        frameView.frame = CGRectMake(0, 0, frameImage.size.width, 568);
    }
    // 3.5inch
    else {
        frameView.frame = CGRectMake(0, 0, frameImage.size.width, frameImage.size.height);
    }
    
    // configure z-space view heirarchy
    // topDoor top
    [self.view addSubview:topDoorView];
    // insert centerPanelView under our topDoor
    [self.view insertSubview:centerPanelView belowSubview:topDoorView];
    // insert botDoor above centerPanel
    [self.view insertSubview:botDoorView aboveSubview:centerPanelView];
    //
    [self.view insertSubview:frameView belowSubview:botDoorView];
    // gameOver goes over everything
    [self.view insertSubview:gameOverView aboveSubview:topDoorView];
    
    // place our gameOverView
    gameOverView.frame = CGRectMake(80, -90, 160, 90);
    // hide it
    gameOverView.hidden = YES;
    
    // prepare our opening animation
    // topPanel start location doesnt change based on screen resolution
    topPanelView.frame = CGRectMake(13, -91, 294, 91);
    // placement of botDoor and botPanel are screen size dependent. size of topDoor changes with screen too
    // 4inch
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        topDoorView.frame = CGRectMake(0, 0, 320, 284);
        topDoor.frame = CGRectMake(0, 0, 320, 284);
        botDoorView.frame = CGRectMake(0, 284, 320, 284);
        botDoor.frame = CGRectMake(0, 0, 320, 284);//(0, 0) based on superviews bounds
        botPanelView.frame = CGRectMake(13, 568, 294, 91);
    }
    // 3.5inch
    else {
        topDoorView.frame = CGRectMake(0, 0, 320, 240);
        topDoor.frame = CGRectMake(0, 0, 320, 240);
        botDoorView.frame = CGRectMake(0, 240, 320, 240);
        botDoor.frame = CGRectMake(0, 0, 320, 240);//(0,0) based on superview's bounds
        botPanelView.frame = CGRectMake(13, 480, 294, 91);
    }
    
    // center the centerPanelView regardless
    centerPanelView.center = centerPanelView.superview.center;
}

@end
