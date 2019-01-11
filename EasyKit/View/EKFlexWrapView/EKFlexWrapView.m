//
//  EKFlexWrapView.m
//  EasyKit
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 EK. All rights reserved.
//

#import "EKFlexWrapView.h"

@implementation EKFlexWrapView

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < self._numberOfView; i++) {
        UIView *view = [self _ViewAtIndex:i];
        CGSize viewsize = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(ekFlexWrapView:viewSizeAtIndex:)]) {
            viewsize = [self _viewSizeAtIndex:i];
        }
    }
}

///fast method
- (NSInteger)_numberOfView {
    return [self.delegate ekFlexWrapViewNumberOfView:self];
}

- (UIView *)_ViewAtIndex:(NSInteger)index {
    return [self.delegate ekFlexWrapView:self viewAtIndex:index];
}

- (CGSize)_viewSizeAtIndex:(NSInteger)index {
    return [self.delegate ekFlexWrapView:self viewSizeAtIndex:index];
}

@end
