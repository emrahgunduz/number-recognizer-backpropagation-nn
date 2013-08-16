//
//  emrDrawingView.h
//  NumberRecognition
//
//  Created by Emrah Gunduz on 3/9/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface emrDrawingView : NSView
{
  void *cacheAsBitmap;
  CGContextRef cacheContext;
  float hue;
  
  CGPoint point0;
  CGPoint point1;
  CGPoint point2;
  CGPoint point3;
  
  BOOL drawing;
}

- (void)clean;
- (NSImage*)imageFromView:(NSSize)imgSize;

@end
