//
//  AppDelegate.h
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "ChatDelegate.h"
#import "MessageDelegate.h"

@class BuddyListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSString *chatServer;
    UIWindow *window;
    BuddyListViewController *viewController;

    XMPPStream *xmppStream;
    NSString *password;
    BOOL isOpen;
    
    __unsafe_unretained NSObject <ChatDelegate> *_chatDelegate;
    __unsafe_unretained NSObject <MessageDelegate> *_messageDelegate;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet BuddyListViewController *viewController;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, assign) id _chatDelegate;
@property (nonatomic, assign) id _messageDelegate;

-(BOOL)connect;
-(void)disconnect;

@end
