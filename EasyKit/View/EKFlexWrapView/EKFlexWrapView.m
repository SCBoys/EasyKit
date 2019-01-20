//
//  EKFlexWrapView.m
//  EasyKit
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 EK. All rights reserved.
//

#import "EKFlexWrapView.h"

@implementation EKFlexWrapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentInset = UIEdgeInsetsZero;
        _rowSpace = 10;
        _itemInnerSpace = 10;
        _preWidth = -1;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)setItemViews:(NSArray<UIView *> *)itemViews {
    for (UIView *itemview in _itemViews) {
        [itemview removeFromSuperview];
    }
    _itemViews = [itemViews copy];
    [self removeConstraints:self.constraints];
    [self resetViews];
}

- (void)resetViews {
    NSAssert(self.preWidth > 0, @"EKFlexWrapView class need to set Property preWidth > 0");
    
    NSInteger currentRowIndex = 0;
    NSInteger currentX = self.contentInset.left;
    NSInteger currentY = self.contentInset.top;
    CGFloat maxHeightOfRowItem = 0; //记录一行中高度最高的值，换行的时候清零
    for (int i = 0; i < self._numberOfView; i++) {
        UIView *view = [self _ViewAtIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        if ([view superview] == nil) {
            [self addSubview:view];
        }
        //获取当前视图的size
        CGSize viewsize = [self _viewSizeAtIndex:i];
        NSAssert((viewsize.width > 0 && viewsize.height > 0), @"EKFlexWrapView 类的属性 itemViews中的视图必须实现sizeToFit函数来计算得出自身的size");
        //判断是否要进入下一行
        if (currentX + viewsize.width + self.contentInset.right > self.preWidth) { //布局需要进入下一行
            currentRowIndex++;
            currentX = self.contentInset.left;
            currentY += maxHeightOfRowItem + self.rowSpace;
        } else { //保持当前行
            //更新最高的height
            maxHeightOfRowItem = MAX(viewsize.height, maxHeightOfRowItem);
        }
        //布局位置
        CGFloat x = currentX;
        CGFloat y = currentY;
        //layout
        NSDictionary *views = @{@"view":view};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view(h)]" options:0 metrics:@{@"top":@(y),@"h":@(viewsize.height)} views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view(w)]" options:0 metrics:@{@"left":@(x),@"w":@(viewsize.width)} views:views]];
        
        //更新行向位置
        currentX += viewsize.width + self.itemInnerSpace;
    }
    
    CGFloat height = currentY + maxHeightOfRowItem + self.contentInset.bottom;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.preWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
    
//    CGRect selfFrame = self.frame;
//    selfFrame.size.height = currentY + maxHeightOfRowItem + self.contentInset.bottom;
//    self.frame = selfFrame;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    NSInteger currentRowIndex = 0;
//    NSInteger currentX = self.contentInset.left;
//    NSInteger currentY = self.contentInset.top;
//    CGFloat maxHeightOfRowItem = 0; //记录一行中高度最高的值，换行的时候清零
//    for (int i = 0; i < self._numberOfView; i++) {
//        UIView *view = [self _ViewAtIndex:i];
//        if ([view superview] == nil) {
//            [self addSubview:view];
//        }
//        //获取当前视图的size
//        CGSize viewsize = [self _viewSizeAtIndex:i];
//        //判断是否要进入下一行
//        if (currentX + viewsize.width + self.contentInset.right > self.frame.size.width) { //布局需要进入下一行
//            currentRowIndex++;
//            currentX = self.contentInset.left;
//            currentY += maxHeightOfRowItem + self.rowSpace;
//        } else { //保持当前行
//            //更新最高的height
//            maxHeightOfRowItem = MAX(viewsize.height, maxHeightOfRowItem);
//        }
//
//        //布局位置
//        CGFloat x = currentX;
//        CGFloat y = currentY;
//        view.frame = CGRectMake(x, y, viewsize.width, viewsize.height);
//
//        //更新行向位置
//        currentX += viewsize.width + self.itemInnerSpace;
//    }
//
//    CGRect selfFrame = self.frame;
//    selfFrame.size.height = currentY + maxHeightOfRowItem + self.contentInset.bottom;
//    self.frame = selfFrame;
//}

///fast method
- (NSInteger)_numberOfView {
    return self.itemViews.count;
}

- (UIView *)_ViewAtIndex:(NSInteger)index {
    return self.itemViews[index];
}

- (CGSize)_viewSizeAtIndex:(NSInteger)index {
    UIView *view = self.itemViews[index];
    [view sizeToFit];
    return view.frame.size; 
}

@end
