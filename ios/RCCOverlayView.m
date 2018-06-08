#import <React/RCTRootView.h>
#import <React/RCTRootViewDelegate.h>
#import "RCCOverlayView.h"

@interface RCCOverlayView () <RCTRootViewDelegate>

@property (nonnull, nonatomic, strong, readwrite) RCTRootView *reactView;

@end

@implementation RCCOverlayView

- (instancetype)initWithComponentNameAndFrame:(NSString *__nonnull)component passProps:(NSDictionary *)passProps bridge:(RCTBridge *__nonnull)bridge frame:(CGRect) frame {
    RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:passProps];
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:reactView];
    
        reactView.delegate = self;
        reactView.backgroundColor = [UIColor clearColor];
        reactView.frame = frame;
    }
    return self;
}

- (void)rootViewDidChangeIntrinsicSize:(RCTRootView *)rootView {
    CGSize size = rootView.intrinsicContentSize;
    rootView.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
