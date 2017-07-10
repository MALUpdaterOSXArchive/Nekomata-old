//
//  ListStatistics.m
//  MAL Library
//
//  Created by 桐間紗路 on 2017/05/19.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import "ListStatistics.h"
#import "ratingchartview.h"
#import "Utility.h"

@interface ListStatistics ()
@property (strong) ratingchartview *ratingstats;
@property (strong) IBOutlet NSTextField *dayspentanime;
@property (strong) ratingchartview *mangastats;
@property (strong) IBOutlet NSTextField *daysspentonmanga;
@property (strong) IBOutlet NSView *mangastatsview;
@property (strong) IBOutlet NSView *animestatsview;
@property (strong) IBOutlet NSTextField *animewatchingcount;
@property (strong) IBOutlet NSTextField *animecompletedcount;
@property (strong) IBOutlet NSTextField *animeonholdcount;
@property (strong) IBOutlet NSTextField *animedroppedcount;
@property (strong) IBOutlet NSTextField *animeptwcount;
@property (strong) IBOutlet NSTextField *totaleps;
@property (strong) IBOutlet NSTextField *mangareadingcount;
@property (strong) IBOutlet NSTextField *mangacompletedcount;
@property (strong) IBOutlet NSTextField *mangaonholdcount;
@property (strong) IBOutlet NSTextField *mangadroppedcount;
@property (strong) IBOutlet NSTextField *mangaptrcount;
@property (strong) IBOutlet NSTextField *mangatotalvols;
@property (strong) IBOutlet NSTextField *mangatotalchap;

@end

@implementation ListStatistics

- (instancetype)init{
    self = [super initWithWindowNibName:@"ListStatistics"];
    _ratingstats = [ratingchartview new];
    _mangastats = [ratingchartview new];
    if (!self)
        return nil;
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [_animestatsview addSubview:_ratingstats.view];
    [_mangastatsview addSubview:_mangastats.view];
    _ratingstats.view.frame = _animestatsview.frame;
    [_ratingstats.view setFrameOrigin:NSMakePoint(0, 0)];
    _mangastats.view.frame = _mangastatsview.frame;
    [_mangastats.view setFrameOrigin:NSMakePoint(0, 0)];
}

-(void)populateValues {
    if ([Utility checkifFileExists:@"animelist.json" appendPath:@""]) {
        NSDictionary *anime = [Utility loadJSON:@"animelist.json" appendpath:@""];
        [_ratingstats populateView:anime[@"anime"]];
        [self populatestatuscounts:anime[@"anime"] type:0];
        [self populateTotalEps:anime[@"anime"]];
        _dayspentanime.stringValue = anime[@"statistics"][@"days"];
    }
    if ([Utility checkifFileExists:@"mangalist.json" appendPath:@""]) {
        NSDictionary *manga = [Utility loadJSON:@"mangalist.json" appendpath:@""];
        [_mangastats populateView:manga[@"manga"]];
        [self populatestatuscounts:manga[@"manga"] type:1];
        [self populateTotalVolandChaps:manga[@"manga"]];
        _daysspentonmanga.stringValue = manga[@"statistics"][@"days"];
    }
}

- (void)populatestatuscounts:(NSArray *)a type:(int)type{
    NSArray *filtered;
    if (type == 0) {
        NSNumber *watching;
        NSNumber *completed;
        NSNumber *onhold;
        NSNumber *dropped;
        NSNumber *plantowatch;
        for (int i = 0; i < 5; i++) {
            switch(i) {
                case 0:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"watched_status ==[cd] %@", @"watching"]];
                    watching = @(filtered.count);
                    break;
                case 1:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"watched_status ==[cd] %@", @"completed"]];
                    completed = @(filtered.count);
                    break;
                case 2:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"watched_status ==[cd] %@", @"on-hold"]];
                    onhold = @(filtered.count);
                    break;
                case 3:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"watched_status ==[cd] %@", @"dropped"]];
                    dropped = @(filtered.count);
                    break;
                case 4:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"watched_status ==[cd] %@", @"plan to watch"]];
                    plantowatch = @(filtered.count);
                    break;
            }
        }
        _animewatchingcount.stringValue = watching.stringValue;
        _animecompletedcount.stringValue = completed.stringValue;
        _animeonholdcount.stringValue = onhold.stringValue;
        _animedroppedcount.stringValue = dropped.stringValue;
        _animeptwcount.stringValue = plantowatch.stringValue;
    }
    else {
        NSNumber *reading;
        NSNumber *completed;
        NSNumber *onhold;
        NSNumber *dropped;
        NSNumber *plantoread;
        for (int i = 0; i < 5; i++) {
            switch(i) {
                case 0:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"read_status ==[cd] %@", @"reading"]];
                    reading = @(filtered.count);
                    break;
                case 1:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"read_status ==[cd] %@", @"completed"]];
                    completed = @(filtered.count);
                    break;
                case 2:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"read_status ==[cd] %@", @"on-hold"]];
                    onhold = @(filtered.count);
                    break;
                case 3:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"read_status ==[cd] %@", @"dropped"]];
                    dropped = @(filtered.count);
                    break;
                case 4:
                    filtered = [a filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"read_status ==[cd] %@", @"plan to read"]];
                    plantoread = @(filtered.count);
                    break;
            }
        }
        _mangareadingcount.stringValue = reading.stringValue;
        _mangacompletedcount.stringValue = completed.stringValue;
        _mangaonholdcount.stringValue = onhold.stringValue;
        _mangadroppedcount.stringValue = dropped.stringValue;
        _mangaptrcount.stringValue = plantoread.stringValue;
    }
}
- (void)populateTotalEps:(NSArray *)a {
    int totaleps = 0;
    for (NSDictionary *d in a) {
        totaleps = totaleps + ((NSNumber *)d[@"watched_episodes"]).intValue;
    }
    _totaleps.stringValue = @(totaleps).stringValue;
}

- (void)populateTotalVolandChaps:(NSArray *)a {
    int totalchap = 0;
    int totalvol = 0;
    for (NSDictionary *d in a) {
        totalchap = totalchap + ((NSNumber *)d[@"chapters_read"]).intValue;
        totalvol = totalvol + ((NSNumber *)d[@"volumes_read"]).intValue;
    }
    _mangatotalchap.stringValue = @(totalchap).stringValue;
    _mangatotalvols.stringValue = @(totalvol).stringValue;
}
@end
