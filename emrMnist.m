//
//  emrMnist.m
//  NNetwork
//
//  Created by Emrah Gunduz on 2/15/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrMnist.h"
#import "emrImageData.h"

@implementation emrMnist

@synthesize imageCount;

- (void)dealloc
{
  imageData = nil;
  labelData = nil;
  imageCount = 0;
}

- (void)readTrainingImages
{
  dataIsLoaded = NO;
  imageData = nil;
  labelData = nil;
  
  // Read image data
  NSError *error;
  NSString *filePath;
  
  filePath = [[NSBundle mainBundle] pathForResource:@"train-images-idx3-ubyte" ofType:@"data"];
  imageData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
  if(error) {
    NSLog(@"Could not read training image data");
    return;
  }
  
  // Read label data
  error = nil;
  filePath = [[NSBundle mainBundle] pathForResource:@"train-labels-idx1-ubyte" ofType:@"data"];
  labelData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
  if(error) {
    NSLog(@"Could not read training labels data");
    return;
  }
  
  // Read magic number
  long currentByte = 0;
  [imageData getBytes:&magicNumber range:NSMakeRange(currentByte, 4)];
  magicNumber = NSSwapInt(magicNumber);
  currentByte += 4;
  
  // Number of images
  [imageData getBytes:&numberOfImages range:NSMakeRange(currentByte, 4)];
  numberOfImages = NSSwapInt(numberOfImages);
  currentByte += 4;
  imageCount = numberOfImages;
  
  // Number of rows
  [imageData getBytes:&numberOfRows range:NSMakeRange(currentByte, 4)];
  numberOfRows = NSSwapInt(numberOfRows);
  currentByte += 4;
  
  // Number of columns
  [imageData getBytes:&numberOfColumns range:NSMakeRange(currentByte, 4)];
  numberOfColumns = NSSwapInt(numberOfColumns);
  
  NSLog(@"Training images magic number %i", magicNumber);
  NSLog(@"Image count   %i", numberOfImages);
  NSLog(@"Image rows    %i", numberOfRows);
  NSLog(@"Image columns %i", numberOfColumns);
  
  // Read first label
  int firstLabel;
  currentByte = 0;
  [labelData getBytes:&firstLabel range:NSMakeRange(currentByte, 4)];
  firstLabel = NSSwapInt(firstLabel);
  currentByte += 4;
  NSLog(@"Label magic number is %i", firstLabel);
  
  [labelData getBytes:&firstLabel range:NSMakeRange(currentByte, 4)];
  firstLabel = NSSwapInt(firstLabel);
  currentByte += 4;
  NSLog(@"There are %i labels", firstLabel);
  
  Byte byte;
  [labelData getBytes:&byte range:NSMakeRange(currentByte, 1)];
  NSLog(@"First label is %i", byte);
  
  dataIsLoaded = YES;
}

- (void)readGuessingImages
{
  dataIsLoaded = NO;
  imageData = nil;
  labelData = nil;
  
  // Read image data
  NSError *error;
  NSString *filePath;
  
  filePath = [[NSBundle mainBundle] pathForResource:@"t10k-images-idx3-ubyte" ofType:@"data"];
  imageData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
  if(error) {
    NSLog(@"Could not read training image data");
    return;
  }
  
  // Read label data
  error = nil;
  filePath = [[NSBundle mainBundle] pathForResource:@"t10k-labels-idx1-ubyte" ofType:@"data"];
  labelData = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
  if(error) {
    NSLog(@"Could not read training labels data");
    return;
  }
  
  // Read magic number
  long currentByte = 0;
  [imageData getBytes:&magicNumber range:NSMakeRange(currentByte, 4)];
  magicNumber = NSSwapInt(magicNumber);
  currentByte += 4;
  
  // Number of images
  [imageData getBytes:&numberOfImages range:NSMakeRange(currentByte, 4)];
  numberOfImages = NSSwapInt(numberOfImages);
  imageCount = numberOfImages;
  currentByte += 4;
  
  // Number of rows
  [imageData getBytes:&numberOfRows range:NSMakeRange(currentByte, 4)];
  numberOfRows = NSSwapInt(numberOfRows);
  currentByte += 4;
  
  // Number of columns
  [imageData getBytes:&numberOfColumns range:NSMakeRange(currentByte, 4)];
  numberOfColumns = NSSwapInt(numberOfColumns);
  
  NSLog(@"Guess images magic number %i", magicNumber);
  NSLog(@"Image count   %i", numberOfImages);
  NSLog(@"Image rows    %i", numberOfRows);
  NSLog(@"Image columns %i", numberOfColumns);
  
  // Read first label
  int firstLabel;
  currentByte = 0;
  [labelData getBytes:&firstLabel range:NSMakeRange(currentByte, 4)];
  firstLabel = NSSwapInt(firstLabel);
  currentByte += 4;
  NSLog(@"Label magic number is %i", firstLabel);
  
  [labelData getBytes:&firstLabel range:NSMakeRange(currentByte, 4)];
  firstLabel = NSSwapInt(firstLabel);
  currentByte += 4;
  NSLog(@"There are %i labels", firstLabel);
  
  Byte byte;
  [labelData getBytes:&byte range:NSMakeRange(currentByte, 1)];
  NSLog(@"First label is %i", byte);
  
  dataIsLoaded = YES;
}

- (int)readImageLabelNum:(int)num
{
  if(num > numberOfImages) {
    num = numberOfImages;
  }
  
  // Move to byte
  int currentByte = 8 + num;
  // To be read byte count
  Byte byte;
  [labelData getBytes:&byte range:NSMakeRange(currentByte, 1)];
  
  return (int)byte;
}

- (NSImage*)readImageNum:(int)num
{
  if(num > numberOfImages) {
    num = numberOfImages;
  }
  
  // Create an array from image data
  NSMutableArray *arr = [NSMutableArray array];
  
  // Move to byte
  int currentByte = 16 + (num * numberOfRows * numberOfColumns) - 1;
  // To be read byte count
  int lastByte = currentByte + numberOfRows * numberOfColumns;
  
  // Start reading
  Byte byte;
  NSNumber *number;
  for(int i = currentByte; i < lastByte; i++) {
    [imageData getBytes:&byte range:NSMakeRange(i, 1)];
    number = [[NSNumber alloc]initWithInt:byte];
    [arr addObject:[number copy]];
    number = nil;
  }
  
  // Create an image
  NSImage *constructed = [emrImageData arrayToTrainingImage:arr width:numberOfColumns height:numberOfRows];
  arr = nil;
  // Resize image
  return constructed;
}

@end
