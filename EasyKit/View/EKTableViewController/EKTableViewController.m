//
//  EKTableViewController.m
//  RoadHome
//
//  Created by TF14975 on 2017/7/12.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "EKTableViewController.h"

@interface EKTableViewController ()
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomContainerView;
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) NSLayoutConstraint *bottomContainerView_h;
@property (nonatomic, strong) NSLayoutConstraint *topContainerView_h;
@end

@implementation EKTableViewController

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setWithStyle:style];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomContainerView = [[UIView alloc] init];
    self.bottomContainerView.backgroundColor = [UIColor clearColor];
    self.bottomContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor clearColor];
    self.topContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.topContainerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomContainerView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_topContainerView,_tableView,_bottomContainerView);
    //layout
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topContainerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomContainerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topContainerView][_tableView][_bottomContainerView]|" options:0 metrics:nil views:views]];
    
    self.topContainerView_h = [NSLayoutConstraint constraintWithItem:self.topContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    self.bottomContainerView_h = [NSLayoutConstraint constraintWithItem:self.bottomContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.topContainerView addConstraint:self.topContainerView_h];
    [self.bottomContainerView addConstraint:self.bottomContainerView_h];
}

#pragma mark - Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
#pragma mark - event response

#pragma mark - public method

#pragma mark - private method
- (void)setWithStyle:(UITableViewStyle)style {
    UITableViewController *tableController = [[UITableViewController alloc] initWithStyle:style];
    self.tableView = tableController.tableView;
    [self addChildViewController:tableController];
}

#pragma mark - getters and setters
- (void)setBottomView:(UIView *)bottomView {
    if (_bottomView != bottomView) {
        //移除视图
        [_bottomContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        //--
        _bottomView = bottomView;
        CGFloat height = 0;
        if (_bottomView) {
            height = CGRectGetHeight(_bottomView.frame);
        }
        self.bottomContainerView_h.constant = height;
        if (_bottomView == nil) {
            return;
        }
        [self.bottomContainerView addSubview:self.bottomView];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_bottomView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bottomView]|" options:0 metrics:nil views:views]];
    }
}

- (void)setTopView:(UIView *)topView {
    if (_topView != topView) {
        //移除视图
        [_topContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        //--
        _topView = topView;
        CGFloat height = 0;
        if (_topView) {
            height = CGRectGetHeight(_topView.frame);
        }
        self.topContainerView_h.constant = height;
        if (_topView == nil) {
            return;
        }
        
        [self.topContainerView addSubview:_topView];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_topView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView]|" options:0 metrics:nil views:views]];
    } else {
        self.topContainerView_h.constant = CGRectGetHeight(topView.frame);
    }
}

@end
