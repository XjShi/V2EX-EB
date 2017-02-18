//
//  ReplyTableViewCell.m
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "Reply.h"
#import "UIImageView+WebCache.h"
#import "V2URLHelper.h"
#import "V2TimeHelper.h"
#import "TTTAttributedLabel+DetectUsername.h"

@interface ReplyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;


@end

@implementation ReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
    self.contentLabel.linkAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                                         NSForegroundColorAttributeName: kLinkColor};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTttDelegate:(id<TTTAttributedLabelDelegate>)tttDelegate {
    _tttDelegate = tttDelegate;
    self.contentLabel.delegate = tttDelegate;
}

- (void)setReply:(Reply *)reply {
    _reply = reply;
    [self.avatarImageView sd_setImageWithURL:[V2URLHelper getHTTPSLink:reply.member.avatar_normal] placeholderImage:nil];
    self.usernameLabel.text = reply.member.username;
    self.timestampLabel.text = [V2TimeHelper getEarlyTimeDescriptionFromTimestamp:reply.created];
    self.contentLabel.text = reply.content;
    [self.contentLabel detectUsernameAndAddLink];
}

- (void)setFloor:(NSInteger)floor {
    self.floorLabel.text = [NSString stringWithFormat:@"%ld楼", (long)floor];
}

@end
