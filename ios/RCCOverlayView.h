#import <UIKit/UIKit.h>
#import <React/RCTRootView.h>
#import <React/RCTRootViewDelegate.h>

@interface RCCOverlayView : UIView

@property (nonatomic, strong) RCTRootView *subView;

- (__nonnull instancetype)initWithComponentNameAndFrame:(NSString *__nonnull)component passProps:(NSDictionary *__nullable)passProps bridge:(RCTBridge *__nonnull)bridge frame:(CGRect)frame;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

@end
