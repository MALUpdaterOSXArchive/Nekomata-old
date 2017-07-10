//
//  MyAnimeList.m
//  MAL Library
//
//  Created by 天々座理世 on 2017/04/11.
//  Copyright © 2017年 Atelier Shiori. All rights reserved. Licensed under 3-clause BSD License
//

#import "MyAnimeList.h"
#import "Keychain.h"
#import <AFNetworking/AFNetworking.h>
#import "Utility.h"
#import "Base64Category.h"

@implementation MyAnimeList
#pragma mark MyAnimeList Functions
#pragma Mark List, History and Serach
+ (void)retrieveList:(NSString *)username listType:(int)type completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    NSString * URL = @"";
    if (type == MALAnime) {
        URL = [NSString stringWithFormat:@"%@/2.1/animelist/%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], username];
    }
    else if (type == MALManga) {
        URL = [NSString stringWithFormat:@"%@/2.1/mangalist/%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], username];
    }
    
    [manager GET:URL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];

}

+ (void)retrieveAiringSchedule:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    
    [manager GET:[NSString stringWithFormat:@"%@/2.1/anime/schedule",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

+ (void)searchTitle:(NSString *)searchterm withType:(int)type completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    if ([Keychain checkaccount]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    }
    NSString *url = @"";
    if (type == MALAnime) {
        url = [NSString stringWithFormat:@"%@/2.1/anime/search?q=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"],[Utility urlEncodeString:searchterm]];
    }
    else if (type == MALManga) {
        url = [NSString stringWithFormat:@"%@/2.1/manga/search?q=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"],[Utility urlEncodeString:searchterm]];
    }
    else {
        return;
    }
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
    
}

+ (void)advsearchTitle:(NSString *)searchterm withType:(int)type withGenres:(NSString *)genres excludeGenres:(bool)exclude startDate:(NSDate *)startDate endDate:(NSDate *)endDate minScore:(int)minscore rating:(int)rating withStatus:(int)status completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setValue:searchterm forKey:@"keyword"];
    [d setValue:@(minscore) forKey:@"score"];
    [d setValue:@(exclude) forKey:@"genre_type"];
    [d setValue:genres forKey:@"genres"];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    dateformat.dateFormat = @"YYYY-MM-DD";
    if (startDate) {
        [d setValue:startDate forKey:@"start_date"];
    }
    if (endDate) {
        [d setValue:endDate forKey:@"end_date"];
    }
    [d setValue:@(status) forKey:@"status"];
    [d setValue:@(rating) forKey:@"rating"];
    
    AFHTTPSessionManager *manager = [Utility manager];
    NSString *URL;
    if (type == MALAnime) {
        URL = [NSString stringWithFormat:@"%@/2.1/anime/browse",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]];
    }
    else if (type == MALManga) {
        URL = [NSString stringWithFormat:@"%@/2.1/manga/browse",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]];
    }
    else {
        return;
    }
    [manager GET:URL parameters:d progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

+ (void)retrieveTitleInfo:(int)titleid withType:(int)type useAccount:(bool)useAccount completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    NSString *url = @"";
    if (type == MALAnime) {
        url = [NSString stringWithFormat:@"%@/2.1/anime/%i",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"],titleid];
        
    }
    else if (type == MALManga) {
        url = [NSString stringWithFormat:@"%@/2.1/manga/%i",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"],titleid];
    }
    else {
        return;
    }
    if (useAccount) {
        url = [NSString stringWithFormat:@"%@?mine=1",url];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    }
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}
+ (void)retrieveReviewsForTitle:(int)titleid withType:(int)type completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    NSString *url = @"";
    if (type == MALAnime) {
        url = [NSString stringWithFormat:@"%@/2.1/anime/reviews/%i",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"],titleid];
        
    }
    else if (type == MALManga) {
        url = [NSString stringWithFormat:@"%@/2.1/manga/reviews/%i",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"],titleid];
    }
    else {
        return;
    }
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];

}

+ (void)retriveUpdateHistory:(NSString *)username completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    
    [manager GET:[NSString stringWithFormat:@"%@/2.1/history/%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], username] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler([MyAnimeList processHistory:responseObject]);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

#pragma mark Account

+ (void)verifyAccountWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [[NSString stringWithFormat:@"%@:%@", username, password] base64Encoding]] forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@/1/account/verify_credentials",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

#pragma mark List Management

+ (void)addAnimeTitleToList:(int)titleid withEpisode:(int)episode withStatus:(NSString *)status withScore:(int)score completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [Utility httpresponseserializer];
    [manager POST:[NSString stringWithFormat:@"%@/2.1/animelist/anime", [[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]] parameters:@{@"anime_id":@(titleid), @"status":status, @"score":@(score), @"episodes":@(episode)} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];

}

+ (void)addMangaTitleToList:(int)titleid withChapter:(int)chapter withVolume:(int)volume withStatus:(NSString *)status withScore:(int)score completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [Utility httpresponseserializer];
    [manager POST:[NSString stringWithFormat:@"%@/2.1/mangalist/manga", [[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]] parameters:@{@"manga_id":@(titleid), @"status":status, @"score":@(score), @"chapters":@(chapter), @"volumes":@(volume)} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

+ (void)updateAnimeTitleOnList:(int)titleid withEpisode:(int)episode withStatus:(NSString *)status withScore:(int)score completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [Utility httpresponseserializer];
    [manager PUT:[NSString stringWithFormat:@"%@/2.1/animelist/anime/%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], @(titleid)] parameters:@{ @"status":status, @"score":@(score), @"episodes":@(episode)} success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        completionHandler(error);
    }];
}

+ (void)updateMangaTitleOnList:(int)titleid withChapter:(int)chapter withVolume:(int)volume withStatus:(NSString *)status withScore:(int)score completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [Utility httpresponseserializer];
    [manager PUT:[NSString stringWithFormat:@"%@/2.1/mangalist/manga/%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], @(titleid)] parameters:@{ @"status":status, @"score":@(score), @"chapters":@(chapter),@"volumes":@(volume)} success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

+ (void)removeTitleFromList:(int)titleid withType:(int)type completion:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler{
    NSString *deleteURL;
    if (type == MALAnime) {
        deleteURL = [NSString stringWithFormat:@"%@/2.1/animelist/anime/%i",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], titleid];
    }
    else if (type == MALManga) {
        deleteURL = [NSString stringWithFormat:@"%@/2.1/mangalist/manga/%i", [[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], titleid];
    }
    else {
        return;
    }
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    [manager DELETE:deleteURL parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

#pragma mark Messages

+ (void)retrievemessagelist:(int)page completionHandler:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler {
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@/2.1/messages",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]] parameters:@{@"page":@(page)} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

+ (void)retrievemessage:(int)messageid completionHandler:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler {
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    [manager GET:[NSString stringWithFormat:@"%@/2.1/messages/%i",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], messageid] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

+ (void)sendmessage:(NSString *)username withSubject:(NSString *)subject withMessage:(NSString *)message withthreadID:(int)threadid completionHandler:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler {
    AFHTTPSessionManager *manager = [Utility manager];
    NSDictionary *pram;
    if (threadid == 0) {
        pram = @{@"username":username, @"subject":subject, @"message":message};
    }
    else {
        pram = @{@"username":username, @"subject":subject, @"message":message, @"id":@(threadid)};
    }
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    [manager POST:[NSString stringWithFormat:@"%@/2.1/messages",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"]] parameters:pram progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}

+ (void)deletemessage:(int)messageid completionHandler:(void (^)(id responseObject)) completionHandler error:(void (^)(NSError * error)) errorHandler {
    AFHTTPSessionManager *manager = [Utility manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[Keychain getBase64]] forHTTPHeaderField:@"Authorization"];
    [manager DELETE:[NSString stringWithFormat:@"%@/2.1/messages/%i",[[NSUserDefaults standardUserDefaults] valueForKey:@"malapiurl"], messageid] parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        errorHandler(error);
    }];
}


#pragma mark -
#pragma mark Private Methods
+ (id)processHistory:(id)object{
    NSArray *a = object;
    NSMutableArray *history = [NSMutableArray new];
    for (NSDictionary *d in a) {
        NSDictionary *item = d[@"item"];
        NSNumber *idnum = item[@"id"];
        NSString *title = item[@"title"];
        NSString *type = d[@"type"];
        NSNumber *segment;
        NSString *segment_type = @"";
        if (item[@"watched_episodes"]) {
            segment = item[@"watched_episodes"];
            segment_type = @"Episode";
        }
        else {
            segment = item[@"chapters_read"];
            segment_type = @"Chapter";
        }
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSDate *datetime;
        if (d[@"time_updated"]) {
            NSString *strdate = d[@"time_updated"];
            strdate = [strdate substringWithRange:NSMakeRange(0, 10)];
            datetime = [dateFormatter dateFromString:strdate];
        }
        else {
            datetime = [NSDate date]; // Just updated, set now date.
        }
        [dateFormatter setDateFormat:nil];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *lastupdated = [NSDateFormatter localizedStringFromDate:datetime
                                                               dateStyle: NSDateFormatterShortStyle
                                                               timeStyle: NSDateFormatterNoStyle];
        [history addObject:@{@"id":idnum, @"title":title, @"type":type, @"last_updated":lastupdated, @"segment":segment, @"segment_type":segment_type}];
    }
    return history;
}
@end
