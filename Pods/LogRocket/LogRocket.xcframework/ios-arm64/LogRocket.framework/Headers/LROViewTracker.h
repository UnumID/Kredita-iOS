#ifndef LROViewTracker_h
#define LROViewTracker_h

@interface LROViewTracker : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLifecycleDelegate:(id <LROLifecycleDelegate>)lifecycleDelegate NS_DESIGNATED_INITIALIZER;
- (void)start;
- (void)shutdown;

@end

#endif /* LROViewTracker_h */
