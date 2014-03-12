//
//  AppDelegate.m
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import "AppDelegate.h"
#import "BuddyListViewController.h"

@interface AppDelegate()
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
@end

@implementation AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize xmppStream;
@synthesize _chatDelegate, _messageDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    chatServer = @"amie-macbook.local";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.viewController = [[BuddyListViewController alloc] init];
    self.window.rootViewController = self.viewController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self connect];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self disconnect];
}

- (void)setupStream {
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (BOOL)connect {

	[self setupStream];
    
	NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];
    
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	if (jabberID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
		UIAlertView *alertView = [[UIAlertView alloc]
        initWithTitle:@"Error"
        message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
            delegate:nil
            cancelButtonTitle:@"Ok"
            otherButtonTitles:nil];
		[alertView show];
		return NO;
	}
    
	return YES;
}

-  (void)disconnect {
    [self goOffline];
    [xmppStream disconnect];
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
	isOpen = YES;
	NSError *error = nil;
	[[self xmppStream] authenticateWithPassword:password error:&error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    NSLog(@"presenceFromUser: %@; status: %@", presenceFromUser, presenceType);
    if (![presenceFromUser isEqualToString:myUsername]) {
        if ([presenceType isEqualToString:@"available"]) {
            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, chatServer]];
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, chatServer]];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	NSString *msg = [[message elementForName:@"body"] stringValue];
	NSString *from = [[message attributeForName:@"from"] stringValue];
    NSLog(@"message: %@ from (%@)", msg, from);

	NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    if (msg) {
        [m setObject:msg forKey:@"msg"];
        [m setObject:from forKey:@"sender"];
        
        [_messageDelegate newMessageReceived:m];
    }
}
@end
