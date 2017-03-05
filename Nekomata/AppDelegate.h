//
//  AppDelegate.h
//  Nekomata
//
//  Created by 桐間紗路 on 2017/02/28.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindow.h"
#import "MSWeakTimer.h"
#import "MainWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    MainWindow * mainwindowcontroller;
    NSWindowController *_preferencesWindowController;
}
// Preference Window
@property (nonatomic, readonly) NSWindowController *preferencesWindowController;
-(MainWindow *)getMainWindowController;
- (IBAction)showpreferences:(id)sender;
-(void)showloginpref;
@end

