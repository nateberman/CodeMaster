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

// setup for our audioPlayer
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

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
                                  topDoorView.frame = CGRectMake(0, -350, 320, 301);
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

// if currentGame = YES do not change the secret code
// else run new game method
- (IBAction)buttonPlay:(id)sender{
    if(!currentGame){
        [self newGame];
    }
    [UIView transitionWithView:centerPanelView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        centerPanelHome.hidden = YES;
                        centerPanelPlay.hidden = NO;
                        centerPanelActive = centerPanelPlay;
                    } completion:^(BOOL finished) {
                        [self showTopAndBot];
                    }];
    
    [self swoosh];
}

// view difficulty panel
- (IBAction)buttonDifficulty:(id)sender {
    
    [UIView transitionWithView:centerPanelView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        centerPanelHome.hidden = YES;
                        centerPanelDifficulty.hidden = NO;
                        centerPanelActive = centerPanelDifficulty;
                    } completion:^(BOOL finished) {
                        // audio anouncement
                        // NSString to be turned into NSURL containing audio file path
                        NSString *audioPath;
                        // select sound
                        audioPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"difficulty"] ofType:@"mp3"];
                        // create NSURL and pass file with audio path
                        NSURL *url;
                        url = [NSURL fileURLWithPath:audioPath];
                        // accessing a variable from outside the method _audioPlayer
                        // allocate and initiate our audioPlayer with contents of NSURL we created
                        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
                        // play sound
                        [_audioPlayer play];
                    }];
    
    [self swoosh];
}
// increase difficuly by allowing duplicate colors in code
- (IBAction)buttonAllowDuplicates:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // if the toggle is off, indicated by 0 or nil, toggle switch and set defaults key
    if([defaults integerForKey:@"duplicateColorToggle"] == 0 || nil){
        buttonAllowDuplicates.selected = YES;
        [defaults setInteger:1 forKey:@"duplicateColorToggle"];
    }
    else {
        [defaults setInteger:0 forKey:@"duplicateColorToggle"];
        buttonAllowDuplicates.selected = NO;
    }
}
// increase difficulty by randomizing hint order
- (IBAction)buttonRandomizeHints:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // if the toggle is off, indicated by 0 or nil, toggle switch and set defaults key
    if([defaults integerForKey:@"randomHintToggle"] == 0 || nil){
        buttonRandomizeHints.selected = YES;
        [defaults setInteger:1 forKey:@"randomHintToggle"];
    }
    else {
        [defaults setInteger:0 forKey:@"randomHintToggle"];
        buttonRandomizeHints.selected = NO;
    }
}

// view tutorial panel
- (IBAction)buttonTutorial:(id)sender {
    
    [UIView transitionWithView:centerPanelView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        centerPanelHome.hidden = YES;
                        centerPanelTutorial.hidden = NO;
                        centerPanelActive = centerPanelTutorial;
                    } completion:^(BOOL finished) {
                        // audio anouncement
                        // NSString to be turned into NSURL containing audio file path
                        NSString *audioPath;
                        // select sound
                        audioPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tutorial"] ofType:@"mp3"];
                        // create NSURL and pass file with audio path
                        NSURL *url;
                        url = [NSURL fileURLWithPath:audioPath];
                        // accessing a variable from outside the method _audioPlayer
                        // allocate and initiate our audioPlayer with contents of NSURL we created
                        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
                        // play sound
                        [_audioPlayer play];
                    }];
    [self swoosh];
}

// view credits panel
- (IBAction)buttonCredits:(id)sender {
    
    [UIView transitionWithView:centerPanelView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        centerPanelHome.hidden = YES;
                        centerPanelCredits.hidden = NO;
                        centerPanelActive = centerPanelCredits;
                    } completion:^(BOOL finished) {
                        // audio anouncement
                        // NSString to be turned into NSURL containing audio file path
                        NSString *audioPath;
                        // select sound
                        audioPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"credits"] ofType:@"mp3"];
                        // create NSURL and pass file with audio path
                        NSURL *url;
                        url = [NSURL fileURLWithPath:audioPath];
                        // accessing a variable from outside the method _audioPlayer
                        // allocate and initiate our audioPlayer with contents of NSURL we created
                        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
                        // play sound
                        [_audioPlayer play];
                    }];
    [self swoosh];
}

// all important back button
- (IBAction)buttonBack:(id)sender {
    // if we're leaving play view retract top and bot panels
    if (centerPanelActive == centerPanelPlay){
        [self hideTopAndBot];
    }
    
    // centerPanel flip animation
    [UIView transitionWithView:centerPanelView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        centerPanelActive.hidden = YES;
                        centerPanelHome.hidden = NO;
                    } completion:^(BOOL finished) {
                        //
                    }];
    [self swoosh];
}

// set points of user interaction
// reset image states
// create new secret code
// set currentGame = YES
// reset number of attempts
- (void)newGame {
    //set up our codeCover
    codeCover.alpha = 0;
    
    //lets turn on our 1st attemptView so the user can interact with the game
    [_attemptAView setUserInteractionEnabled:YES];
    
    //lets turn off our 2nd+ attempt Views so the user can only interact with the first set of code holes
    [_attemptBView setUserInteractionEnabled:NO];
    [_attemptCView setUserInteractionEnabled:NO];
    [_attemptDView setUserInteractionEnabled:NO];
    [_attemptEView setUserInteractionEnabled:NO];
    [_attemptFView setUserInteractionEnabled:NO];
    
    //reset all of our hole states so they show the proper images as set in our configureLaunch method
    _holeOneA.selected = NO;
    _holeTwoA.selected = NO;
    _holeThreeA.selected = NO;
    _holeFourA.selected = NO;
    _holeOneB.selected = NO;
    _holeTwoB.selected = NO;
    _holeThreeB.selected = NO;
    _holeFourB.selected = NO;
    _holeOneC.selected = NO;
    _holeTwoC.selected = NO;
    _holeThreeC.selected = NO;
    _holeFourC.selected = NO;
    _holeOneD.selected = NO;
    _holeTwoD.selected = NO;
    _holeThreeD.selected = NO;
    _holeFourD.selected = NO;
    _holeOneE.selected = NO;
    _holeTwoE.selected = NO;
    _holeThreeE.selected = NO;
    _holeFourE.selected = NO;
    _holeOneF.selected = NO;
    _holeTwoF.selected = NO;
    _holeThreeF.selected = NO;
    _holeFourF.selected = NO;
    
    //reset all of our hint images
    hintOneA.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintTwoA.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintThreeA.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintFourA.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintOneB.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintTwoB.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintThreeB.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintFourB.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintOneC.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintTwoC.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintThreeC.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintFourC.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintOneD.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintTwoD.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintThreeD.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintFourD.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintOneE.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintTwoE.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintThreeE.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintFourE.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintOneF.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintTwoF.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintThreeF.image = [UIImage imageNamed:@"hintEmpty.png"];
    hintFourF.image = [UIImage imageNamed:@"hintEmpty.png"];
    
    //clear our developer tool view
    selectedImage.image = nil;
    hint1.image = nil;
    hint2.image = nil;
    hint3.image = nil;
    hint4.image = nil;
    
    //disable our buttonSubmit
    [_buttonSubmit setUserInteractionEnabled:NO];
    
    //set our currentGame status so our settings are static
    currentGame = YES;
    
    //generate a new secret code
    [self generateCode];
    
    //reset attempt count
    attemptCount = 1;
}

// generate a random secret code
// take into account duplicate entry difficulty setting
- (void)generateCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"NSUserDefaults intergerForKey duplicateColorToggle is %d", [defaults integerForKey:@"duplicateColorToggle"]);
    
    // if duplicateColorToggle is on then easy generate code
    if([defaults integerForKey:@"duplicateColorToggle"] == 1){
        codeOne.image = [self randomImage].image;
        codeTwo.image = [self randomImage].image;
        codeThree.image = [self randomImage].image;
        codeFour.image = [self randomImage].image;
    }
    // if duplicateColorToggle is off then ensure we dont duplicate any code entries
    else {
        codeOne.image = [self randomImage].image;
        do {
            codeTwo.image = [self randomImage].image;
        } while (codeTwo.image == codeOne.image);
        do {
            codeThree.image = [self randomImage].image;
        } while ((codeThree.image == codeOne.image) || (codeThree.image == codeTwo.image));
        do {
            codeFour.image = [self randomImage].image;
        } while ((codeFour.image == codeOne.image) || (codeFour.image == codeTwo.image) || (codeFour.image == codeThree.image));
    }
}

// serve a random image for our secret code
- (UIImageView *)randomImage {
    // create our selectable imageviews and their images
    UIImageView *blue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buttonBlueHilight.png"]];
    UIImageView *green = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buttonGreenHilight.png"]];
    UIImageView *yellow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buttonYellowHilight.png"]];
    UIImageView *orange = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buttonOrangeHilight.png"]];
    UIImageView *red = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buttonRedHilight.png"]];
    UIImageView *teal = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buttonTealHilight.png"]];
    // toss em in an array
    NSArray *imagesArray = [[NSArray alloc]initWithObjects:blue, green, yellow, orange, red, teal, nil];
    
    //randomly choose and return from array
    return [imagesArray objectAtIndex:(arc4random() % imagesArray.count)];
}

// animate top and bot panels for gameplay
- (void)showTopAndBot {
    // slide top and bot panels in to view
    [UIImageView animateWithDuration:0.3
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseOut
                          animations:^{
                              // 4inch screen
                              if([[UIScreen mainScreen] bounds].size.height == 568){
                                  topPanelView.frame = CGRectMake(13, 0, 294, 91);
                                  botPanelView.frame = CGRectMake(13, 477, 294, 91);
                              }
                              // 3.5inch screen
                              else {
                                  topPanelView.frame = CGRectMake(13, 0, 294, 91);
                                  botPanelView.frame = CGRectMake(13, 390, 294, 91);
                              }
                          } completion:^(BOOL finished) {
                              // add a bounce
                             [UIImageView animateWithDuration:0.2
                                                        delay:0.1
                                                      options:UIViewAnimationOptionCurveEaseOut
                                                   animations:^{
                                                       topPanelView.frame = CGRectMake(13, -5, 294, 91);
                                                       botPanelView.frame = CGRectMake(13, botPanelView.frame.origin.y+5, 294, 91);
                                                   } completion:^(BOOL finished) {
                                                       //
                                                   }];
                          }];
}

// animate top and bot panels away for menu access
- (void)hideTopAndBot {
    //before we retract the top and bot we want to give them a little bump to feel more fun, bringing them in 7px
    [UIImageView animateWithDuration:0.2
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn //choose ease in to simulate hang time
                          animations:^{
                              
                              topPanelView.frame = CGRectMake(13, topPanelView.frame.origin.y + 7, 294, 91);
                              botPanelView.frame = CGRectMake(13, botPanelView.frame.origin.y - 7, 294, 91);
                              
                          }
     // retract panels
                          completion:^(BOOL finished) {
                              [UIImageView animateWithDuration:0.3
                                                         delay:0.1 // add hang time
                                                       options:UIViewAnimationOptionCurveEaseIn
                                                    animations:^{
                                                        // 4inch
                                                        if([[UIScreen mainScreen]bounds].size.height == 568){
                                                            topPanelView.frame = CGRectMake(13, -91, 294, 91);
                                                            botPanelView.frame = CGRectMake(13, 568, 294, 91);
                                                        }
                                                        // 3.5inch
                                                        else{
                                                            topPanelView.frame = CGRectMake(13, -91, 294, 91);
                                                            botPanelView.frame = CGRectMake(13, 480, 294, 91);
                                                        }
                                                    }completion:^(BOOL finished) {}];
                          }];
}

// game menu access
- (IBAction)buttonMenu:(id)sender {
    // hide our top and bot panels
    [self hideTopAndBot];
    // show centerPanelHome
    centerPanelHome.hidden = NO;
    // hide centerPanelPlay
    centerPanelPlay.hidden = YES;
}

// play again
- (IBAction)buttonPlayAgain:(id)sender {
    [self newGame];
    [self openDoors];
}

// audio effect
- (void)swoosh {
    
}

// add some pizazz to the background
- (void)randomLight {
    
}

#pragma mark CHOICE BUTTONS
- (IBAction)choiceOneButton:(id)sender {
    // check to see if choice is already selected
    // if not selected deselect any other buttons to set focus
    // set selectedImage's image to the button's UIControlStateSelected image and set the button state to selected
    if(_choiceOneButton.selected == NO) {
        [self deselectChoices];
        selectedImage.image = [_choiceOneButton imageForState:UIControlStateSelected];
        _choiceOneButton.selected = YES;
    }
    // if the button is already selected turn off the selection and clear the selectedImage
    else {
        _choiceOneButton.selected = NO;
        selectedImage.image = nil;
    }
}
- (IBAction)choiceTwoButton:(id)sender {
    // check to see if choice is already selected
    // if not selected deselect any other buttons to set focus
    // set selectedImage's image to the button's UIControlStateSelected image and set the button state to selected
    if(_choiceTwoButton.selected == NO) {
        [self deselectChoices];
        selectedImage.image = [_choiceTwoButton imageForState:UIControlStateSelected];
        _choiceTwoButton.selected = YES;
    }
    // if the button is already selected turn off the selection and clear the selectedImage
    else {
        _choiceTwoButton.selected = NO;
        selectedImage.image = nil;
    }
}
- (IBAction)choiceThreeButton:(id)sender {
    // check to see if choice is already selected
    // if not selected deselect any other buttons to set focus
    // set selectedImage's image to the button's UIControlStateSelected image and set the button state to selected
    if(_choiceThreeButton.selected == NO) {
        [self deselectChoices];
        selectedImage.image = [_choiceThreeButton imageForState:UIControlStateSelected];
        _choiceThreeButton.selected = YES;
    }
    // if the button is already selected turn off the selection and clear the selectedImage
    else {
        _choiceThreeButton.selected = NO;
        selectedImage.image = nil;
    }
}
- (IBAction)choiceFourButton:(id)sender {
    // check to see if choice is already selected
    // if not selected deselect any other buttons to set focus
    // set selectedImage's image to the button's UIControlStateSelected image and set the button state to selected
    if(_choiceFourButton.selected == NO) {
        [self deselectChoices];
        selectedImage.image = [_choiceFourButton imageForState:UIControlStateSelected];
        _choiceFourButton.selected = YES;
    }
    // if the button is already selected turn off the selection and clear the selectedImage
    else {
        _choiceFourButton.selected = NO;
        selectedImage.image = nil;
    }
}
- (IBAction)choiceFiveButton:(id)sender {
    // check to see if choice is already selected
    // if not selected deselect any other buttons to set focus
    // set selectedImage's image to the button's UIControlStateSelected image and set the button state to selected
    if(_choiceFiveButton.selected == NO) {
        [self deselectChoices];
        selectedImage.image = [_choiceFiveButton imageForState:UIControlStateSelected];
        _choiceFiveButton.selected = YES;
    }
    // if the button is already selected turn off the selection and clear the selectedImage
    else {
        _choiceFiveButton.selected = NO;
        selectedImage.image = nil;
    }
}
- (IBAction)choiceSixButton:(id)sender {
    // check to see if choice is already selected
    // if not selected deselect any other buttons to set focus
    // set selectedImage's image to the button's UIControlStateSelected image and set the button state to selected
    if(_choiceSixButton.selected == NO) {
        [self deselectChoices];
        selectedImage.image = [_choiceSixButton imageForState:UIControlStateSelected];
        _choiceSixButton.selected = YES;
    }
    // if the button is already selected turn off the selection and clear the selectedImage
    else {
        _choiceSixButton.selected = NO;
        selectedImage.image = nil;
    }
}

// deselect choices to force focus on single selection
- (void) deselectChoices {
    _choiceOneButton.selected = NO;
    _choiceTwoButton.selected = NO;
    _choiceThreeButton.selected = NO;
    _choiceFourButton.selected = NO;
    _choiceFiveButton.selected = NO;
    _choiceSixButton.selected = NO;
}

#pragma mark HOLE BUTTONS
- (IBAction)holeOneA:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeOneA.selected = NO;
        [_holeOneA setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeOneA setImage:selectedImage.image forState:UIControlStateSelected];
        _holeOneA.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneA.selected) || (!_holeTwoA.selected) || (!_holeThreeA.selected) || (!_holeFourA.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeTwoA:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeTwoA.selected = NO;
        [_holeTwoA setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeTwoA setImage:selectedImage.image forState:UIControlStateSelected];
        _holeTwoA.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneA.selected) || (!_holeTwoA.selected) || (!_holeThreeA.selected) || (!_holeFourA.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeThreeA:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeThreeA.selected = NO;
        [_holeThreeA setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeThreeA setImage:selectedImage.image forState:UIControlStateSelected];
        _holeThreeA.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneA.selected) || (!_holeTwoA.selected) || (!_holeThreeA.selected) || (!_holeFourA.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeFourA:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeFourA.selected = NO;
        [_holeFourA setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeFourA setImage:selectedImage.image forState:UIControlStateSelected];
        _holeFourA.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneA.selected) || (!_holeTwoA.selected) || (!_holeThreeA.selected) || (!_holeFourA.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeOneB:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeOneB.selected = NO;
        [_holeOneB setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeOneB setImage:selectedImage.image forState:UIControlStateSelected];
        _holeOneB.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneB.selected) || (!_holeTwoB.selected) || (!_holeThreeB.selected) || (!_holeFourB.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeTwoB:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeTwoB.selected = NO;
        [_holeTwoB setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeTwoB setImage:selectedImage.image forState:UIControlStateSelected];
        _holeTwoB.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneB.selected) || (!_holeTwoB.selected) || (!_holeThreeB.selected) || (!_holeFourB.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeThreeB:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeThreeB.selected = NO;
        [_holeThreeB setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeThreeB setImage:selectedImage.image forState:UIControlStateSelected];
        _holeThreeB.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneB.selected) || (!_holeTwoB.selected) || (!_holeThreeB.selected) || (!_holeFourB.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeFourB:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeFourB.selected = NO;
        [_holeFourB setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeFourB setImage:selectedImage.image forState:UIControlStateSelected];
        _holeFourB.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneB.selected) || (!_holeTwoB.selected) || (!_holeThreeB.selected) || (!_holeFourB.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeOneC:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeOneC.selected = NO;
        [_holeOneC setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeOneC setImage:selectedImage.image forState:UIControlStateSelected];
        _holeOneC.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneC.selected) || (!_holeTwoC.selected) || (!_holeThreeC.selected) || (!_holeFourC.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeTwoC:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeTwoC.selected = NO;
        [_holeTwoC setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeTwoC setImage:selectedImage.image forState:UIControlStateSelected];
        _holeTwoC.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneC.selected) || (!_holeTwoC.selected) || (!_holeThreeC.selected) || (!_holeFourC.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeThreeC:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeThreeC.selected = NO;
        [_holeThreeC setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeThreeC setImage:selectedImage.image forState:UIControlStateSelected];
        _holeThreeC.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneC.selected) || (!_holeTwoC.selected) || (!_holeThreeC.selected) || (!_holeFourC.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeFourC:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeFourC.selected = NO;
        [_holeFourC setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeFourC setImage:selectedImage.image forState:UIControlStateSelected];
        _holeFourC.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneC.selected) || (!_holeTwoC.selected) || (!_holeThreeC.selected) || (!_holeFourC.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeOneD:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeOneD.selected = NO;
        [_holeOneD setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeOneD setImage:selectedImage.image forState:UIControlStateSelected];
        _holeOneD.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneD.selected) || (!_holeTwoD.selected) || (!_holeThreeD.selected) || (!_holeFourD.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeTwoD:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeTwoD.selected = NO;
        [_holeTwoD setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeTwoD setImage:selectedImage.image forState:UIControlStateSelected];
        _holeTwoD.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneD.selected) || (!_holeTwoD.selected) || (!_holeThreeD.selected) || (!_holeFourD.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeThreeD:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeThreeD.selected = NO;
        [_holeThreeD setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeThreeD setImage:selectedImage.image forState:UIControlStateSelected];
        _holeThreeD.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneD.selected) || (!_holeTwoD.selected) || (!_holeThreeD.selected) || (!_holeFourD.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeFourD:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeFourD.selected = NO;
        [_holeFourD setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeFourD setImage:selectedImage.image forState:UIControlStateSelected];
        _holeFourD.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneD.selected) || (!_holeTwoD.selected) || (!_holeThreeD.selected) || (!_holeFourD.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeOneE:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeOneE.selected = NO;
        [_holeOneE setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeOneE setImage:selectedImage.image forState:UIControlStateSelected];
        _holeOneE.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneE.selected) || (!_holeTwoE.selected) || (!_holeThreeE.selected) || (!_holeFourE.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeTwoE:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeTwoE.selected = NO;
        [_holeTwoE setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeTwoE setImage:selectedImage.image forState:UIControlStateSelected];
        _holeTwoE.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneE.selected) || (!_holeTwoE.selected) || (!_holeThreeE.selected) || (!_holeFourE.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeThreeE:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeThreeE.selected = NO;
        [_holeThreeE setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeThreeE setImage:selectedImage.image forState:UIControlStateSelected];
        _holeThreeE.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneE.selected) || (!_holeTwoE.selected) || (!_holeThreeE.selected) || (!_holeFourE.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeFourE:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeFourE.selected = NO;
        [_holeFourE setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeFourE setImage:selectedImage.image forState:UIControlStateSelected];
        _holeFourE.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneE.selected) || (!_holeTwoE.selected) || (!_holeThreeE.selected) || (!_holeFourE.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeOneF:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeOneF.selected = NO;
        [_holeOneF setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeOneF setImage:selectedImage.image forState:UIControlStateSelected];
        _holeOneF.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneF.selected) || (!_holeTwoF.selected) || (!_holeThreeF.selected) || (!_holeFourF.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeTwoF:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeTwoF.selected = NO;
        [_holeTwoF setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeTwoF setImage:selectedImage.image forState:UIControlStateSelected];
        _holeTwoF.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneF.selected) || (!_holeTwoF.selected) || (!_holeThreeF.selected) || (!_holeFourF.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeThreeF:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeThreeF.selected = NO;
        [_holeThreeF setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeThreeF setImage:selectedImage.image forState:UIControlStateSelected];
        _holeThreeF.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneF.selected) || (!_holeTwoF.selected) || (!_holeThreeF.selected) || (!_holeFourF.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}
- (IBAction)holeFourF:(id)sender {
    //first check to see if our selectedImage is nil, if it is pressing the button should have no apparent effect and we should ensure the selected state image is nil
    if (selectedImage.image == nil){
        _holeFourF.selected = NO;
        [_holeFourF setImage:nil forState:UIControlStateSelected];
    }
    //if there is an image in selectedImage we set our button's selected state to have that image and change our button state to selected so it displays
    else {
        [_holeFourF setImage:selectedImage.image forState:UIControlStateSelected];
        _holeFourF.selected = YES;
    }
    
    //check to ensure all of our holes are filled in the row to enable / disable our submit button appropriately
    if ((!_holeOneF.selected) || (!_holeTwoF.selected) || (!_holeThreeF.selected) || (!_holeFourF.selected)){
        [_buttonSubmit setUserInteractionEnabled:NO];
    } else { [_buttonSubmit setUserInteractionEnabled:YES]; }
}

@end
