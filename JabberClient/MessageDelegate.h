//
//  MessageDelegate.h
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import <Foundation/Foundation.h>

@protocol MessageDelegate <NSObject>

-(void)newMessageReceived:(NSDictionary *)messageContent;

@end
