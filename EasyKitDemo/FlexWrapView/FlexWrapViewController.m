//
//  FlexWrapViewController.m
//  EasyKitDemo
//
//  Created by xiaofeishen on 2019/1/12.
//  Copyright © 2019 EK. All rights reserved.
//

#import "FlexWrapViewController.h"

#import "FlexTagView.h"
#import "FlexViewCell.h"

@interface FlexWrapViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) EKFlexWrapView *flexView;
//@property (nonatomic, copy) NSArray *data;
@end

@implementation FlexWrapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.data = @[@"asd",@"asdasd",@"xzcawqweqwe",@"asdasd",@"asdasd",@"asdasd",@"asdasd"];

    self.view.backgroundColor = [UIColor whiteColor];
//    self.flexView = [[EKFlexWrapView alloc] init];
//    self.flexView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
//    self.flexView.backgroundColor = [UIColor redColor];
//    self.flexView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.flexView.delegate = self;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.estimatedRowHeight = 40;
    [self.tableView registerClass:[FlexViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];

//    NSMutableArray *views = @[].mutableCopy;
//    for (NSString *item in self.data) {
//        FlexTagView *tagview = [[FlexTagView alloc] init];
//        tagview.titleLabel.text = item;
//        [views addObject:tagview];
//    }
//    self.flexView.itemViews = views;
    
    NSDictionary *tviews = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:tviews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:tviews]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlexViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSArray *data;
    if (indexPath.row == 0) {
        data = @[@"asd",@"asdasd",@"xzcawqweqwe",@"asdasd",@"asdasd",@"asdasd",@"asdasd",@"asdasd",@"asdasd",@"asdasd",@"asdasd"];
    } else {
        data = @[@"asd",@"asdasd",@"xzcawqweqwe",@"asdasd"];
    }
    [cell setItem:data];
    return cell;
}

@end
