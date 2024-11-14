//
//  RGLLogLevel.h
//  DocumentReader
//
//  Created by Serge Rylko on 27.05.24.
//  Copyright © 2024 Regula. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(RGLLogLevel)
typedef NSString* RGLLogLevel NS_TYPED_ENUM;

/// Fatal error
FOUNDATION_EXPORT RGLLogLevel const RGLLogLevelFatalError;

/// Error
FOUNDATION_EXPORT RGLLogLevel const RGLLogLevelError;

/// Warning
FOUNDATION_EXPORT RGLLogLevel const RGLLogLevelWarning;

/// Info
FOUNDATION_EXPORT RGLLogLevel const RGLLogLevelInfo;

/// Debug
FOUNDATION_EXPORT RGLLogLevel const RGLLogLevelDebug;
