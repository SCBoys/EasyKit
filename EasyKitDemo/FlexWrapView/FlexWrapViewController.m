//
//  FlexWrapViewController.m
//  EasyKitDemo
//
//  Created by xiaofeishen on 2019/1/12.
//  Copyright © 2019 EK. All rights reserved.
//

#import "FlexWrapViewController.h"
#import "EKFlexWrapView.h"
#import "FlexTagView.h"

@interface FlexWrapViewController ()
@property (nonatomic, strong) EKFlexWrapView *flexView;
@property (nonatomic, copy) NSArray *data;
@end

@implementation FlexWrapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = @[@"asd",@"asdasd",@"xzcawqweqwe",@"asdasd",@"asdasd",@"asdasd",@"asdasd"];

    self.view.backgroundColor = [UIColor whiteColor];
    self.flexView = [[EKFlexWrapView alloc] init];
    self.flexView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.flexView.backgroundColor = [UIColor redColor];
//    self.flexView.delegate = self;
    [self.view addSubview:_flexView];

    NSMutableArray *views = @[].mutableCopy;
    for (NSString *item in self.data) {
        FlexTagView *tagview = [[FlexTagView alloc] init];
        tagview.titleLabel.text = item;
        [views addObject:tagview];
    }
    self.flexView.itemViews = views;
    
    self.flexView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
}

//- (NSInteger)ekFlexWrapViewNumberOfView:(EKFlexWrapView *)view {
//    return self.data.count;
//}
//
//- (UIView *)ekFlexWrapView:(EKFlexWrapView *)view viewAtIndex:(NSInteger)index {
////    return expression
//}
//
//- (CGSize)ekFlexWrapView:(EKFlexWrapView *)view viewSizeAtIndex:(NSInteger)index {
//
//}

@end
