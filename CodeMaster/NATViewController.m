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
// submit a code
- (IBAction)buttonSubmit:(id)sender {
    
    // disable submit button
    [_buttonSubmit setUserInteractionEnabled:NO];
    
    // prepare to access NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // deselect all choices
    [self deselectChoices];
    selectedImage.image = nil;
    
    // compare submitted code to secret code
    // the comparison will set the hint1-4 images
    
    ///////////////////////////////////////////// ATTEMPT 1 ///////////////////////////////////////////////////
    if (attemptCount == 1){
       //
        UIImageView *holeOne = [[UIImageView alloc]initWithImage:[_holeOneA imageForState:UIControlStateSelected]];
        UIImageView *holeTwo = [[UIImageView alloc]initWithImage:[_holeTwoA imageForState:UIControlStateSelected]];
        UIImageView *holeThree = [[UIImageView alloc]initWithImage:[_holeThreeA imageForState:UIControlStateSelected]];
        UIImageView *holeFour = [[UIImageView alloc]initWithImage:[_holeFourA imageForState:UIControlStateSelected]];
        
        // send our hole UIImageViews to be compared to code
        [self compareCodeAnswerOne:holeOne answerTwo:holeTwo answerThree:holeThree answerFour:holeFour];
        
        // set hint images based on returned hint1-4
        [hintOneA setImage: hint1.image];
        [hintTwoA setImage: hint2.image];
        [hintThreeA setImage: hint3.image];
        [hintFourA setImage: hint4.image];
        
        //check for a win. if no win increment attempt count
        // disable current attempt view interaction. enable next attempt view interaction
        if(![self didWin]) {
            [_attemptAView setUserInteractionEnabled:NO];
            attemptCount += 1;
            [_attemptBView setUserInteractionEnabled:YES];
            
            // randomize hints based on difficulty
            if ([defaults integerForKey:@"randomHintsNow"] == 1){
                // handle random hints
            }
            else {
                // not random hints
            }
        }
        // win scenario
        else {
            // closing doors is handled by didWin method
            // show hidden code
            codeCover.alpha = 0;
        }
    }
    ///////////////////////////////////////////// ATTEMPT 2 ///////////////////////////////////////////////////
    else if (attemptCount == 2){
        //create our hole UIImageViews that hold our selection to pass to the compareCodeAnswer method
        UIImageView *holeOne = [[UIImageView alloc]initWithImage:[_holeOneB imageForState:UIControlStateSelected]];
        UIImageView *holeTwo = [[UIImageView alloc]initWithImage:[_holeTwoB imageForState:UIControlStateSelected]];
        UIImageView *holeThree = [[UIImageView alloc]initWithImage:[_holeThreeB imageForState:UIControlStateSelected]];
        UIImageView *holeFour = [[UIImageView alloc]initWithImage:[_holeFourB imageForState:UIControlStateSelected]];
        
        //send our hole UIImageViews to be compared to the code
        [self compareCodeAnswerOne:holeOne answerTwo:holeTwo answerThree:holeThree answerFour:holeFour];
        
        //and now we set our row hint images to the returned hint1-4 images
        [hintOneB setImage: hint1.image];
        [hintTwoB setImage: hint2.image];
        [hintThreeB setImage: hint3.image];
        [hintFourB setImage: hint4.image];
        
        //check for a win. if the player did not win we increment the attemptCount, disable all the row2 buttons, enable all the row3 buttons, and set all the row2 hole smileys to sad faces
        if (![self didWin]){
            //disable attemptBView
            [_attemptBView setUserInteractionEnabled:NO];
            //increase attemptCount
            attemptCount = attemptCount+1;
            //enable attemptCView
            [_attemptCView setUserInteractionEnabled:YES];
            if ([defaults integerForKey:@"randomHintsNow"] == 1){
                //handle "random" visual queues
            }
            else {
                //handle not "random" visual queues
            }
        }
        
        //WIN SCENARIO
        else {
            //the win scenario closeDoors is handled by the didWin method
            
            //show our player the hidden code
            codeCover.alpha = 0;
        }
        
    }
    
    ///////////////////////////////////////////// ATTEMPT 3 ///////////////////////////////////////////////////
    else if (attemptCount == 3){
        //create our hole UIImageViews that hold our selection to pass to the compareCodeAnswer method
        UIImageView *holeOne = [[UIImageView alloc]initWithImage:[_holeOneC imageForState:UIControlStateSelected]];
        UIImageView *holeTwo = [[UIImageView alloc]initWithImage:[_holeTwoC imageForState:UIControlStateSelected]];
        UIImageView *holeThree = [[UIImageView alloc]initWithImage:[_holeThreeC imageForState:UIControlStateSelected]];
        UIImageView *holeFour = [[UIImageView alloc]initWithImage:[_holeFourC imageForState:UIControlStateSelected]];
        
        //send our hole UIImageViews to be compared to the code
        [self compareCodeAnswerOne:holeOne answerTwo:holeTwo answerThree:holeThree answerFour:holeFour];
        
        //and now we set our row hint images to the returned hint1-4 images
        [hintOneC setImage: hint1.image];
        [hintTwoC setImage: hint2.image];
        [hintThreeC setImage: hint3.image];
        [hintFourC setImage: hint4.image];
        
        //check for a win. if the player did not win we increment the attemptCount, disable all the row3 buttons, enable all the row4 buttons, and set all the row3 hole smileys to sad faces
        if (![self didWin]){
            //disable attemptCView
            [_attemptCView setUserInteractionEnabled:NO];
            //increase our attemptCount
            attemptCount = attemptCount+1;
            //enable attemptDView
            [_attemptDView setUserInteractionEnabled:YES];
            
            if ([defaults integerForKey:@"randomHintsNow"] == 1){
                //handle "random" visual queues
            }
            else {
                //handle not 'random' visual queues
            }
        }
        
        //WIN SCENARIO
        else {
            //the win scenario closeDoors is handled by the didWin method
            
            //show our player the hidden code
            codeCover.alpha = 0;
        }
    }
    
    ///////////////////////////////////////////// ATTEMPT 4 ///////////////////////////////////////////////////
    else if (attemptCount == 4){
        //create our hole UIImageViews that hold our selection to pass to the compareCodeAnswer method
        UIImageView *holeOne = [[UIImageView alloc]initWithImage:[_holeOneD imageForState:UIControlStateSelected]];
        UIImageView *holeTwo = [[UIImageView alloc]initWithImage:[_holeTwoD imageForState:UIControlStateSelected]];
        UIImageView *holeThree = [[UIImageView alloc]initWithImage:[_holeThreeD imageForState:UIControlStateSelected]];
        UIImageView *holeFour = [[UIImageView alloc]initWithImage:[_holeFourD imageForState:UIControlStateSelected]];
        
        //send our hole UIImageViews to be compared to the code
        [self compareCodeAnswerOne:holeOne answerTwo:holeTwo answerThree:holeThree answerFour:holeFour];
        
        //and now we set our row hint images to the returned hint1-4 images
        [hintOneD setImage: hint1.image];
        [hintTwoD setImage: hint2.image];
        [hintThreeD setImage: hint3.image];
        [hintFourD setImage: hint4.image];
        
        //check for a win. if the player did not win we increment the attemptCount, disable all the row4 buttons, enable all the row5 buttons, and set all the row4 hole smileys to sad faces
        if (![self didWin]){
            //disable attemptDView
            [_attemptDView setUserInteractionEnabled:NO];
            //increment our attemptCount
            attemptCount = attemptCount+1;
            //enable attemptEView
            [_attemptEView setUserInteractionEnabled:YES];
            
            if ([defaults integerForKey:@"randomHintsNow"] == 1){
                //handle 'random' visual queues
            }
            else {
                //handle not 'random' visual queues
            }
        }
        
        //WIN SCENARIO
        else {
            //the win scenario closeDoors is handled by the didWin method
            
            //show our player the hidden code
            codeCover.alpha = 0;
        }
        
    }
    
    ///////////////////////////////////////////// ATTEMPT 5 ///////////////////////////////////////////////////
    else if (attemptCount == 5){
        //create our hole UIImageViews that hold our selection to pass to the compareCodeAnswer method
        UIImageView *holeOne = [[UIImageView alloc]initWithImage:[_holeOneE imageForState:UIControlStateSelected]];
        UIImageView *holeTwo = [[UIImageView alloc]initWithImage:[_holeTwoE imageForState:UIControlStateSelected]];
        UIImageView *holeThree = [[UIImageView alloc]initWithImage:[_holeThreeE imageForState:UIControlStateSelected]];
        UIImageView *holeFour = [[UIImageView alloc]initWithImage:[_holeFourE imageForState:UIControlStateSelected]];
        
        //send our hole UIImageViews to be compared to the code
        [self compareCodeAnswerOne:holeOne answerTwo:holeTwo answerThree:holeThree answerFour:holeFour];
        
        //and now we set our row hint images to the returned hint1-4 images
        [hintOneE setImage: hint1.image];
        [hintTwoE setImage: hint2.image];
        [hintThreeE setImage: hint3.image];
        [hintFourE setImage: hint4.image];
        
        //check for a win. if the player did not win we increment the attemptCount, disable all the row5 buttons, enable all the row6 buttons, and set all the row5 hole smileys to sad faces
        if (![self didWin]){
            //disable attemptEView
            [_attemptEView setUserInteractionEnabled:NO];
            //increment our attemptCount
            attemptCount = attemptCount+1;
            //enable our attemptFView
            [_attemptFView setUserInteractionEnabled:YES];
            
            if ([defaults integerForKey:@"randomHintsNow"] == 1){
                //handle 'random' visual queues
            }
            else {
                //handle not 'random' visual queues
            }
        }
        
        //WIN SCENARIO
        else {
            //the win scenario closeDoors is handled by the didWin method
            
            //show our player the hidden code
            codeCover.alpha = 0;
        }
    }
    
    ///////////////////////////////////////////// ATTEMPT 6 ///////////////////////////////////////////////////
    else if (attemptCount == 6){
        //create our hole UIImageViews that hold our selection to pass to the compareCodeAnswer method
        UIImageView *holeOne = [[UIImageView alloc]initWithImage:[_holeOneF imageForState:UIControlStateSelected]];
        UIImageView *holeTwo = [[UIImageView alloc]initWithImage:[_holeTwoF imageForState:UIControlStateSelected]];
        UIImageView *holeThree = [[UIImageView alloc]initWithImage:[_holeThreeF imageForState:UIControlStateSelected]];
        UIImageView *holeFour = [[UIImageView alloc]initWithImage:[_holeFourF imageForState:UIControlStateSelected]];
        
        //send our hole UIImageViews to be compared to the code
        [self compareCodeAnswerOne:holeOne answerTwo:holeTwo answerThree:holeThree answerFour:holeFour];
        
        //and now we set our row hint images to the returned hint1-4 images
        [hintOneF setImage: hint1.image];
        [hintTwoF setImage: hint2.image];
        [hintThreeF setImage: hint3.image];
        [hintFourF setImage: hint4.image];
        
        //since this is the last attempt we know we will turn off attemptFView so lets do that now
        [_attemptFView setUserInteractionEnabled:NO];
        
        //check for a win. if the player did not win we disable all the row6 buttons, display the playAgainButton, and set all the row6 hole smileys to sad faces. else, the player did win, so we show the code
        if (![self didWin]){
            
            //show youLose UIImageView and keep the code hidden
            //lets animate the youLose UIImageView to fade in to make the transition nicer
            //            [self.view addSubview:youLose];
            
            //last attempt and did not win, lets do our closeDoors
            [self closeDoors];
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 //youLose.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                             }];
            
            codeCover.alpha = 0;
            
            //playAgainButton
            
        }
        
        //WIN SCENARIO
        else {
            //the win scenario closeDoors is handled by the didWin method
            
            //disable our attemptFView
            [_attemptFView setUserInteractionEnabled:NO];
            
            codeCover.alpha = 0;
        }
    }
    
}
// compare submitted code with secret code
// if there is a perfect match for a hole make the hint#'s image hintPerfect
// if the color is in the code but in the wrong position make the hint#'s image hintColor
// if the hole does not match set the hnt#'s image to nil
- (void)compareCodeAnswerOne:(UIImageView *)one answerTwo:(UIImageView *)two answerThree:(UIImageView *)three answerFour:(UIImageView *)four {
    
    // set up containers
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *hintImages = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *randomHintImages = [[NSMutableArray alloc]initWithCapacity:4];
    
    // reset hint images
    hint1.image = [UIImage imageNamed:@"hintEmpty.png"];
    hint2.image = [UIImage imageNamed:@"hintEmpty.png"];
    hint3.image = [UIImage imageNamed:@"hintEmpty.png"];
    hint4.image = [UIImage imageNamed:@"hintEmpty.png"];
    
    // ivars
    BOOL codeOneAnswered = NO;
    BOOL codeTwoAnswered = NO;
    BOOL codeThreeAnswered = NO;
    BOOL codeFourAnswered = NO;
    
    BOOL answerOneDone = NO;
    BOOL answerTwoDone = NO;
    BOOL answerThreeDone = NO;
    BOOL answerFourDone = NO;
    
    UIImageView *hintPerfect = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HintPerfect.png"]];
    UIImageView *hintColor = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HintColor.png"]];
    
    // if randomHintToggle is on then randomize the display of hints
    if([defaults integerForKey:@"randomHintsToggle"] == 1){
        // check for perfect matches. one hint given per submitted codeAnswer
        if (one.image == codeOne.image){
            [hintImages addObject:hintPerfect.image];
            codeOneAnswered = YES;
            answerOneDone = YES;
        }
        
        if (two.image == codeTwo.image){
            [hintImages addObject:hintPerfect.image];
            codeTwoAnswered = YES;
            answerTwoDone = YES;
        }
        
        if (three.image == codeThree.image){
            [hintImages addObject:hintPerfect.image];
            codeThreeAnswered = YES;
            answerThreeDone = YES;
        }
        
        if (four.image == codeFour.image){
            [hintImages addObject:hintPerfect.image];
            codeFourAnswered = YES;
            answerFourDone = YES;
        }
        
        // check for imperfect color matches
        // each secret code only responds until its been answered
        
        ////////// one.image ///////////////
        if ((answerOneDone == NO) && (codeTwoAnswered == NO)){
            if ((codeTwoAnswered == NO) && (one.image == codeTwo.image)){
                [hintImages addObject:hintColor.image];
                codeTwoAnswered = YES;
                answerOneDone = YES;
            }
        }
        if ((answerOneDone == NO) && (codeThreeAnswered == NO)){
            if ((codeThreeAnswered == NO) && (one.image == codeThree.image)) {
                [hintImages addObject:hintColor.image];
                codeThreeAnswered = YES;
                answerOneDone = YES;
            }
        }
        if ((answerOneDone == NO) && (codeFourAnswered == NO)){
            if ((codeFourAnswered == NO) && (one.image == codeFour.image)){
                [hintImages addObject:hintColor.image];
                codeFourAnswered = YES;
                answerOneDone = YES;
            }
        }
        
        /////////////// two.image //////////////////
        if ((answerTwoDone == NO) && (codeOneAnswered == NO)){
            if ((codeOneAnswered == NO) && (two.image == codeOne.image)){
                [hintImages addObject:hintColor.image];
                codeOneAnswered = YES;
                answerTwoDone = YES;
            }
        }
        
        if ((answerTwoDone == NO) && (codeThreeAnswered == NO)){
            if ((codeThreeAnswered == NO) && (two.image == codeThree.image)){
                [hintImages addObject:hintColor.image];
                codeThreeAnswered = YES;
                answerTwoDone = YES;
            }
        }
        
        if ((answerTwoDone == NO) && (codeFourAnswered == NO)){
            if ((codeFourAnswered == NO) && (two.image == codeFour.image)){
                [hintImages addObject:hintColor.image];
                codeFourAnswered = YES;
                answerTwoDone = YES;
            }
        }
        
        ////////////// three.image //////////////
        if ((answerThreeDone == NO) && (codeOneAnswered == NO)){
            if ((codeOneAnswered == NO) && (three.image == codeOne.image)){
                [hintImages addObject:hintColor.image];
                codeOneAnswered = YES;
                answerThreeDone = YES;
            }
        }
        
        if ((answerThreeDone == NO) && (codeTwoAnswered == NO)){
            if ((codeTwoAnswered == NO) && (three.image == codeTwo.image)){
                [hintImages addObject:hintColor.image];
                codeTwoAnswered = YES;
                answerThreeDone = YES;
            }
        }
        
        if ((answerThreeDone == NO) && (codeFourAnswered == NO)){
            if ((codeFourAnswered == NO) && (three.image == codeFour.image)){
                [hintImages addObject:hintColor.image];
                codeFourAnswered = YES;
                answerThreeDone = YES;
            }
        }
        
        //////////////// four.image //////////////
        if ((answerFourDone == NO) && (codeOneAnswered == NO)){
            if ((codeOneAnswered == NO) && (four.image == codeOne.image)){
                [hintImages addObject:hintColor.image];
                codeOneAnswered = YES;
                answerFourDone = YES;
            }
        }
        
        if ((answerFourDone == NO) && (codeTwoAnswered == NO)){
            if ((codeTwoAnswered == NO) && (four.image == codeTwo.image)){
                [hintImages addObject:hintColor.image];
                codeTwoAnswered = YES;
                answerFourDone = YES;
            }
        }
        
        if ((answerFourDone == NO) && (codeThreeAnswered == NO)){
            if ((codeThreeAnswered == NO) && (four.image == codeThree.image)){
                [hintImages addObject:hintColor.image];
                codeThreeAnswered = YES;
                answerFourDone = YES;
            }
        }
        
        // since randomHintsToggle on
        // sort hints so hintPerfects are returned first
        for (int i = 0; i < hintImages.count; i++){
            if ([hintImages objectAtIndex:i] == hintPerfect.image) {
                [randomHintImages addObject:[hintImages objectAtIndex:i]];
            }
        }
        // and then add hintColor
        for (int i = 0; i < hintImages.count; i++) {
            if ([hintImages objectAtIndex:i] == hintColor.image) {
                [randomHintImages addObject:[hintImages objectAtIndex:i]];
            }
        }
        
        // randomHintImages array holds any hints
        // if there are no elements in array disable submit button, the round is over
        if (randomHintImages.count == 0) {
            [_buttonSubmit setUserInteractionEnabled:NO];
            return;
        }
        
        // if array is not empty fill our hints appropriately
        else if (randomHintImages.count == 1) {
            [hint1 setImage:[randomHintImages objectAtIndex:0]];
        } else if (randomHintImages.count == 2){
            [hint1 setImage:[randomHintImages objectAtIndex:0]];
            [hint2 setImage:[randomHintImages objectAtIndex:1]];
        } else if (randomHintImages.count == 3){
            [hint1 setImage:[randomHintImages objectAtIndex:0]];
            [hint2 setImage:[randomHintImages objectAtIndex:1]];
            [hint3 setImage:[randomHintImages objectAtIndex:2]];
        } else if (randomHintImages.count == 4){
            [hint1 setImage:[randomHintImages objectAtIndex:0]];
            [hint2 setImage:[randomHintImages objectAtIndex:1]];
            [hint3 setImage:[randomHintImages objectAtIndex:2]];
            [hint4 setImage:[randomHintImages objectAtIndex:3]];
        }
    }
    
    // memory cleanup
    [hintImages removeAllObjects];
    [randomHintImages removeAllObjects];
    
    // randomHintsToggle off, do not randomize hints
    if ([defaults integerForKey:@"randomHintToggle"] == 0 || nil) {
        // compare code values for perfect matches
        if (one.image == codeOne.image){
            [hintImages addObject:hintPerfect.image];
            codeOneAnswered = YES;
            answerOneDone = YES;
            hint1.image = hintPerfect.image;
        }
        
        if (two.image == codeTwo.image){
            [hintImages addObject:hintPerfect.image];
            codeTwoAnswered = YES;
            answerTwoDone = YES;
            hint2.image = hintPerfect.image;
        }
        
        if (three.image == codeThree.image){
            [hintImages addObject:hintPerfect.image];
            codeThreeAnswered = YES;
            answerThreeDone = YES;
            hint3.image = hintPerfect.image;
        }
        
        if (four.image == codeFour.image){
            [hintImages addObject:hintPerfect.image];
            codeFourAnswered = YES;
            answerFourDone = YES;
            hint4.image = hintPerfect.image;
        }
        
        // compare code values for color matches
        /////////// one.image ////////////
        if ((answerOneDone == NO) && (answerTwoDone == NO)){
            if (one.image == codeTwo.image) {
                [hintImages addObject:hintColor.image];
                codeTwoAnswered = YES;
                answerOneDone = YES;
                hint1.image = hintColor.image;
            }
        }
        
        if ((answerOneDone == NO) && (codeThreeAnswered == NO)){
            if (one.image == codeThree.image){
                [hintImages addObject:hintColor.image];
                codeThreeAnswered = YES;
                answerOneDone = YES;
                hint1.image = hintColor.image;
            }
        }
        
        if ((answerOneDone == NO) && (codeFourAnswered == NO)){
            if (one.image == codeFour.image){
                [hintImages addObject:hintColor.image];
                codeFourAnswered = YES;
                answerOneDone = YES;
                hint1.image = hintColor.image;
            }
        }
        
        //////////// two.image ///////////////
        if ((answerTwoDone == NO) && (codeOneAnswered == NO)){
            if (two.image == codeOne.image){
                [hintImages addObject:hintColor.image];
                codeOneAnswered = YES;
                answerTwoDone = YES;
                hint2.image = hintColor.image;
            }
        }
        
        if ((answerTwoDone == NO) && (codeThreeAnswered == NO)){
            if (two.image == codeThree.image){
                [hintImages addObject:hintColor.image];
                codeThreeAnswered = YES;
                answerTwoDone = YES;
                hint2.image = hintColor.image;
            }
        }
        
        if ((answerTwoDone == NO) && (codeFourAnswered == NO)){
            if (two.image == codeFour.image){
                [hintImages addObject:hintColor.image];
                codeFourAnswered = YES;
                answerTwoDone = YES;
                hint2.image = hintColor.image;
            }
        }
        
        ////////////// three.image /////////////
        if ((answerThreeDone == NO) && (codeOneAnswered == NO)){
            if (three.image == codeOne.image){
                [hintImages addObject:hintColor.image];
                codeOneAnswered = YES;
                answerThreeDone = YES;
                hint3.image = hintColor.image;
            }
        }
        
        if ((answerThreeDone == NO) && (codeTwoAnswered == NO)){
            if ((codeTwoAnswered == NO) && (three.image == codeTwo.image)){
                [hintImages addObject:hintColor.image];
                codeTwoAnswered = YES;
                answerThreeDone = YES;
                hint3.image = hintColor.image;
            }
        }
        
        if ((answerThreeDone == NO) && (codeFourAnswered == NO)){
            if (three.image == codeFour.image){
                [hintImages addObject:hintColor.image];
                codeFourAnswered = YES;
                answerThreeDone = YES;
                hint3.image = hintColor.image;
            }
        }
        
        ///////////////// four.image //////////////
        if ((answerFourDone == NO) && (codeOneAnswered == NO)){
            if (four.image == codeOne.image){
                [hintImages addObject:hintColor.image];
                codeOneAnswered = YES;
                answerFourDone = YES;
                hint4.image = hintColor.image;
            }
        }
        
        if ((answerFourDone == NO) && (codeTwoAnswered == NO)){
            if (four.image == codeTwo.image){
                [hintImages addObject:hintColor.image];
                codeTwoAnswered = YES;
                answerFourDone = YES;
                hint4.image = hintColor.image;
            }
        }
        
        if ((answerFourDone == NO) && (codeThreeAnswered == NO)){
            if (four.image == codeThree.image){
                [hintImages addObject:hintColor.image];
                codeThreeAnswered = YES;
                answerFourDone = YES;
                hint4.image = hintColor.image;
            }
        }
    }
    
}
// check win scenario by comparing hints for perfection
- (BOOL)didWin {
    // conainer for our hintPerfect for comparison
    UIImageView *hintPerfect = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HintPerfect.png"]];

    // check to see if any hints are not perfect
    // if any hints are not perfect its not a win
    if ((hint1.image != hintPerfect.image) || (hint2.image != hintPerfect.image) || (hint3.image != hintPerfect.image) || (hint4.image != hintPerfect.image)) {
        return NO;
    }
    // win scenario
    else {
        // youWin UIImageView?
        // youWin.alpha = 1;
        // [self.view addSubview:youWin]
        
        // disable all rows
        [_attemptAView setUserInteractionEnabled:NO];
        [_attemptBView setUserInteractionEnabled:NO];
        [_attemptCView setUserInteractionEnabled:NO];
        [_attemptDView setUserInteractionEnabled:NO];
        [_attemptEView setUserInteractionEnabled:NO];
        [_attemptFView setUserInteractionEnabled:NO];
        
        // reset current game
        currentGame = NO;
        
        [self closeDoors];
        
        [UIView animateWithDuration:0.0
                         animations:^{
                             //youWin.alpha = 1
                         } completion:^(BOOL finished) {
                             //
                         }];
        return YES;
    }
}

- (void)closeDoors {
    // show gameOverView
    gameOverView.hidden = NO;
    // insert gameOverView on top of topDoorView
    [self.view insertSubview:gameOverView aboveSubview:topDoorView];
    // begin our animation by closing the doors
    [UIImageView animateWithDuration:0.2
                               delay: 1.0
                             options: UIViewAnimationOptionCurveLinear
                          animations:^{
                              // 4inch
                              if([[UIScreen mainScreen] bounds].size.height == 568){
                                  gameOverView.frame = CGRectMake(80, 239, 160, 90);
                                  topDoorView.frame = CGRectMake(0, 0, 320, 284);
                                  botDoorView.frame = CGRectMake(0, 284, 320, 284);
                              }
                              // 3.5inch
                              else{
                                  gameOverView.frame = CGRectMake(80, 195, 160, 90);
                                  topDoorView.frame = CGRectMake(0, 0, 320, 240);
                                  botDoorView.frame = CGRectMake(0, 240, 320, 240);
                              }
                          }
                          completion:^(BOOL finished){
                              // when the doors come down they bounce up a bit, then come back down for a final close
                              // first for the bounce up with a little bit of hang time
                              [UIImageView animateWithDuration:0.1
                                                         delay: 0.0
                                                       options: UIViewAnimationOptionCurveEaseIn
                                                    animations:^{
                                                        // 4inch
                                                        if([[UIScreen mainScreen] bounds].size.height == 568){
                                                            gameOverView.frame = CGRectMake(80, 239-5, 160, 90);
                                                            topDoorView.frame = CGRectMake(0, 0, 320-5, 284);
                                                            botDoorView.frame = CGRectMake(0, 284, 320+5, 284);
                                                        }
                                                        // 3.5inch
                                                        else{
                                                            gameOverView.frame = CGRectMake(80, 195-5, 160, 90);
                                                            topDoorView.frame = CGRectMake(0, 0-5, 320, 240);
                                                            botDoorView.frame = CGRectMake(0, 240+5, 320, 240);
                                                        }
                                                    }
                                                    completion:^(BOOL finished){
                                                        //and now for our final close
                                                        [UIImageView animateWithDuration:0.1
                                                                                   delay: 0.0
                                                                                 options: UIViewAnimationOptionCurveEaseOut
                                                                              animations:^{
                                                                                  // 4inch
                                                                                  if([[UIScreen mainScreen] bounds].size.height == 568){
                                                                                      gameOverView.frame = CGRectMake(80, 239, 160, 90);
                                                                                      topDoorView.frame = CGRectMake(0, 0, 320, 284);
                                                                                      botDoorView.frame = CGRectMake(0, 284, 320, 284);
                                                                                  }
                                                                                  // 3.5 inch
                                                                                  else{
                                                                                      gameOverView.frame = CGRectMake(80, 195, 160, 90);
                                                                                      topDoorView.frame = CGRectMake(0, 0, 320, 240);
                                                                                      botDoorView.frame = CGRectMake(0, 240, 320, 240);
                                                                                  }
                                                                              }
                                                                              completion:^(BOOL finished){}];
                                                    }];
                          }];
}

// view difficulty panel
- (IBAction)buttonDifficulty:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"duplicateColorToggle"] == 1) {
        [buttonAllowDuplicates.imageView setImage:[UIImage imageNamed:@"ToggleOn.png" ]];
    } else {
        [buttonAllowDuplicates.imageView setImage:[UIImage imageNamed:@"ToggleOff.png" ]];
    }
    if ([defaults integerForKey:@"randomHintToggle"] == 1) {
        [buttonRandomizeHints.imageView setImage:[UIImage imageNamed:@"ToggleOn.png"]];
    } else {
        [buttonRandomizeHints.imageView setImage:[UIImage imageNamed:@"ToggleOff.png"]];
    }
    
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
    // open doors
    [self openDoors];
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
