//
//  TopicDetailView.m
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "TopicDetailView.h"
#import "Masonry.h"
#import "Topic.h"
#import "Member.h"
#import "UIImageView+WebCache.h"
#import "V2URLHelper.h"
#import "V2TimeHelper.h"
#import "NSString+Extension.h"
#import "UIView+Extension.h"

#define kTitlteFont [UIFont systemFontOfSize:16]
#define kSubTitleFont [UIFont systemFontOfSize:12]
#define kContentFont [UIFont systemFontOfSize:14]

static const CGFloat kMargin = 8.0;
static const CGFloat kInterItemSpacing = 8.0;
static const CGFloat kAvatarHeight = 20.0;

@interface TopicDetailView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *memberNameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;

@end

@implementation TopicDetailView
{
    Topic *_topic;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame topic:(Topic *)topic {
    if (self = [super initWithFrame:frame]) {
        _topic = topic;
        [self setupSubviews];
        [self pupulate];
    }
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [self heightWithTopic:topic]);
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [self titleSizeWithTopic:_topic];
    self.titleLabel.frame = CGRectMake(kMargin, kMargin, kScreenWidth - kMargin*2, size.height);
    self.avatarImageView.frame = CGRectMake(kMargin, _titleLabel.bottom + kInterItemSpacing, kAvatarHeight, kAvatarHeight);
    size = [self subTitleSizeWithTopic:_topic];
    self.memberNameButton.frame = CGRectMake(_avatarImageView.right + kInterItemSpacing, _titleLabel.bottom + kInterItemSpacing, size.width, size.height);
    self.memberNameButton.centerY = self.avatarImageView.centerY;
    self.timeLabel.frame = CGRectMake(self.memberNameButton.right + kInterItemSpacing, 0, 250, size.height);
    self.timeLabel.centerY = self.avatarImageView.centerY;
    size = [self contentSizeWithTopic:_topic];
    self.contentLabel.frame = CGRectMake(kMargin, _avatarImageView.bottom + kInterItemSpacing, kScreenWidth - kMargin*2, size.height);
}

- (CGFloat)heightWithTopic:(Topic *)topic {
    CGSize titleSize = [self titleSizeWithTopic:topic];
    CGSize subTitleSize = [self subTitleSizeWithTopic:topic];
    CGSize contentSize = [self contentSizeWithTopic:topic];
    return kMargin*2 + kInterItemSpacing*2 + titleSize.height + MAX(subTitleSize.height, kAvatarHeight) + contentSize.height;
}

- (void)setTttDelegate:(id<TTTAttributedLabelDelegate>)tttDelegate {
    _tttDelegate = tttDelegate;
    self.contentLabel.delegate = tttDelegate;
}

#pragma mark - Private
- (void)setupSubviews {
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = kTitlteFont;
        label.numberOfLines = 0;
        label;
    });
    [self addSubview:self.titleLabel];
    
    self.avatarImageView = ({
        UIImageView *v = [[UIImageView alloc] init];
        v;
    });
    [self addSubview:self.avatarImageView];
    
    self.memberNameButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = kSubTitleFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(usernameClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.memberNameButton];
    
    self.timeLabel = ({
        UILabel *label = [UILabel new];
        label.font = kSubTitleFont;
        label;
    });
    [self addSubview:self.timeLabel];
    
    self.contentLabel = ({
        TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        label.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
        label.linkAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                                 NSForegroundColorAttributeName: kLinkColor};
        label.font = kContentFont;
        label.numberOfLines = 0;
        label;
    });
    [self addSubview:self.contentLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [self heightWithTopic:_topic] - 1, self.width, 1)];
    view.backgroundColor = kOrnamentColor;
    [self addSubview:view];
}

- (void)pupulate {
    self.titleLabel.text = _topic.title;
    [self.avatarImageView sd_setImageWithURL:[V2URLHelper getHTTPSLink:_topic.member.avatar_mini]];
    [self.memberNameButton setTitle:_topic.member.username forState:UIControlStateNormal];
    self.timeLabel.text = [V2TimeHelper getEarlyTimeDescriptionFromTimestamp:_topic.last_modified];
    self.contentLabel.text = [self generateAttributedString];
}

- (CGSize)titleSizeWithTopic:(Topic *)topic {
    return [topic.title sizeWithFont:kTitlteFont constrainSize:CGSizeMake(kScreenWidth - 2*kMargin, CGFLOAT_MAX)];
}

- (CGSize)subTitleSizeWithTopic:(Topic *)topic {
    return [topic.member.username sizeWithFont:kSubTitleFont constrainSize:CGSizeMake(kScreenWidth - 2*kMargin, CGFLOAT_MAX)];
}

- (CGSize)contentSizeWithTopic:(Topic *)topic {
//    return [topic.content sizeWithFont:kContentFont constrainSize:CGSizeMake(kScreenWidth - 2*kMargin, CGFLOAT_MAX)];
    return [TTTAttributedLabel sizeThatFitsAttributedString:[self generateAttributedString]
                                            withConstraints:CGSizeMake(kScreenWidth - 2*kMargin, CGFLOAT_MAX)
                                     limitedToNumberOfLines:0];
}

- (void)usernameClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickedUsername:inTopicDetailView:)]) {
        [self.delegate clickedUsername:_topic.member.username inTopicDetailView:self];
    }
}

- (NSAttributedString *)generateAttributedString {
    NSDictionary *attr = @{NSFontAttributeName: kContentFont};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_topic.content attributes:attr];
    return attributedString;
}

@end
