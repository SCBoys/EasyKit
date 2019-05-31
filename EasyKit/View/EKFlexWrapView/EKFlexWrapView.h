//
//  EKFlexWrapView.h
//  EasyKit
//
//  Created by apple on 2019/1/10.
//  Copyright © 2019年 EK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EKFlexWrapView : UIView

///预设视图宽度，默认是-1,会崩溃，必须设置
@property (nonatomic, assign) CGFloat preWidth;
//默认10
@property (nonatomic, assign) CGFloat rowSpace;
//默认10
@property (nonatomic, assign) CGFloat itemInnerSpace;
///默认zero
@property (nonatomic, assign) UIEdgeInsets contentInset;
//视图必须满足self-sizing
@property (nonatomic, copy) NSArray<UIView *> *itemViews;

@end

NS_ASSUME_NONNULL_END
