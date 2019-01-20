//
//  FlexViewCell.m
//  EasyKitDemo
//
//  Created by xiaofeishen on 2019/1/20.
//  Copyright © 2019 EK. All rights reserved.
//

#import "FlexViewCell.h"
#import "EKFlexWrapView.h"
#import "FlexTagView.h"

@interface FlexViewCell()
@property (nonatomic, strong) EKFlexWrapView *flexView;
@end

@implementation FlexViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.flexView = [[EKFlexWrapView alloc] init];        
        self.flexView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.flexView.backgroundColor = [UIColor redColor];
        self.flexView.translatesAutoresizingMaskIntoConstraints = NO;
        self.flexView.preWidth = [UIScreen mainScreen].bounds.size.width - 20;
        [self.contentView addSubview:self.flexView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_flexView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_flexView]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_flexView]-10-|" options:0 metrics:nil views:views]];
        
    }
    return self;
}

- (void)setItem:(NSArray<NSString *> *)items {
    NSMutableArray *views = @[].mutableCopy;
    for (NSString *item in items) {
        FlexTagView *tagview = [[FlexTagView alloc] init];
        tagview.titleLabel.text = item;
        [views addObject:tagview];
    }
    self.flexView.itemViews = views;
//    [self.flexView setNeedsLayout];
    
}

@end
