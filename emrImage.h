/*
 * Copyright (c) 2011 b2cloud
 * By Will Sackfield
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for specific language governing permissions and
 * limitations under the License.
 *
 * File: NSImage+simple-image-processing.h
 *
 * 1.0 (13/09/2011)
 */
#import <Foundation/Foundation.h>

@interface NSImage (NSImage_simple_image_processing)

// Resize the image the size given by a CGSize element
-(NSImage*) imageResize:(CGSize)size;
// Extract the edges using a canny edge extraction based on the low and high values
-(NSImage*) imageByCannyEdgeExtractionLow:(CGFloat)low high:(CGFloat)high;
// Perform automatic local threshold
-(NSImage*) imageByLocalThreshold;
// Perform thresholding using the entire image as a threshold
-(NSImage*) imageByThresholding;
// Perform a gaussian blur on an image
-(NSImage*) imageByGaussianBlur;
// Extract a connected region from an image
// NSArray is full of CGPoints
-(NSArray*) connectedRegionFromPoint:(CGPoint)point;
// Extract the largest region from an image
// NSArray is full of CGPoints
-(NSArray*) largestRegion;
// Perform normalisation on an image
-(NSImage*) imageByNormalising;
// Rotate the image (in radians)
-(NSImage*) imageRotate:(CGFloat)radians;
// Perform histogram equalisation on an image
-(NSImage*) imageByHistogramEqualisation;
// Perform topological skeleton on an image
-(NSImage*) imageByTopologicalSkeleton;
// Turn an array of CGPoints into a CGRect (if you want to box objects)
-(CGRect) rectForImagePoints:(NSArray*)points;

@end