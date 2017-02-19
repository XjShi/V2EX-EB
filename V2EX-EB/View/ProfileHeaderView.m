//
//  ProfileHeaderView.m
//  V2EX-EB
//
//  Created by xjshi on 19/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "Member.h"
#import "V2URLHelper.h"

static const CGFloat kAvatarHeight = 70.0;
static const CGFloat kNameLabelFontSize = 14.0;

@interface ProfileHeaderView ()

@property (nonatomic) UIImageView *avatarImageView;
@property (nonatomic) UILabel *nameLabel;

@end

@implementation ProfileHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    self.frame = CGRectMake(0, 0, kScreenWidth, 145);
    return self;
}

- (void)setMember:(Member *)member {
    _member = member;
    NSURL *url = [V2URLHelper getHTTPSLink:member.avatar_large];
    [self.avatarImageView sd_setImageWithURL:url];
    self.nameLabel.text = member.username;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(kAvatarHeight);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(kAvatarHeight);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.mas_centerX);
    }];
//    [self.nameLabel sizeToFit];
}

#pragma mark - Private
- (void)setupSubviews {
    self.avatarImageView = ({
        UIImageView *v = [[UIImageView alloc] init];
        v.layer.cornerRadius = kAvatarHeight / 2;
        v.layer.masksToBounds = YES;
        v;
    });
    [self addSubview:self.avatarImageView];
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:kNameLabelFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:self.nameLabel];
}

@end
