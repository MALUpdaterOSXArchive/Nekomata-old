//
//  AppDelegate.m
//  Nekomata
//
//  Created by 桐間紗路 on 2017/02/28.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import "AppDelegate.h"
#import "Preferences.h"
#import "ClientConstants.h"

@interface AppDelegate ()
@property (strong, nonatomic) dispatch_queue_t privateQueue;
@end

@implementation AppDelegate
+(void)initialize{
    
    //Create a Dictionary
    NSMutableDictionary * defaultValues = [NSMutableDictionary dictionary];
    
    // Defaults
    defaultValues[@"watchingfilter"] = @(1);
    defaultValues[@"listdoubleclickaction"] = @"Modify Title";
    defaultValues[@"refreshonstart"] = @(0);
    defaultValues[@"appearence"] = @"Light";
    
    //Register Dictionary
    [[NSUserDefaults standardUserDefaults]
     registerDefaults:defaultValues];

    
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _privateQueue = dispatch_queue_create("moe.ateliershiori.nekomata", DISPATCH_QUEUE_CONCURRENT);
    // Load main window
    mainwindowcontroller = [MainWindow new];
    [mainwindowcontroller setDelegate:self];
    [mainwindowcontroller.window makeKeyAndOrderFront:self];
    if ([self credentialexist]){
        [self startoauthtimer];
        [oauthrefreshtimer fire];
    }
    [self showloginnotice];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(MainWindow *)getMainWindowController{
    return mainwindowcontroller;
}
- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        GeneralPref * genview =[[GeneralPref alloc] init];
        [genview setMainWindowController:mainwindowcontroller];
        NSViewController *loginViewController = [[LoginPref alloc] initwithAppDelegate:self];
        NSViewController *suViewController = [[SoftwareUpdatesPref alloc] init];
        NSArray *controllers = @[genview,loginViewController,suViewController];
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers];
    }
    return _preferencesWindowController;
}

- (IBAction)showpreferences:(id)sender {
        [self.preferencesWindowController showWindow:nil];
}
-(void)startoauthtimer{
    oauthrefreshtimer = [MSWeakTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(timerfire) userInfo:nil repeats:YES dispatchQueue:self.privateQueue];
}
-(void)stoptimer{
    [oauthrefreshtimer invalidate];
}
-(void)timerfire{
    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"Nekomata"];
    if ([[credential getExpiredDate] timeIntervalSinceNow] < -10){
        [self performTokenRefresh];
    }
}
-(void)performTokenRefresh{
    AFOAuthCredential *cred =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"Nekomata"];
    NSURL *baseURL = [NSURL URLWithString:@"https://anilist.co/api/"];
    AFOAuth2Manager *OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
                                    clientID:kclient
                                      secret:ksecretkey];
    [OAuth2Manager setUseHTTPBasicAuthentication:NO];
     [OAuth2Manager authenticateUsingOAuthWithURLString:@"auth/access_token" parameters:@{@"grant_type":@"refresh_token", @"refresh_token":cred.refreshToken} success:^(AFOAuthCredential *credential) {
        NSLog(@"Token refreshed");
         [AFOAuthCredential storeCredential:credential
                             withIdentifier:@"Nekomata"];
    }
   failure:^(NSError *error) {
       NSLog(@"Token cannot be refreshed: %@", error);
   }];

}
-(bool)credentialexist{
    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"Nekomata"];
    if (credential.accessToken) {
        return true;
    }
    return false;
}
-(void)showloginnotice{
    if (![self credentialexist]) {
        // First time prompt
        NSAlert * alert = [[NSAlert alloc] init] ;
        [alert addButtonWithTitle:NSLocalizedString(@"Yes",nil)];
        [alert addButtonWithTitle:NSLocalizedString(@"No",nil)];
        [alert setMessageText:NSLocalizedString(@"Welcome to Nekomata",nil)];
        [alert setInformativeText:NSLocalizedString(@"Before you can use this program, you need to add an account. Do you want to open Preferences to authenticate an account now? \r\rNote that you won't be able to use any of the functionality until you authenticate.",nil)];
        // Set Message type to Warning
        alert.alertStyle = NSAlertStyleInformational;
        [alert beginSheetModalForWindow:mainwindowcontroller.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode== NSAlertFirstButtonReturn) {
            // Show Preference Window and go to Login Preference Pane
            [self showloginpref];
        }
            }];
    }

}
-(void)showloginpref{
    [self.preferencesWindowController showWindow:nil];
    [(MASPreferencesWindowController *)self.preferencesWindowController selectControllerAtIndex:1];
}
@end
