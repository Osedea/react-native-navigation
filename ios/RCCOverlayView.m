#import <React/RCTRootView.h>
#import <React/RCTRootViewDelegate.h>
#import "RCCOverlayView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RCCOverlayView

- (instancetype)initWithProps:(NSDictionary *)overlayProps bridge:(RCTBridge *)bridge {
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];

        self.overlayProps = overlayProps;
        
        RCTRootView *reactView = [[RCTRootView alloc] initWithBridge:bridge moduleName:overlayProps[@"screen"] initialProperties:overlayProps[@"passProps"]];
        reactView.backgroundColor = [UIColor clearColor];

        self.subView = reactView;

        [self addSubview:reactView];
    }
    
    return self;
}

- (void)didMoveToSuperview {
    [self setupViewConstraints:self.overlayProps bottomView:nil];
}

- (CGFloat)getExtraBottomSpace {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        
        return window.safeAreaInsets.bottom;
    }
    
    return 0.0;
}

- (CGFloat)getExtraTopSpace {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        
        return window.safeAreaInsets.top;
    }
    
    return 0.0;
}

- (CGFloat)getExtraLeftSpace {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        
        return window.safeAreaInsets.left;
    }
    
    return 0.0;
}

- (CGFloat)getExtraRightSpace {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        
        return window.safeAreaInsets.right;
    }
    
    return 0.0;
}

- (void)setupViewConstraints:(NSDictionary *)overlayProps bottomView:(UIView *)bottomView {
    NSDictionary *style = overlayProps[@"style"];
    if (style == nil) {
        style = [[NSDictionary alloc] init];
    }
    
    BOOL unsafe = style[@"unsafe"];
    
    self.translatesAutoresizingMaskIntoConstraints = NO; // So that we can apply the constraints below ourselves
    self.subView.translatesAutoresizingMaskIntoConstraints = YES; // Let the subview flexibly fill the parent
    self.subView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    if (style[@"height"]) {
        CGFloat height = [[style objectForKey:@"height"] doubleValue];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
        constraint.active = YES;
    } else if (self.superview) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
        constraint.active = YES;
    }
    
    if (style[@"width"]) {
        CGFloat width = [[style objectForKey:@"width"] doubleValue];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
        constraint.active = YES;
    } else if (self.superview) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        constraint.active = YES;
    }
    
    if (self.superview) {
        NSString *align = style[@"align"];
        if (align == nil) {
            align = @"top";
        }
        
        if (bottomView) {
            // Sticks the bottom of this overlay view to the top of this view
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            constraint.active = YES;
        } else if (style[@"marginBottom"]) {
            CGFloat margin = [[style objectForKey:@"marginBottom"] doubleValue];
            if (!unsafe) {
                margin = margin + [self getExtraBottomSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"bottom"]) {
            CGFloat margin = 0.0;
            if (!unsafe) {
                margin = margin + [self getExtraBottomSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin];
            constraint.active = YES;
        }
        
        if (style[@"marginTop"]) {
            CGFloat margin = [[style objectForKey:@"marginTop"] doubleValue];
            if (!unsafe) {
                margin = margin + [self getExtraTopSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"top"]) {
            CGFloat margin = 0.0;
            if (!unsafe) {
                margin = margin + [self getExtraTopSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
            constraint.active = YES;
        }
        
        if (style[@"marginLeft"]) {
            CGFloat margin = [[style objectForKey:@"marginLeft"] doubleValue];
            if (!unsafe) {
                margin = margin + [self getExtraLeftSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"left"]) {
            CGFloat margin = 0.0;
            if (!unsafe) {
                margin = margin + [self getExtraLeftSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin];
            constraint.active = YES;
        }
        
        if (style[@"marginRight"]) {
            CGFloat margin = [[style objectForKey:@"marginRight"] doubleValue];
            if (!unsafe) {
                margin = margin + [self getExtraRightSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"right"]) {
            CGFloat margin = 0.0;
            if (!unsafe) {
                margin = margin + [self getExtraRightSpace];
            }
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:margin];
            constraint.active = YES;
        }
    }
}

@end
