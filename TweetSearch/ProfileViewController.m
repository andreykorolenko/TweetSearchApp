//
//  ProfileViewController.m
//  TweetSearch
//
//  Created by Андрей on 25.09.14.
//  Copyright (c) 2014 Андрей. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFriendsCount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userNameLabel.text = self.tweet.userName;
    self.userFriendsCount.text = [NSString stringWithFormat:@"Друзья: %@", self.tweet.countFriends];
    
    self.userImageView.image = nil;
    
    NSURL *url = [NSURL URLWithString:self.tweet.profileImageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.userImageView setImageWithURLRequest:request placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           self.userImageView.image = image;
                                           [self.view layoutSubviews];
                                       } failure:nil];
    
    // border вокруг фото профиля
    [self.userImageView.layer setBorderColor: [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor]];
    [self.userImageView.layer setBorderWidth:3.0f];
}

@end
