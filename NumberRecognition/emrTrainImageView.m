//
//  emrTrainImageView.m
//  NumberRecognition
//
//  Created by Emrah Gunduz on 3/6/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrTrainImageView.h"
#import "emrImageData.h"
#import "emrImage.h"

@implementation emrTrainImageView

@synthesize viewImage, label;

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  return self;
}

- (void)setImage:(NSImage *)image
{
  viewImage = [[emrImageData resize:image toSize:self.bounds.size] imageByNormalising];
  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
  //CIImage *ciImage = [[CIImage alloc] initWithData:[viewImage TIFFRepresentation]];
  //
  //CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
  //[filter setDefaults];
  //[filter setValue:ciImage forKey:@"inputImage"];
  //CIImage* output = [filter valueForKey:@"outputImage"];
  //[output drawAtPoint:NSZeroPoint fromRect:NSRectFromCGRect([output extent]) operation:NSCompositeSourceOver fraction:1.0];
  
  [viewImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (NSImage*)imageFromView
{
  NSSize mySize  = self.bounds.size;
  NSSize imgSize = NSMakeSize( mySize.width, mySize.height );
  
  NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
  [bir setSize:imgSize];
  [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
  
  NSImage* image = [[NSImage alloc]initWithSize:imgSize] ;
  [image addRepresentation:bir];
  return image;
}

- (NSArray *)getLabelForOutput
{
  NSMutableArray *output = [NSMutableArray array];
  for (int i = 0; i <= 9; i++) {
    [output addObject:[NSNumber numberWithInt:(label == i ? 1 : 0)]];
  }
  return [output copy];
}

@end
