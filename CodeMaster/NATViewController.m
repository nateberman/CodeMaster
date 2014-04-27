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

// set up frames, panels and images
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
    
    // set the centerPanel to display proper contents
    centerPanelHome.hidden = NO;
    //
    centerPanelPlay.hidden = YES;
    centerPanelTutorial.hidden = YES;
    centerPanelCredits.hidden = YES;
    centerPanelDifficulty.hidden = YES;
    
    // hide debug view
    devTestView.hidden = YES;
    
    // configure Difficulty contents
    // allowDuplicates button
    [buttonAllowDuplicates setImage:[UIImage imageNamed:@"ToggleOff.png"] forState:UIControlStateNormal];
    [buttonAllowDuplicates setImage:[UIImage imageNamed:@"ToggleOn.png"] forState:UIControlStateSelected];
    // randomizeHints button
    [buttonRandomizeHints setImage:[UIImage imageNamed:@"ToggleOff.png"] forState:UIControlStateNormal];
    [buttonRandomizeHints setImage:[UIImage imageNamed:@"ToggleOn.png"] forState:UIControlStateSelected];
    
    // set images for code answer choices
    [_choiceOneButton setImage:[UIImage imageNamed:@"buttonBlueNormal.png"] forState:UIControlStateNormal];
    [_choiceOneButton setImage:[UIImage imageNamed:@"buttonBlueHilight.png"] forState:UIControlStateSelected];
    [_choiceTwoButton setImage:[UIImage imageNamed:@"buttonGreenNormal.png"] forState:UIControlStateNormal];
    [_choiceTwoButton setImage:[UIImage imageNamed:@"buttonGreenHilight.png"] forState:UIControlStateSelected];
    [_choiceThreeButton setImage:[UIImage imageNamed:@"buttonYellowNormal.png"] forState:UIControlStateNormal];
    [_choiceThreeButton setImage:[UIImage imageNamed:@"buttonYellowHilight.png"] forState:UIControlStateSelected];
    [_choiceFourButton setImage:[UIImage imageNamed:@"buttonOrangeNormal.png"] forState:UIControlStateNormal];
    [_choiceFourButton setImage:[UIImage imageNamed:@"buttonOrangeHilight.png"] forState:UIControlStateSelected];
    [_choiceFiveButton setImage:[UIImage imageNamed:@"buttonRedNormal.png"] forState:UIControlStateNormal];
    [_choiceFiveButton setImage:[UIImage imageNamed:@"buttonRedHilight.png"] forState:UIControlStateSelected];
    [_choiceSixButton setImage:[UIImage imageNamed:@"buttonTealNormal.png"] forState:UIControlStateNormal];
    [_choiceSixButton setImage:[UIImage imageNamed:@"buttonTealHilight.png"] forState:UIControlStateSelected];
    
    // set images for code answer holes
    [_holeOneA setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeTwoA setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeThreeA setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeFourA setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeOneB setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeTwoB setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeThreeB setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeFourB setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeOneC setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeTwoC setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeThreeC setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeFourC setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeOneD setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeTwoD setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeThreeD setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeFourD setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeOneE setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeTwoE setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeThreeE setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeFourE setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeOneF setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeTwoF setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeThreeF setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
    [_holeFourF setImage:[UIImage imageNamed:@"hole.png"] forState:UIControlStateNormal];
}

// opening animation
- (void)openDoors {
    [UIImageView animateWithDuration:0.8
                               delay:0.2
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:^{
                              // 4inch screen
                              if([[UIScreen mainScreen] bounds].size.height == 568){
                                  topDoorView.frame = CGRectMake(0, -330, 320, 301);
                                  botDoorView.frame = CGRectMake(0, 568, 320, 287);
                                  gameOverView.frame = CGRectMake(80, -90, 160, 90);
                              }
                              // 3.5inch screen
                              else {
                                  topDoorView.frame = CGRectMake(0, -305, 320, 301);
                                  botDoorView.frame = CGRectMake(0, 480, 320, 287);
                                  gameOverView.frame = CGRectMake(80, -90, 160, 90);
                              }
                          } completion:^(BOOL finished) {
                              // ensure our gameOverView is hidden
                              gameOverView.hidden = YES;
                          }];
}


@end
