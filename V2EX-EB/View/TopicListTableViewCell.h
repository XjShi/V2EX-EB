//
//  TopicListTableViewCell.h
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;
@class Member;
@class Node;
@class TopicListTableViewCell;

@protocol TopicListTableViewCellDelegate <NSObject>

@optional
- (void)topicListTableViewCell:(TopicListTableViewCell *)cell memberNameClicked:(Member *)member;
- (void)topicListTableViewCell:(TopicListTableViewCell *)cell nodenameClicked:(Node *)node;

@end
@interface TopicListTableViewCell : UITableViewCell

@property (nonatomic, strong) Topic *topic;
@property (nonatomic, weak) id<TopicListTableViewCellDelegate> delegate;

@end
