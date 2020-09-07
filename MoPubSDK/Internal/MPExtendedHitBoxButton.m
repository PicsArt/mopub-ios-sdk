//
//  MPExtendedHitBoxButton.m
//
//  Copyright 2018-2020 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

#import "MPExtendedHitBoxButton.h"

@implementation MPExtendedHitBoxButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        NSLog(@"MoPub SDK - MPExtendedHitBoxButton init %@", self);
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
        self.backgroundColor = [UIColor redColor];
    }
}

@end
