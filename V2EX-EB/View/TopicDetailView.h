//
//  TopicDetailView.h
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class Topic;
@class TopicDetailView;

@protocol TopicDetailViewDelegate <NSObject>

@optional
- (void)clickedUsername:(NSString *)username inTopicDetailView:(TopicDetailView *)view;

@end

@interface TopicDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame topic:(Topic *)topic;
@property (nonatomic, weak) id<TopicDetailViewDelegate> delegate;
@property (nonatomic, weak) id<TTTAttributedLabelDelegate> tttDelegate;

@end
