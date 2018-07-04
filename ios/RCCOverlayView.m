#import <React/RCTRootView.h>
#import <React/RCTRootViewDelegate.h>
#import "RCCOverlayView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RCCOverlayView

- (instancetype)initWithComponentNameAndFrame:(NSString *__nonnull)component passProps:(NSDictionary *)passProps bridge:(RCTBridge *__nonnull)bridge frame:(CGRect) frame {

    if (self = [super initWithFrame:frame]) {
        RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:component initialProperties:passProps];
        self.subView = reactView;
        self.backgroundColor = [UIColor clearColor];

        reactView.backgroundColor = [UIColor clearColor];

        [reactView setFrame:self.bounds];

        [self addSubview:reactView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.subView) {
        [self.subView setFrame:self.bounds];
    }
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGRect frame = self.frame;
    frame.size.width = size.width;
    [self setFrame:frame];
}


@end
