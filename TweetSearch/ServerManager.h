//
//  ServerManager.h
//  TweetSearch
//
//  Created by Андрей on 25.09.14.
//  Copyright (c) 2014 Андрей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

- (void)getTweetsOfHashtag:(NSString *)hashtag count:(NSInteger)count onSuccess:(void(^)(NSArray *tweets))success;

@end
