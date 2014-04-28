//
//  NATViewController.h
//  CodeMaster
//
//  Created by Nate Berman on 4/27/14.
//  Copyright (c) 2014 Nate Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NATViewController : UIViewController <UIGestureRecognizerDelegate>{
    
    // background assets
    IBOutlet UIImageView *backgroundBlack;
    IBOutlet UIImageView *backgroundHex;
    
    // top and bot doors
    IBOutlet UIView *topDoorView;
    IBOutlet UIImageView *topDoor;
    IBOutlet UIView *botDoorView;
    IBOutlet UIImageView *botDoor;
    
    // gameOver
    IBOutlet UIView *gameOverView;
    
    // top and bot panels
    IBOutlet UIView *topPanelView;
    IBOutlet UIImageView *topPanel; //frame image
    IBOutlet UIImageView *codeCover;
    IBOutlet UIImageView *codeOne;
    IBOutlet UIImageView *codeTwo;
    IBOutlet UIImageView *codeThree;
    IBOutlet UIImageView *codeFour;
    IBOutlet UIView *botPanelView; //default 6 button
    IBOutlet UIImageView *botPanel; //frame image
    
    // primary centerPanel container view
    IBOutlet UIView *centerPanelView;
    // home centerPanel view
    IBOutlet UIView *centerPanelHome;
    IBOutlet UIImageView *homeFrame;
    IBOutlet UILabel *homeLabel;
    IBOutlet UIButton *buttonPlay;
    IBOutlet UIButton *buttonDifficulty;
    IBOutlet UIButton *buttonTutorial;
    IBOutlet UIButton *buttonCredits;
    //difficulty centerPanel view
    IBOutlet UIView *centerPanelDifficulty;
    IBOutlet UIImageView *difficultyFrame;
    IBOutlet UILabel *difficultyLabel;
    IBOutlet UIButton *buttonAllowDuplicates;
    IBOutlet UILabel *labelAllowDuplicates;
    IBOutlet UIButton *buttonRandomizeHints;
    IBOutlet UILabel *labelRandomizeHints;
    //tutorial centerPanel view
    IBOutlet UIView *centerPanelTutorial;
    IBOutlet UIImageView *tutorialFrame;
    IBOutlet UILabel *tutorialLabel;
    //credits centerPanel view
    IBOutlet UIView *centerPanelCredits;
    IBOutlet UIImageView *creditsFrame;
    IBOutlet UILabel *labelCredits;
    //play centerPanel view - main game view
    IBOutlet UIView *centerPanelPlay;
    IBOutlet UIImageView *playFrame;
    
    //programmatic back button
    IBOutlet UIButton *buttonBack;
    
    //this stores the identity of the active centerPanel for programmatic access 
    IBOutlet UIView *centerPanelActive;
    
    //UIImageViews that supply hints to the user after each code submission
    IBOutlet UIImageView *hintOneA;
    IBOutlet UIImageView *hintTwoA;
    IBOutlet UIImageView *hintThreeA;
    IBOutlet UIImageView *hintFourA;
    IBOutlet UIImageView *hintOneB;
    IBOutlet UIImageView *hintTwoB;
    IBOutlet UIImageView *hintThreeB;
    IBOutlet UIImageView *hintFourB;
    IBOutlet UIImageView *hintOneC;
    IBOutlet UIImageView *hintTwoC;
    IBOutlet UIImageView *hintThreeC;
    IBOutlet UIImageView *hintFourC;
    IBOutlet UIImageView *hintOneD;
    IBOutlet UIImageView *hintTwoD;
    IBOutlet UIImageView *hintThreeD;
    IBOutlet UIImageView *hintFourD;
    IBOutlet UIImageView *hintOneE;
    IBOutlet UIImageView *hintTwoE;
    IBOutlet UIImageView *hintThreeE;
    IBOutlet UIImageView *hintFourE;
    IBOutlet UIImageView *hintOneF;
    IBOutlet UIImageView *hintTwoF;
    IBOutlet UIImageView *hintThreeF;
    IBOutlet UIImageView *hintFourF;
    
    //development test view
    IBOutlet UIView *devTestView;
    IBOutlet UIImageView *selectedImage;
    IBOutlet UIImageView *hint1;
    IBOutlet UIImageView *hint2;
    IBOutlet UIImageView *hint3;
    IBOutlet UIImageView *hint4;
}

@property (strong, nonatomic) UIImageView *hintPerfect;

//gameOverView buttons
- (IBAction)buttonPlayAgain:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonPlayAgain;
- (IBAction)buttonMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonMenu;

//actions for each of our centerPanel view buttons
- (IBAction)buttonFlip:(id)sender;
- (IBAction)buttonPlay:(id)sender;
- (IBAction)buttonDifficulty:(id)sender;
- (IBAction)buttonTutorial:(id)sender;
- (IBAction)buttonCredits:(id)sender;
- (IBAction)buttonBack:(id)sender;
- (IBAction)buttonAllowDuplicates:(id)sender;
- (IBAction)buttonRandomizeHints:(id)sender;

//buttons for our 6 choice botPanelView (default botPanelView)
- (IBAction)choiceOneButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *choiceOneButton;
- (IBAction)choiceTwoButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *choiceTwoButton;
- (IBAction)choiceThreeButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *choiceThreeButton;
- (IBAction)choiceFourButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *choiceFourButton;
- (IBAction)choiceFiveButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *choiceFiveButton;
- (IBAction)choiceSixButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *choiceSixButton;

//////////////////////////////////////////////////
//setup for attempt row views
//.....Attempt A
@property (strong, nonatomic) IBOutlet UIView *attemptAView;
- (IBAction)holeOneA:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeOneA;
- (IBAction)holeTwoA:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeTwoA;
- (IBAction)holeThreeA:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeThreeA;
- (IBAction)holeFourA:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeFourA;
//.....Attempt B
@property (strong, nonatomic) IBOutlet UIView *attemptBView;
- (IBAction)holeOneB:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeOneB;
- (IBAction)holeTwoB:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeTwoB;
- (IBAction)holeThreeB:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeThreeB;
- (IBAction)holeFourB:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeFourB;
//.....Attempt C
@property (strong, nonatomic) IBOutlet UIView *attemptCView;
- (IBAction)holeOneC:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeOneC;
- (IBAction)holeTwoC:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeTwoC;
- (IBAction)holeThreeC:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeThreeC;
- (IBAction)holeFourC:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeFourC;
//.....Attempt D
@property (strong, nonatomic) IBOutlet UIView *attemptDView;
- (IBAction)holeOneD:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeOneD;
- (IBAction)holeTwoD:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeTwoD;
- (IBAction)holeThreeD:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeThreeD;
- (IBAction)holeFourD:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeFourD;
//.....Attempt E
@property (strong, nonatomic) IBOutlet UIView *attemptEView;
- (IBAction)holeOneE:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeOneE;
- (IBAction)holeTwoE:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeTwoE;
- (IBAction)holeThreeE:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeThreeE;
- (IBAction)holeFourE:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeFourE;
//.....Attempt F
@property (strong, nonatomic) IBOutlet UIView *attemptFView;
- (IBAction)holeOneF:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeOneF;
- (IBAction)holeTwoF:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeTwoF;
- (IBAction)holeThreeF:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeThreeF;
- (IBAction)holeFourF:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *holeFourF;
//////////////////////////////////////////////////

//submit button
- (IBAction)buttonSubmit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonSubmit;

- (void)compareCodeAnswerOne: (UIImageView *)one answerTwo: (UIImageView *)two answerThree: (UIImageView *)three answerFour: (UIImageView *)four;

@end
