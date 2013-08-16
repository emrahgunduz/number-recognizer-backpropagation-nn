//
//  emrImageData.h
//  NNetwork
//
//  Created by Emrah Gunduz on 2/14/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface emrImageData : NSObject

+ (NSArray*)compileForRun:(NSImage*)image;

+ (NSArray*)imageToArray:(NSImage*)image;
+ (NSImage*)arrayToImage:(NSArray*)arr width:(int)width height:(int)height;
+ (NSImage*)arrayToTrainingImage:(NSArray*)arr width:(int)width height:(int)height;

+ (NSImage*)resize:(NSImage*)image toSize:(NSSize)size;

+ (NSImage*)imageResizeByTrimming:(NSImage*)image size:(CGSize)size;
+ (NSImage*)crop:(NSImage*)image rect:(CGRect)rect;

@end
