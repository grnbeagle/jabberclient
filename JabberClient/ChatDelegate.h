//
//  ChatDelegate.h
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import <Foundation/Foundation.h>

@protocol ChatDelegate <NSObject>
- (void)newBuddyOnline:(NSString *)buddyName;
- (void)buddyWentOffline:(NSString *)buddyName;
- (void)didDisconnect;
@end
