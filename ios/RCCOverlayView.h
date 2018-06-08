#import <UIKit/UIKit.h>

@class RCTRootView;
@class RCTBridge;

@interface RCCOverlayView : UIView

@property (nonnull, nonatomic, strong, readonly) RCTRootView *reactView;

- (__nonnull instancetype)initWithComponentNameAndFrame:(NSString *__nonnull)component passProps:(NSDictionary *__nullable)passProps bridge:(RCTBridge *__nonnull)bridge frame:(CGRect)frame;

@end
