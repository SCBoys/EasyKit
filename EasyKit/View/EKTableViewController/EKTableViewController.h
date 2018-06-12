//
//  EKTableViewController.h
//  RoadHome
//
//  Created by TF14975 on 2017/7/12.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EKTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak, readonly) UITableView *tableView;
//自定义视图
@property (nonatomic, strong, nullable) UIView *topView;
@property (nonatomic, strong, nullable) UIView *bottomView;
@property (nonatomic, strong, readonly) UIView *topContainerView;

- (instancetype)initWithStyle:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
