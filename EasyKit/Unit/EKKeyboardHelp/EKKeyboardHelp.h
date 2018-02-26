//
//  EKKeyboardHelp.h
//  RoadHome
//
//  Created by TF14975 on 2018/2/5.
//  Copyright © 2018年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKKeyboardHelp : NSObject


/**
 计算键盘覆盖视图的高度

 @param adjustView 需要调整的视图
 @param notification 键盘UIKeyboardWillChangeFrameNotification通知的NSNotification
 @return 返回值小于0，表示视图被键盘覆盖。e.g. 值-20，表示键盘的指定视图的高度为20.
 */
+ (CGFloat)overlappingHeightByView:(UIView *)adjustView keyboardFrameChangedNotification:(NSNotification *)notification;

@end
