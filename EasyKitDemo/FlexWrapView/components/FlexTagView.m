//
//  FlexTagView.m
//  EasyKitDemo
//
//  Created by xiaofeishen on 2019/1/12.
//  Copyright © 2019 EK. All rights reserved.
//

#import "FlexTagView.h"

@implementation FlexTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.blackColor.CGColor;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)sizeToFit {
    [super sizeToFit];
    [self.titleLabel sizeToFit];
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.titleLabel.frame) + 20, CGRectGetHeight(self.titleLabel.frame) + 10);
    self.titleLabel.frame = self.bounds;
}

@end
