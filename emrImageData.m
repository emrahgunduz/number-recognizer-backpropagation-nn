//
//  emrImageData.m
//  NNetwork
//
//  Created by Emrah Gunduz on 2/14/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrImageData.h"

@implementation emrImageData

+ (NSArray*)compileForRun:(NSImage*)image
{
  NSMutableArray *input = [NSMutableArray array];
  
  @autoreleasepool {
    NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    CGImageRef imageRef         = [bitmapImageRep CGImage];
    NSUInteger width            = CGImageGetWidth(imageRef);
    NSUInteger height           = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData      = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel    = 4;
    NSUInteger bytesPerRow      = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Total (x * x) + 2x inputs
    // x rows
    // x columns
    // x squares
    int x = 15;
    
    int colcount = x;
    int rowcount = x;
    
    int col = (int)(width / colcount);
    int row = (int)(height / rowcount);
    
    // x columns
    for (int i = 0; i < colcount; i++) {
      
      double color = 0.0f;
      int count = 0;
      
      for (int x = 0; x < col; x++) {
        for(int y = 0; y < height; y++) {
          
          int xx = col + col*i;
          unsigned long byteIndex = (bytesPerRow * y) + xx * bytesPerPixel;
          float red   = (float)rawData[byteIndex];
          float green = (float)rawData[byteIndex + 1];
          float blue  = (float)rawData[byteIndex + 2];
          
          color += roundf((red+green+blue)/255.0f/3.0f*100.0f)/100.0f;
          count++;
        }
      }
      
      color /= count;
      [input addObject:[NSNumber numberWithDouble:color]];
    }
    
    // x rows
    for (int i = 0; i < rowcount; i++) {
      
      double color = 0.0f;
      int count = 0;
      
      for (int y = 0; y < row; y++) {
        for(int x = 0; x < width; x++) {
          
          int yy = row + row*i;
          unsigned long byteIndex = (bytesPerRow * yy) + x * bytesPerPixel;
          float red   = (float)rawData[byteIndex];
          float green = (float)rawData[byteIndex + 1];
          float blue  = (float)rawData[byteIndex + 2];
          
          color += roundf((red+green+blue)/255.0f/3.0f*100.0f)/100.0f;
          count++;
        }
      }
      
      color /= count;
      [input addObject:[NSNumber numberWithDouble:color]];
    }
    
    // x * x squares
    for (int i = 0; i < colcount; i++) {
      for (int j = 0; j < rowcount; j++) {
        
        double color = 0.0f;
        int count = 0;        
        
        int xstart = col * i;
        int xend   = col + col * i;
        int ystart = row * j;
        int yend   = row + row * j;
        
        for (int x = xstart; x < xend; x++) {
          for (int y = ystart; y < yend; y++) {
            unsigned long byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            float red   = (float)rawData[byteIndex];
            float green = (float)rawData[byteIndex + 1];
            float blue  = (float)rawData[byteIndex + 2];
            
            color += roundf((red+green+blue)/255.0f/3.0f*100.0f)/100.0f;
            count++;
          }
        }
        
        color /= count;
        [input addObject:[NSNumber numberWithDouble:color]];        
      }
    }
    
    free(rawData);
  }
  
  return input;
}

+ (NSArray*)imageToArray:(NSImage*)image
{
  NSMutableArray *arr = [NSMutableArray array];
  
  @autoreleasepool {
    NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    CGImageRef imageRef         = [bitmapImageRep CGImage];
    NSUInteger width            = CGImageGetWidth(imageRef);
    NSUInteger height           = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData      = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel    = 4;
    NSUInteger bytesPerRow      = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    for(int y = 0; y < height; y++) {
      for(int x = 0; x < width; x++) {
        unsigned long byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
        float red   = (float)rawData[byteIndex];
        float green = (float)rawData[byteIndex + 1];
        float blue  = (float)rawData[byteIndex + 2];
        
        float color = roundf((red+green+blue)/255.0f/3.0f*100.0f)/100.0f;
        [arr addObject:[NSNumber numberWithFloat:color]];
      }
    }
    
    free(rawData);
  }
  
  return arr;
}

+ (NSImage*)arrayToImage:(NSArray*)arr width:(int)width height:(int)height
{
  unsigned char *rawData = malloc(height * width * 4);
  
  for(int i = 0; i < arr.count; i++) {
    float color = [[arr objectAtIndex:i] floatValue];
    
		rawData[i * 4] = (char)(color*255);
		rawData[i * 4 + 1] = (char)(color*255);
		rawData[i * 4 + 2] = (char)(color*255);
    rawData[i * 4 + 3] = (char)(255);
  }
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGContextRef ctx = CGBitmapContextCreate(rawData,
                              width,
                              height,
                              8,
                              width*4,
                              colorSpace,
                              kCGImageAlphaNoneSkipLast);
	
	CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
	
  NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
  NSImage* rawImage = [[NSImage alloc] init];
  [rawImage addRepresentation:bitmapImageRep];
  
  CGImageRelease(imageRef);
  CGContextRelease(ctx);
  CGColorSpaceRelease(colorSpace);
  free(rawData);
  return rawImage;
}

+ (NSImage*)arrayToTrainingImage:(NSArray*)arr width:(int)width height:(int)height
{
  unsigned char *rawData = malloc(height * width * 4);
  
  for(int i = 0; i < arr.count; i++) {
    float color = [[arr objectAtIndex:i] intValue];
    
		rawData[i * 4] = (char)(color);
		rawData[i * 4 + 1] = (char)(color);
		rawData[i * 4 + 2] = (char)(color);
    rawData[i * 4 + 3] = (char)(255);
  }
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  CGContextRef ctx = CGBitmapContextCreate(rawData,
                                           width,
                                           height,
                                           8,
                                           width*4,
                                           colorSpace,
                                           kCGImageAlphaNoneSkipLast);
	
	CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
	
  NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
  NSImage* rawImage = [[NSImage alloc] init];
  [rawImage addRepresentation:bitmapImageRep];
	
	free(rawData);
  CGColorSpaceRelease(colorSpace);
  CGImageRelease(imageRef);
  CGContextRelease(ctx);
	
  return [self imageResizeByTrimming:rawImage size:rawImage.size];
}

+ (NSImage*)resize:(NSImage*)image toSize:(NSSize)size
{
  NSImageView* kView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, size.width, size.height)];
  [kView setImageScaling:NSImageScaleProportionallyUpOrDown];
  [kView setImage:image];
  
  NSRect kRect = kView.frame;
  NSBitmapImageRep* kRep = [kView bitmapImageRepForCachingDisplayInRect:kRect];
  [kView cacheDisplayInRect:kRect toBitmapImageRep:kRep];
  
  NSData* kData = [kRep representationUsingType:NSJPEGFileType properties:nil];
  NSImage *img = [[NSImage alloc] initWithData:kData];
  
  return img;
}

+ (NSImage*)imageResizeByTrimming:(NSImage*)image size:(CGSize)size
{
  NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
  CGImageRef imageRef         = [bitmapImageRep CGImage];
  NSUInteger width            = CGImageGetWidth(imageRef);
  NSUInteger height           = CGImageGetHeight(imageRef);
  CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
  unsigned char *rawData      = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
  NSUInteger bytesPerPixel    = 4;
  NSUInteger bytesPerRow      = bytesPerPixel * width;
  NSUInteger bitsPerComponent = 8;
  CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                               bitsPerComponent, bytesPerRow, colorSpace,
                                               kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
  CGContextRelease(context);
  
  // TOP LEFT
  int minX = (int)width;
  int minY = (int)height;
  int maxX = 0;
  int maxY = 0;
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      int byteIndex = (int)((bytesPerRow * y) + x * bytesPerPixel);
      float red  = (float)rawData[byteIndex];
      if(red > 0) {
        minX = MIN(minX, x);
        minY = MIN(minY, y);
        maxX = MAX(maxX, x);
        maxY = MAX(maxY, y);
      }
    }
  }
  free(rawData);
  
  // Crop image
  NSImage *cropped = [self crop:image rect:CGRectMake(minX, minY, maxX - minX, maxY - minY)];
  // Resize image
  return cropped;
}

+ (NSImage *)crop:(NSImage*)image rect:(CGRect)rect
{
  NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
  CGImageRef imageRef = CGImageCreateWithImageInRect([bitmapImageRep CGImage], rect);
  NSImage *result = [[NSImage alloc] initWithCGImage:imageRef size:image.size];
  NSBitmapImageRep *bitmapImageRepX = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
  [result addRepresentation:bitmapImageRepX];
  CGImageRelease(imageRef);
  return result;
}
@end
