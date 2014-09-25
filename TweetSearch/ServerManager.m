//
//  ServerManager.m
//  TweetSearch
//
//  Created by Андрей on 25.09.14.
//  Copyright (c) 2014 Андрей. All rights reserved.
//

#import "ServerManager.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "Tweet.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation ServerManager

+ (ServerManager *)sharedManager {
    
    static ServerManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestOperationManager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

- (void)getTweetsOfHashtag:(NSString *)hashtag count:(NSInteger)count onSuccess:(void(^)(NSArray *tweets))success {
    
    // берем managedObjectContext
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    // корректируем хештег
    hashtag = [hashtag stringByReplacingOccurrencesOfString:@" " withString:@""];
    hashtag = [hashtag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // если запрос пуст
    if ([hashtag isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Уведомление" message:@"Вы не ввели слово для поиска" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    // включаем индикатор загрузки
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // создаем строку для запроса
    NSString *requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%%23%@&result_type=recent&count=%ld&lang=ru", hashtag, (long)count];
    
    // устанавливаем демо-токен
    [self.requestOperationManager.requestSerializer setValue:@"Bearer AAAAAAAAAAAAAAAAAAAAADiJRQAAAAAAt%2Brjl%2Bqmz0rcy%2BBbuXBBsrUHGEg%3Dq0EK2aWqQMb15gCZNwZo9yqae0hpe2FDsS92WAu0g" forHTTPHeaderField:@"Authorization"];
    
    [self.requestOperationManager GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = responseObject[@"statuses"];
        
        // если твитов не найдено
        if ([array count] == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Уведомление" message:@"Не найдено твитов" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        
        // если твиты найдены
        else {
            // очищаем core data от старых твитов
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Tweet"
                                                           inManagedObjectContext:context];
            [request setEntity:description];
            NSArray *resultArray = [context executeFetchRequest:request error:nil];
            
            // если есть твиты в core data
            if ([resultArray count]) {
                for (Tweet *tweet in resultArray) {
                    [context deleteObject:tweet];
                }
                [context save:nil];
            }

            NSMutableArray *tweetsArray = [NSMutableArray array];
            
            for (NSDictionary *dict in array) {
                
                // создаем твит
                Tweet *tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet"
                                                             inManagedObjectContext:context];
                tweet.createdDate = dict[@"created_at"];
                tweet.text = dict[@"text"];
                
                NSDictionary *user = dict[@"user"];
                tweet.profileImageURL = user[@"profile_image_url_https"];
                tweet.userName = user[@"name"];
                
                NSNumber *count = user[@"friends_count"];
                tweet.countFriends = [count stringValue];
                
                // сохранаем и если есть ошибка, выводим ее
                NSError *error = nil;
                [context save:&error];
                
                if (error) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                // добавляем в массив твитов
                [tweetsArray addObject:tweet];
            }
            
            // выполняем блок и передаем массив твитов
            if (success) {
                success(tweetsArray);
            }
        }
        
        // выключаем индикатор загрузки
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail %@", [error localizedDescription]);
    }];
}

@end
