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

- (void)setupViewConstraints:(NSDictionary *)overlayProps bottomView:(UIView *)bottomView {
    NSDictionary *style = overlayProps[@"style"];
    if (style == nil) {
        style = [[NSDictionary alloc] init];
    }
    
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
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"bottom"]) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            constraint.active = YES;
        }
        
        if (style[@"marginTop"]) {
            CGFloat margin = [[style objectForKey:@"marginTop"] doubleValue];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"top"]) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            constraint.active = YES;
        }
        
        if (style[@"marginLeft"]) {
            CGFloat margin = [[style objectForKey:@"marginLeft"] doubleValue];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"left"]) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            constraint.active = YES;
        }
        
        if (style[@"marginRight"]) {
            CGFloat margin = [[style objectForKey:@"marginRight"] doubleValue];
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:margin];
            constraint.active = YES;
        } else if ([align isEqualToString:@"right"]) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            constraint.active = YES;
        }
    }
}

@end
