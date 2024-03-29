//
//  emrDrawingView.m
//  NumberRecognition
//
//  Created by Emrah Gunduz on 3/9/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrDrawingView.h"
#import "emrImageData.h"

@implementation emrDrawingView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  
  // Initialization code
  hue = 0.0f;
  BOOL contextInit = [self initContext:frame.size];
  if(contextInit) {
    NSLog(@"Drawing context initialized");
  } else {
    NSLog(@"Drawing context error");
  }
  
  NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self frame]
                                                              options:NSTrackingMouseMoved+NSTrackingActiveInKeyWindow
                                                                owner:self
                                                             userInfo:nil];
  [self addTrackingArea:trackingArea];
  [self becomeFirstResponder];
  
  drawing = NO;
  
  return self;
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

- (void)clean
{
  free(cacheAsBitmap);
  CGContextRelease(cacheContext);
  cacheContext = nil;
  
  BOOL contextInit = [self initContext:self.frame.size];
  if(contextInit) {
    NSLog(@"Drawing context initialized");
  } else {
    NSLog(@"Drawing context error");
  }
  
  [self setNeedsDisplay:YES];
}

- (NSImage*)imageFromView:(NSSize)imgSize
{
  NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
  [bir setSize:self.bounds.size];
  [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
  
  NSImage* image = [[NSImage alloc]initWithSize:imgSize] ;
  [image addRepresentation:bir];
  
  return [emrImageData resize:image toSize:imgSize];
}

- (void)drawRect:(NSRect)dirtyRect
{
  [[NSColor blackColor] setFill];
  NSRectFill(dirtyRect);
  if(cacheContext) {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGImageRef cacheImage = CGBitmapContextCreateImage(cacheContext);
    CGContextDrawImage(context, self.bounds, cacheImage);
    CGImageRelease(cacheImage);
  }
}

- (BOOL)initContext:(CGSize)size
{
	int bitmapByteCount;
	int	bitmapBytesPerRow;
	
  // Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow = (size.width * 4);
	bitmapByteCount = (bitmapBytesPerRow * size.height);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	cacheAsBitmap = malloc( bitmapByteCount );
	if (cacheAsBitmap == NULL){
		return NO;
	}
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	cacheContext = CGBitmapContextCreate (cacheAsBitmap,
                                        size.width,
                                        size.height,
                                        8,
                                        bitmapBytesPerRow,
                                        colorSpace,
                                        kCGImageAlphaPremultipliedFirst);
  
  CGColorSpaceRelease(colorSpace);
  
  CGContextSetRGBFillColor(cacheContext, 0.0f, 0.0f, 0.0f, 1.0f);
  CGContextSetRGBStrokeColor(cacheContext, 0.0f, 0.0f, 0.0f, 1.0f);
  CGContextFillRect(cacheContext, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
  
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
  drawing = YES;
  NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  
  point0 = CGPointMake(-1, -1);
  point1 = CGPointMake(-1, -1); // previous previous point
  point2 = CGPointMake(-1, -1); // previous touch point
  point3 = CGPointMake(curPoint.x, curPoint.y); // current touch point
}

- (void)mouseUp:(NSEvent *)theEvent
{
  drawing = NO;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
  if(drawing) {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    point0 = point1;
    point1 = point2;
    point2 = point3;
    point3 = CGPointMake(curPoint.x, curPoint.y);
    [self drawToCache];
  }
}

- (void)drawToCache
{
  if(point1.x > -1){
    hue += 0.005;
    if(hue > 1.0) hue = 0.0;
    //NSColor *color = [NSColor colorWithCalibratedHue:hue saturation:0.7 brightness:1.0 alpha:1.0];
    NSColor *color = [NSColor whiteColor];
    
    CGContextSetStrokeColorWithColor(cacheContext, [color CGColor]);
    CGContextSetLineCap(cacheContext, kCGLineCapRound);
    CGContextSetLineWidth(cacheContext, 18);
    
    double x0 = (point0.x > -1) ? point0.x : point1.x; //after 4 touches we should have a back anchor point, if not, use the current anchor point
    double y0 = (point0.y > -1) ? point0.y : point1.y; //after 4 touches we should have a back anchor point, if not, use the current anchor point
    double x1 = point1.x;
    double y1 = point1.y;
    double x2 = point2.x;
    double y2 = point2.y;
    double x3 = point3.x;
    double y3 = point3.y;
    // Assume we need to calculate the control
    // points between (x1,y1) and (x2,y2).
    // Then x0,y0 - the previous vertex,
    //      x3,y3 - the next one.
    
    double xc1 = (x0 + x1) / 2.0;
    double yc1 = (y0 + y1) / 2.0;
    double xc2 = (x1 + x2) / 2.0;
    double yc2 = (y1 + y2) / 2.0;
    double xc3 = (x2 + x3) / 2.0;
    double yc3 = (y2 + y3) / 2.0;
    
    double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    
    double k1 = len1 / (len1 + len2);
    double k2 = len2 / (len2 + len3);
    
    double xm1 = xc1 + (xc2 - xc1) * k1;
    double ym1 = yc1 + (yc2 - yc1) * k1;
    
    double xm2 = xc2 + (xc3 - xc2) * k2;
    double ym2 = yc2 + (yc3 - yc2) * k2;
    double smooth_value = 0.8;
    // Resulting control points. Here smooth_value is mentioned
    // above coefficient K whose value should be in range [0...1].
    float ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    float ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    
    float ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    float ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    
    CGContextMoveToPoint(cacheContext, point1.x, point1.y);
    CGContextAddCurveToPoint(cacheContext, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y, point2.x, point2.y);
    CGContextStrokePath(cacheContext);
    
    CGRect dirtyPoint1 = CGRectMake(point1.x-10, point1.y-10, 20, 20);
    CGRect dirtyPoint2 = CGRectMake(point2.x-10, point2.y-10, 20, 20);
    [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
  }
}

@end
