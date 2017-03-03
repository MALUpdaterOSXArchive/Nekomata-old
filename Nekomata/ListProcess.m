//
//  ListProcess.m
//  Nekomata
//
//  Created by 桐間紗路 on 2017/03/02.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import "ListProcess.h"

@implementation ListProcess
+(id)processAnimeList:(id)data{
    // Converts Anime List to a more usable format for a flat JSON file
    NSDictionary * d = data;
    NSDictionary * lists = d[@"lists"];
    NSMutableDictionary * final = [NSMutableDictionary new];
    NSMutableDictionary * statuscount = [NSMutableDictionary new];
    NSMutableArray * fulllist = [NSMutableArray new];
    for (int i=0; i<5; i++){
        NSArray * list;
        switch (i){
            case 0:
                list = lists[@"watching"];
                [statuscount setObject:[NSNumber numberWithLong:[list count]] forKey:@"watching"];
                break;
            case 1:
                list = lists[@"on_hold"];
                [statuscount setObject:[NSNumber numberWithLong:[list count]] forKey:@"on_hold"];
                break;
            case 2:
                list = lists[@"completed"];
                [statuscount setObject:[NSNumber numberWithLong:[list count]] forKey:@"completed"];
                break;
            case 3:
                list = lists[@"plan_to_watch"];
                [statuscount setObject:[NSNumber numberWithLong:[list count]] forKey:@"plan_to_watch"];
                break;
            case 4:
                list = lists[@"dropped"];
                [statuscount setObject:[NSNumber numberWithLong:[list count]] forKey:@"dropped"];
                break;
        }
        for(NSDictionary * item in list){
            NSDictionary * details = item[@"anime"];
            NSMutableDictionary * newitem = [NSMutableDictionary new];
            [newitem setObject:item[@"series_id"] forKey:@"id"];
            [newitem setObject:item[@"record_id"] forKey:@"record_id"];
            [newitem setObject:item[@"rewatched"] forKey:@"rewatched"];
            [newitem setObject:item[@"score"] forKey:@"score"];
            [newitem setObject:item[@"score_raw"] forKey:@"score_raw"];
            [newitem setObject:item[@"priority"] forKey:@"priority"];
            [newitem setObject:item[@"hidden_default"] forKey:@"hidden_default"];
            [newitem setObject:item[@"added_time"] forKey:@"added_time"];
            [newitem setObject:item[@"episodes_watched"] forKey:@"watched_episodes"];
            [newitem setObject:item[@"started_on"] forKey:@"started_on"];
            [newitem setObject:item[@"list_status"] forKey:@"watched_status"];
            [newitem setObject:details[@"title_romaji"] forKey:@"title_romaji"];
            [newitem setObject:details[@"title_english"] forKey:@"title_english"];
            [newitem setObject:details[@"type"] forKey:@"type"];
            [newitem setObject:details[@"total_episodes"] forKey:@"episodes"];
            [newitem setObject:details[@"airing_status"] forKey:@"status"];
            [newitem setObject:item[@"custom_lists"] forKey:@"custom_lists"];
            [fulllist addObject:newitem];
        }
    }
    [final setObject:fulllist forKey:@"list"];
    [final setObject:statuscount forKey:@"status_count"];
    return final;
}
@end
