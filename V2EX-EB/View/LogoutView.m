//
//  LogoutView.m
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "LogoutView.h"

@interface LogoutView ()

@property (nonatomic, copy) Handler handler;

@end
@implementation LogoutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame handler:(Handler)handler {
    if (self = [super initWithFrame:frame]) {
        _handler = [handler copy];
        [self commonInit];
    }
    return self;
}

#pragma mark - private
- (void)commonInit {
    const CGFloat width = kScreenWidth - 20.0;
    const CGFloat height = 44.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenWidth - width) / 2.0, 36.0, width, height);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"注销" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.layer.cornerRadius = 5.0;
    button.layer.masksToBounds = YES;
    [self addSubview:button];
}
- (void)buttonClicked:(UIButton *)sender {
    if (_handler) {
        _handler();
    }
}

@end
