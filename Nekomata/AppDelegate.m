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

    
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _privateQueue = dispatch_queue_create("moe.ateliershiori.nekomata", DISPATCH_QUEUE_CONCURRENT);
    operationQueue = [NSOperationQueue new];
    // Load main window
    mainwindowcontroller = [MainWindow new];
    mainwindowcontroller.app = self;
    [mainwindowcontroller.window makeKeyAndOrderFront:self];
    if ([self credentialexist]){
        [self startoauthtimer];
        [oauthrefreshtimer fire];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[GeneralPref alloc] init];
        NSViewController *loginViewController = [[LoginPref alloc] initwithAppDelegate:self];
        NSViewController *suViewController = [[SoftwareUpdatesPref alloc] init];
        NSArray *controllers = @[generalViewController,loginViewController,suViewController];
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers];
    }
    return _preferencesWindowController;
}

- (IBAction)showpreferences:(id)sender {
        [self.preferencesWindowController showWindow:nil];
}
-(NSOperationQueue *)getQueue{
    return operationQueue;
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
    NSLog(@"%f",[[credential getExpiredDate] timeIntervalSinceNow]);
    if ([[credential getExpiredDate] timeIntervalSinceNow] < -10){
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(performTokenRefresh)
                                                                                  object:nil];
        // Add to queue and execute
        [operationQueue addOperation:operation];
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
@end
