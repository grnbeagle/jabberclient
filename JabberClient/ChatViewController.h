//
//  ChatViewController.h
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TURNSocket.h"

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MessageDelegate> {
    UITextField *messageField;
    NSString *chatWithUser;
    UITableView *tView;
    NSMutableArray *messages;
    NSMutableArray *turnSockets;
}

@property (nonatomic,retain) IBOutlet UITextField *messageField;
@property (nonatomic,retain) NSString *chatWithUser;
@property (nonatomic,retain) IBOutlet UITableView *tView;

-(id) initWithUser:(NSString *) userName;
-(IBAction)sendMessage;
-(IBAction)closeChat;

@end
