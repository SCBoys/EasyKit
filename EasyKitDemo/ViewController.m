//
//  ViewController.m
//  EasyKitDemo
//
//  Created by TF14975 on 2017/11/16.
//  Copyright © 2017年 EK. All rights reserved.
//

#import "ViewController.h"
#import "EKBottomPopView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,EKBottomPopViewDelegate>
@property (nonatomic, weak) EKBottomPopView *popView;
@property (nonatomic, copy) NSArray<NSString *> *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = @[@"1",@"2",@"3",@"4"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"显示" forState: UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(button);
    [button.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[button(44)]" options:0 metrics:nil views:views]];
    [button.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(100)]" options:0 metrics:nil views:views]];
    [button.superview addConstraint:[NSLayoutConstraint constraintWithItem:button.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)buttonClick:(id)sender {
    NSLog(@"点击显示按钮");
    
    EKBottomPopView *aPopView = [[EKBottomPopView alloc] init];
    aPopView.titleLabel.text = @"选择时间";
    aPopView.popViewDelegate = self;
    aPopView.tableView.delegate = self;
    aPopView.tableView.dataSource = self;
    [aPopView.leftTopBarButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [aPopView.rightTopBarButton addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    self.popView = aPopView;
    [aPopView showInView:self.view];
}

- (void)cancel {
    NSLog(@"cancel");
    [self.popView dismiss];
}

- (void)ok {
    NSLog(@"ok");
    [self.popView dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ider = @"cell";
    NSString *item = self.dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ider];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ider];
    }
    cell.textLabel.text = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did selected");
    [self.popView dismiss];
}

- (void)ekBottomPopViewClickOnMaskView:(EKBottomPopView *)view {
    [view dismiss];
}

@end
