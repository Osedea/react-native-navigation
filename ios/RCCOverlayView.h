#import <UIKit/UIKit.h>
#import <React/RCTRootView.h>
#import <React/RCTRootViewDelegate.h>

@interface RCCOverlayView : UIView

@property (nonatomic, strong) RCTRootView *subView;
@property (nonatomic, strong) NSDictionary *overlayProps;

- (instancetype)initWithProps:(NSDictionary *)overlayProps bridge:(RCTBridge *)bridge;

@end
