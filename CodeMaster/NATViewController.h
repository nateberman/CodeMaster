//
//  NATViewController.h
//  CodeMaster
//
//  Created by Nate Berman on 4/27/14.
//  Copyright (c) 2014 Nate Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NATViewController : UIViewController <UIGestureRecognizerDelegate>{
    
    //declare our interface assets
    IBOutlet UIImageView *backgroundBlack;
    IBOutlet UIImageView *backgroundHex;
    
    //top and bot doors
    IBOutlet UIView *topDoorView;
    IBOutlet UIImageView *topDoor;
    IBOutlet UIView *botDoorView;
    IBOutlet UIImageView *botDoor;
    
    //gameOver
    IBOutlet UIView *gameOverView;
    
    //top and bot panels
    IBOutlet UIView *topPanelView;
    IBOutlet UIImageView *topPanel; //frame image
    IBOutlet UIImageView *codeCover;
    IBOutlet UIImageView *codeOne;
    IBOutlet UIImageView *codeTwo;
    IBOutlet UIImageView *codeThree;
    IBOutlet UIImageView *codeFour;
    IBOutlet UIView *botPanelView; //default 6 button
    IBOutlet UIImageView *botPanel; //frame image
    
    //primary centerPanel container view
    IBOutlet UIView *centerPanelView;
    //home centerPanel view
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
    
    //UIImageViews that supply hits to the user after each code submission
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

@end
