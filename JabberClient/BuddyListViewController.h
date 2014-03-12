//
//  BuddyListViewController.h
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BuddyListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ChatDelegate> {

    UITableView *tView;
    NSMutableArray *onlineBuddies;
}

@property (nonatomic,retain) IBOutlet UITableView *tView;

- (IBAction)showLogin;

@end
