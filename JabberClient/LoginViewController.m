//
//  LoginViewController.m
//  JabberClient
//
//  Created by Amie Kweon on 3/9/14.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize loginField, passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login {
    [[NSUserDefaults standardUserDefaults] setObject:self.loginField.text forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordField.text forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideLogin {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
