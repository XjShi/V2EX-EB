//
//  TopicListTableViewCell.m
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "TopicListTableViewCell.h"
#import "Topic.h"
#import "Member.h"
#import "Node.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "V2URLHelper.h"
#import "V2TimeHelper.h"

@interface TopicListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UIButton *nodenameButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation TopicListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 3.0;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)usernameClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(topicListTableViewCell:memberNameClicked:)]) {
        [self.delegate topicListTableViewCell:self memberNameClicked:_topic.member];
    }
}

- (IBAction)nodeButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(topicListTableViewCell:nodenameClicked:)]) {
        [self.delegate topicListTableViewCell:self nodenameClicked:_topic.node];
    }
}

- (void)setTopic:(Topic *)topic {
    _topic = topic;
    [self.avatarImageView sd_setImageWithURL:[V2URLHelper getHTTPSLink:topic.member.avatar_mini] completed:NULL];
    [self.usernameButton setTitle:topic.member.username forState:UIControlStateNormal];
    [self.nodenameButton setTitle:topic.node.title forState:UIControlStateNormal];
    self.timeLabel.text = [V2TimeHelper getEarlyTimeDescriptionFromTimestamp:topic.last_modified];
    self.contentLabel.text = topic.title;
}

@end
