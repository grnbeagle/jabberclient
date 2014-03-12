//
//  ChatViewController.m
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import "ChatViewController.h"
#import "XMPP.h"


@implementation ChatViewController

@synthesize messageField, chatWithUser, tView;

- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

- (id) initWithUser:(NSString *) userName {
	if (self = [super init]) {
		chatWithUser = userName;
		turnSockets = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tView.delegate = self;
    self.tView.dataSource = self;
	[self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
	messages = [[NSMutableArray alloc ] init];
    
	AppDelegate *del = [self appDelegate];
	del._messageDelegate = self;
	[self.messageField becomeFirstResponder];
    
    NSLog(@"Talking to: %@", chatWithUser);
	XMPPJID *jid = [XMPPJID jidWithString:chatWithUser];
    
	TURNSocket *tsocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
    
	[turnSockets addObject:tsocket];
    
	[tsocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
	NSLog(@"TURN Connection succeeded!");
	NSLog(@"You now have a socket that you can use to send/receive data to/from the other person.");
    
	[turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender {
	NSLog(@"TURN Connection failed!");
	[turnSockets removeObject:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeChat {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMessage {
    NSString *messageStr = self.messageField.text;
    if ([messageStr length] > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        [message addChild:body];
        
        [self.xmppStream sendElement:message];
        self.messageField.text = @"";
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:messageStr forKey:@"msg"];
		[m setObject:@"you" forKey:@"sender"];

        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh-mm"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        
		[m setObject:resultString forKey:@"time"];
        
		[messages addObject:m];
		[self.tView reloadData];
    }
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [self.tView scrollToRowAtIndexPath:topIndexPath
        atScrollPosition:UITableViewScrollPositionMiddle
        animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"MessageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    if (s) {
        cell.textLabel.text = [s objectForKey:@"msg"];
        cell.detailTextLabel.text = [s objectForKey:@"sender"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)newMessageReceived:(NSDictionary *)messageContent {
	[messages addObject:messageContent];
	[self.tView reloadData];
    
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    
	[self.tView scrollToRowAtIndexPath:topIndexPath
        atScrollPosition:UITableViewScrollPositionMiddle
        animated:YES];
}

@end
