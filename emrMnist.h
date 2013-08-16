//
//  emrMnist.h
//  NNetwork
//
//  Created by Emrah Gunduz on 2/15/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface emrMnist : NSObject
{
  NSData *imageData;
  NSData *labelData;
  BOOL dataIsLoaded;
  int magicNumber;
  int numberOfImages;
  int numberOfRows;
  int numberOfColumns;
}

@property (assign) int imageCount;

- (void)readTrainingImages;
- (void)readGuessingImages;
- (int)readImageLabelNum:(int)num;
- (NSImage*)readImageNum:(int)num;
@end
