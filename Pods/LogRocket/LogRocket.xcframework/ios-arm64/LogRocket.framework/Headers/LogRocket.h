#import <Foundation/Foundation.h>

@protocol LROLifecycleDelegate;

//! Project version number for LogRocket.
FOUNDATION_EXPORT double LogRocketVersionNumber;

//! Project version string for LogRocket.
FOUNDATION_EXPORT const unsigned char LogRocketVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LogRocket/PublicHeader.h>
#import <LogRocket/LROReactNativeSwizzler.h>
#import <LogRocket/LRORNSVGSwizzle.h>
#import <LogRocket/LROViewTracker.h>
#import <LogRocket/LROException.h>
#import <LogRocket/LROWebPEncode.h>
#import <LogRocket/LROUncaughtExceptionHandler.h>
