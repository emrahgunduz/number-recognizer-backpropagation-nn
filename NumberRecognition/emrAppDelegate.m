//
//  emrAppDelegate.m
//  NumberRecognition
//
//  Created by Emrah Gunduz on 3/6/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrAppDelegate.h"
#import "emrImageData.h"

@implementation emrAppDelegate

@synthesize window, mainView, networkView;
@synthesize epochText, errorText, inputEpoch, inputMomentum, inputTraining;
@synthesize drawingView, textOne, textTwo, textThree, textFour, textFive, textSix, textSeven, textEight, textNine, textZero;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
  return YES;
}

- (void)openTheNetwork
{
  NSOpenPanel *open = [NSOpenPanel openPanel];
  [open setAllowedFileTypes:[NSArray arrayWithObject:@"network"]];
  [open setAllowsOtherFileTypes:NO];
  
  long int result = [open runModal];
  if (result == NSOKButton) {
    // Load network data
    NSString *file = [[open URL] path];
    // Reset network
    [network destroy];
    // Load file
    [network loadTrainingData:file];
  }
}

- (void)saveTheNetwork
{
  NSSavePanel *save = [NSSavePanel savePanel];
  [save setAllowedFileTypes:[NSArray arrayWithObject:@"network"]];
  [save setAllowsOtherFileTypes:NO];
  
  long int result = [save runModal];
  if(result == NSOKButton) {
    // Save network data
    NSString *file = [[save URL] path];
    [network saveTrainingData:file];
  }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  loadMax = 100;
  width = 8.0f;
  height = 8.0f;
  
  int inputs  = 255;
  int hiddens = 127;
  
  // Create the network
  network = [emrNetwork new];
  [network createInputLayerWithNodeCount:inputs withConnectionCount:hiddens];
  [network createInputLayerWithNodeCount:hiddens withConnectionCount:10];
  [network createOutputLayerWithNodeCount:10];
  [network setSystemTransferFunction:transferFunctionSigmoid];
  // [network setRenderView:networkView];
  
  imgCount        = 0;
  trainImageViews = [NSMutableArray array];
  input           = [NSMutableArray array];
  output          = [NSMutableArray array];
  
  // Training image loader
  images = [emrMnist new];
  [images readTrainingImages];
  
  trainingView = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(1005, 40+185, width, height)];
  [mainView addSubview:trainingView];
  
  textFields = [NSMutableArray array];
  [textFields addObject:textZero];
  [textFields addObject:textOne];
  [textFields addObject:textTwo];
  [textFields addObject:textThree];
  [textFields addObject:textFour];
  [textFields addObject:textFive];
  [textFields addObject:textSix];
  [textFields addObject:textSeven];
  [textFields addObject:textEight];
  [textFields addObject:textNine];
  
  [window setAcceptsMouseMovedEvents:YES];
}

- (IBAction)loadTrainData:(id)sender
{
  BOOL notCompleted = YES;
  int counter0 = 0;
  int counter1 = 0;
  int counter2 = 0;
  int counter3 = 0;
  int counter4 = 0;
  int counter5 = 0;
  int counter6 = 0;
  int counter7 = 0;
  int counter8 = 0;
  int counter9 = 0;
  
  int locX0 = 10;
  int locX1 = 10;
  int locX2 = 10;
  int locX3 = 10;
  int locX4 = 10;
  int locX5 = 10;
  int locX6 = 10;
  int locX7 = 10;
  int locX8 = 10;
  int locX9 = 10;
  
  if(trainImageViews.count) {
    for (emrTrainImageView *view in trainImageViews) {
      [view removeFromSuperview];
    }
  }
  [trainImageViews removeAllObjects];
  trainImageViews = [NSMutableArray array];
  
  while (notCompleted) {
    NSImage *trainingImage = [images readImageNum:imgCount];
    int trainingLabel = [images readImageLabelNum:imgCount];
    
    if(imgCount >= images.imageCount) {
      imgCount = 0;
    }
    
    if(counter0 == loadMax && counter1 == loadMax && counter2 == loadMax && counter3 == loadMax && counter4 == loadMax && counter5 == loadMax && counter6 == loadMax && counter7 == loadMax && counter8 == loadMax && counter9 == loadMax) {
      notCompleted = NO;
      continue;
    }
    
    switch (trainingLabel) {
      case 0:
      {
        if(counter0 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX0, 463, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:0];
          counter0++;
          locX0 += width;
        }
      }
        break;
      case 1:
      {
        if(counter1 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX1, 426, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:1];
          counter1++;
          locX1 += width;
        }
      }
        break;
      case 2:
      {
        if(counter2 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX2, 389, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:2];
          counter2++;
          locX2 += width;
        }
      }
        break;
      case 3:
      {
        if(counter3 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX3, 352, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:3];
          counter3++;
          locX3 += width;
        }
      }
        break;
      case 4:
      {
        if(counter4 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX4, 315, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:4];
          counter4++;
          locX4 += width;
        }
      }
        break;
      case 5:
      {
        if(counter5 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX5, 278, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:5];
          counter5++;
          locX5 += width;
        }
      }
        break;
      case 6:
      {
        if(counter6 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX6, 241, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:6];
          counter6++;
          locX6 += width;
        }
      }
        break;
      case 7:
      {
        if(counter7 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX7, 204, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:7];
          counter7++;
          locX7 += width;
        }
      }
        break;
      case 8:
      {
        if(counter8 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX8, 167, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:8];
          counter8++;
          locX8 += width;
        }
      }
        break;
      case 9:
      {
        if(counter9 < loadMax) {
          emrTrainImageView *view = [[emrTrainImageView alloc] initWithFrame:NSMakeRect(locX9, 130, width, height)];
          [mainView addSubview:view];
          [trainImageViews addObject:view];
          [view setImage:trainingImage];
          [view setLabel:9];
          counter9++;
          locX9 += width;
        }
      }
        break;
    }
    
    imgCount++;
  }
}

- (IBAction)startTraining:(id)sender
{
  NSButton *thisButton = (NSButton*)sender;
  if(isInTraining) {
    [thisButton setTitle:@"Train"];
    isInTraining = NO;
    return;
  }
  
  [input removeAllObjects];
  [output removeAllObjects];
  
  // Randomize train image inputs
  srandom((unsigned int)time(NULL));
  for (NSInteger x = 0; x < [trainImageViews count]; x++) {
    NSInteger randInt = (random() % ([trainImageViews count] - x)) + x;
    [trainImageViews exchangeObjectAtIndex:x withObjectAtIndex:randInt];
  }
  
  // Generate inputs and outputs
  for (emrTrainImageView *view in trainImageViews) {
    [input addObject:[emrImageData compileForRun:[view imageFromView]]];
    [output addObject:[view getLabelForOutput]];
  }
  
  int epoch = [inputEpoch.stringValue intValue];
  double trainingRate = [inputTraining.stringValue doubleValue];
  double momentum = [inputMomentum.stringValue doubleValue];
  
  int refresh = (int)(10000/input.count);
  
  [thisButton setTitle:@"Stop training"];  
  isInTraining = YES;
  
  dispatch_queue_t run = dispatch_queue_create("NNRun", NULL);
  dispatch_async(run, ^{
    // Train
    BOOL equal = NO;
    double error = 0.0f;
    int i = 0;
    
    do {
      error = 0.0f;
      
      for (int j = 0; j < input.count; j++) {
        @autoreleasepool {
          error += [network trainWithInput:[input objectAtIndex:j] desired:[output objectAtIndex:j] trainingRate:trainingRate momentum:momentum];
        }
      }
      
      if(i % refresh == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [epochText setStringValue:[NSString stringWithFormat:@"%i",i]];
          [errorText setStringValue:[NSString stringWithFormat:@"%f (%f)",error, (error/input.count)]];
          //[network addToErrorArray:error];
        });
      }
      
      if(i == epoch || !isInTraining || [emrNetwork fuzzyEqual:error and:0.00f difference:0.0000001]){
        equal = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
          [epochText setStringValue:[NSString stringWithFormat:@"Finished: %i",i]];
          [errorText setStringValue:[NSString stringWithFormat:@"%f (%f)",error, (error/input.count)]];
          [network prepareNetworkBeforeSaving];
          [network prepareNetworkBeforeRunning];
        });
        isInTraining = NO;
      }
      
      i++;
      
    } while (!equal);
  });
}

- (void)runDrawing:(id)sender
{
  NSImage *imageFromView = [drawingView imageFromView:drawingView.bounds.size];
  NSImage *image = [emrImageData imageResizeByTrimming:imageFromView size:CGSizeMake(width, height)];
  [trainingView setImage:image];
  NSMutableArray *netOut = [[network runWithInput:[emrImageData compileForRun:[trainingView imageFromView]]] mutableCopy];
  
  // Find the biggest value
  double max = 0.0f;
  for (int i = 0; i < netOut.count; i++) {
    max = MAX(max, [[netOut objectAtIndex:i] doubleValue]);
  }
  
  for (int i = 0; i < netOut.count; i++) {
    if([[netOut objectAtIndex:i] doubleValue] == max)
      [netOut replaceObjectAtIndex:i withObject:@1.0f];
  }
  
  for (int i = 0; i < netOut.count; i++) {
    NSTextField *field= [textFields objectAtIndex:i];
    NSLog(@"%i : %f", i, [[netOut objectAtIndex:i] doubleValue]);
    field.alphaValue = [[netOut objectAtIndex:i] doubleValue];
  }
}

- (IBAction)runDrawingBackwards:(id)sender
{
  NSArray *o = @[@0.0, // 0
                 @0.0, // 1
                 @0.0, // 2
                 @0.0, // 3
                 @0.0, // 4
                 @0.0, // 5
                 @1.0, // 6
                 @0.0, // 7
                 @0.0, // 8
                 @0.0  // 9
                 ];
  NSArray *netOut = [network runWithOutput:o];
  NSMutableArray *imageOut = [NSMutableArray array];
  for (int i = 0; i < width*height; i++) {
    [imageOut addObject:[netOut objectAtIndex:i]];
  }
  NSImage *img = [emrImageData arrayToImage:[imageOut copy] width:width height:height];
  [trainingView setImage:img];
}

- (void)clearDrawing:(id)sender
{
  [drawingView clean];
}
- (IBAction)loadNetwork:(id)sender
{
  [self openTheNetwork];
}

- (IBAction)saveNetwork:(id)sender
{
  [self saveTheNetwork];
}

- (IBAction)saveNetworkError:(id)sender
{
  NSSavePanel *saveData = [NSSavePanel savePanel];
  [saveData setAllowedFileTypes:[NSArray arrayWithObject:@"csv"]];
  [saveData setAllowsOtherFileTypes:NO];
  
  long int result = [saveData runModal];
  if(result == NSOKButton) {
    NSArray *errors = [network getErrorArray];
    
    NSMutableString *str = [@"" mutableCopy];
    for (NSNumber *row in errors) {
      [str appendString:[NSString stringWithFormat:@"%f,", [row doubleValue]]];
      [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
      [str appendString:@"\n"];
    }
    [str writeToFile:[[saveData URL] path] atomically:YES encoding:NSUTF8StringEncoding error:nil];
  }
}
@end
