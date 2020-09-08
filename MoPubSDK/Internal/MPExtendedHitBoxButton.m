//
//  MPExtendedHitBoxButton.m
//
//  Copyright 2018-2020 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

#import "MPExtendedHitBoxButton.h"
#import "MPLogging.h"

@implementation MPExtendedHitBoxButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.accessibilityValue = @"TEST MPExtendedHitBoxButton WITH NO BACKGROUND COLOR";
        NSLog(@"MoPub SDK - MPExtendedHitBoxButton init %@", self);
        MPLogInfo(@"MoPub SDK - MPExtendedHitBoxButton init %@", self);
        MPLogDebug(@"MoPub SDK - MPExtendedHitBoxButton init %@", self);

    }
    return self;
}

#pragma mark - Overrides

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;

    // Increase the bounding rectangle by the amount of points specified by touchAreaInsets.
    // This will have the effect of enlarging the hitbox of the button.
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        NSLog(@"MoPub SDK - MPExtendedHitBoxButton added to superview");
        MPLogInfo(@"MoPub SDK - MPExtendedHitBoxButton added to superview");
        MPLogDebug(@"MoPub SDK - MPExtendedHitBoxButton added to superview");
        self.backgroundColor = [UIColor redColor];
    }
}

@end
