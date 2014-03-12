//
//  LoginViewController.h
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    UITextField *loginField;
    UITextField *passwordField;
}

@property (nonatomic,retain) IBOutlet UITextField *loginField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;

- (IBAction)login;
- (IBAction)hideLogin;
@end
