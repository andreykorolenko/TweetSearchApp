//
//  TweetCell.m
//  TweetSearch
//
//  Created by Андрей on 25.09.14.
//  Copyright (c) 2014 Андрей. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textTweet = [[UILabel alloc] init];
        [self.textTweet setNumberOfLines:0];
        [self.textTweet setFont:[UIFont fontWithName:@"Gill Sans" size:12.0f]];
        [self.textTweet setLineBreakMode:NSLineBreakByWordWrapping];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize expectedSize = [self.textTweet.text boundingRectWithSize:CGSizeMake(279, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: self.textTweet.font} context:nil].size;
    self.textTweet.frame = CGRectMake(14, 64, 279, expectedSize.height);
    [self addSubview:_textTweet];
}

@end
