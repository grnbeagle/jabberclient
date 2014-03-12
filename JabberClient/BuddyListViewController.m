//
//  BuddyListViewController.m
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import "BuddyListViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"

@implementation BuddyListViewController

@synthesize tView;

- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    onlineBuddies = [[NSMutableArray alloc] init];
    AppDelegate *del = [self appDelegate];
    del._chatDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (login) {
        if ([[self appDelegate] connect]) {
            NSLog(@"connected");
        }
    } else {
        [self showLogin];
    }
}
- (void) showLogin {
    LoginViewController *loginController = [[LoginViewController alloc] init];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *s = (NSString *) [onlineBuddies objectAtIndex:indexPath.row];
    
	static NSString *CellIdentifier = @"UserCellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
	cell.textLabel.text = s;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [onlineBuddies count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *userName = (NSString *) [onlineBuddies objectAtIndex:indexPath.row];
	ChatViewController *chatController = [[ChatViewController alloc] initWithUser:userName];
    [self presentViewController:chatController animated:YES completion:nil];
}

- (void)newBuddyOnline:(NSString *)buddyName {
	if (![onlineBuddies containsObject:buddyName]) {
		[onlineBuddies addObject:buddyName];
		[self.tView reloadData];
	}
}

- (void)buddyWentOffline:(NSString *)buddyName {
	[onlineBuddies removeObject:buddyName];
	[self.tView reloadData];
}

- (void)didDisconnect {
	[onlineBuddies removeAllObjects];
	[self.tView reloadData];
    
}
@end
