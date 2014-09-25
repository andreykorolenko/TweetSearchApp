//
//  TweetCell.h
//  TweetSearch
//
//  Created by Андрей on 25.09.14.
//  Copyright (c) 2014 Андрей. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *textTweet;

@end
