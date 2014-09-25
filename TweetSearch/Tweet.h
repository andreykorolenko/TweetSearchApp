//
//  Tweet.h
//  TweetSearch
//
//  Created by Андрей on 25.09.14.
//  Copyright (c) 2014 Андрей. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * countFriends;
@property (nonatomic, retain) NSString * createdDate;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * userName;

@end
