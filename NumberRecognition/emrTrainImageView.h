//
//  emrTrainImageView.h
//  NumberRecognition
//
//  Created by Emrah Gunduz on 3/6/13.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface emrTrainImageView : NSView

@property (strong) NSImage *viewImage;
@property (assign) int label;

- (void)setImage:(NSImage *)image;
- (NSImage*)imageFromView;
- (NSArray*)getLabelForOutput;
@end
