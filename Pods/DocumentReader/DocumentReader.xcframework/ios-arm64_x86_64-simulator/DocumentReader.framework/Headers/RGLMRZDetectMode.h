//
//  RGLMRZDetectMode.h
//  DocumentReader
//
//  Created by Serge Rylko on 24.05.24.
//  Copyright © 2024 Regula. All rights reserved.
//


#import <Foundation/Foundation.h>

/// Enumeration contains the types of barcodes that can be processed
typedef NS_ENUM(NSInteger, RGLMRZDetectMode) {
  RGLMRZDetectModeDefault = 0,
  RGLMRZDetectModeResizeBinarizeWindow = 1,
  RGLMRZDetectModeBlurBeforeBinarization = 2
} NS_SWIFT_NAME(MRZDetectMode);
