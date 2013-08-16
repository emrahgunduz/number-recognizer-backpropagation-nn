//
//  emrAppDelegate.h
//  NumberRecognition
//
//  Created by Emrah Gunduz on 3/6/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "emrMnist.h"
#import "emrDrawingView.h"
#import "emrTrainImageView.h"

@interface emrAppDelegate : NSObject <NSApplicationDelegate>
{
  int loadMax;
  float width;
  float height;
  
  int imgCount;
  emrMnist *images;
  emrNetwork *network;
  NSMutableArray *trainImageViews;
  
  BOOL isInTraining;
  NSMutableArray *input;
  NSMutableArray *output;
  
  NSMutableArray *textFields;
  emrTrainImageView *trainingView;
}

- (IBAction)loadNetwork:(id)sender;
- (IBAction)saveNetwork:(id)sender;
- (IBAction)saveNetworkError:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *mainView;
@property (weak) IBOutlet emrView *networkView;
@property (weak) IBOutlet NSTextField *epochText;
@property (weak) IBOutlet NSTextField *errorText;
@property (weak) IBOutlet NSTextField *inputEpoch;
@property (weak) IBOutlet NSTextField *inputTraining;
@property (weak) IBOutlet NSTextField *inputMomentum;

- (IBAction)loadTrainData:(id)sender;
- (IBAction)startTraining:(id)sender;

@property (weak) IBOutlet emrDrawingView *drawingView;
@property (weak) IBOutlet NSTextField *textZero;
@property (weak) IBOutlet NSTextField *textOne;
@property (weak) IBOutlet NSTextField *textTwo;
@property (weak) IBOutlet NSTextField *textThree;
@property (weak) IBOutlet NSTextField *textFour;
@property (weak) IBOutlet NSTextField *textFive;
@property (weak) IBOutlet NSTextField *textSix;
@property (weak) IBOutlet NSTextField *textSeven;
@property (weak) IBOutlet NSTextField *textEight;
@property (weak) IBOutlet NSTextField *textNine;
- (IBAction)runDrawing:(id)sender;
- (IBAction)runDrawingBackwards:(id)sender;
- (IBAction)clearDrawing:(id)sender;
@end
