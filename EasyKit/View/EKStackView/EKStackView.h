//
//  EKStackView.h
//  EndoscopyEvaluation
//
//  Created by xiaofeishen on 2018/12/28.
//  Copyright © 2018 xiaofeishen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EKStackView : UIView

//默认yes
@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, copy) NSArray<UIView *> *views;

@end

NS_ASSUME_NONNULL_END
