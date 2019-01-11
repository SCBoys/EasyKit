//
//  EKFlexWrapView.h
//  EasyKit
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EKFlexWrapView;
@protocol EKFlexWrapViewDelegate <NSObject>
@required
- (NSInteger)ekFlexWrapViewNumberOfView:(EKFlexWrapView *)view;
- (UIView *)ekFlexWrapView:(EKFlexWrapView *)view viewAtIndex:(NSInteger)index;
@optional
//如果 - (UIView *)ekFlexWrapView:(EKFlexWrapView *)view viewAtIndex:(NSInteger)index; 中返回的view.frame设置了size就不需要再实现该方法了, 若实现该方法，则会覆盖前面的view 的frame.size
- (CGSize)ekFlexWrapView:(EKFlexWrapView *)view viewSizeAtIndex:(NSInteger)index;
@end

@interface EKFlexWrapView : UIView

@property(nonatomic, weak) id<EKFlexWrapViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
