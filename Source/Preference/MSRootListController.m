#include "MSRootListController.h"

@implementation MSRootListController
@synthesize respringButton;

- (instancetype)init {
    self = [super init];

    if (self) {
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" 
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(respring:)];
        self.navigationItem.rightBarButtonItem = self.respringButton;

    }

    return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/MySiri.bundle/ms.png"];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)respring:(id)sender {
    UIViewController *view = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (view.presentedViewController != nil && !view.presentedViewController.isBeingDismissed) {
                view = view.presentedViewController;
        }
    UIAlertController *alertController = 
    [UIAlertController alertControllerWithTitle:@"Confirmation" 
                                message:@"Do you want to respring?" 
                                preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" 
                                style:UIAlertActionStyleDefault 
                                handler:^(UIAlertAction *action) {

            NSTask *t = [[NSTask alloc] init];
            [t setLaunchPath:@"/usr/bin/killall"];
            [t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
            [t launch];    

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" 
                                     style:UIAlertActionStyleDefault 
                                handler:^(UIAlertAction *action) {
        //??                                                     
    }]];
    [view presentViewController:alertController animated:YES completion:nil];
}


- (void)myInfo {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Minazuki's Info" 
        message:@"Twitter\n Discord\n Donate" 
        preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction 
        actionWithTitle:@"Twitter"
        style:UIAlertActionStyleDefault 
        handler:^(UIAlertAction *action) {
            	UIApplication *app = [UIApplication sharedApplication];
	if ([app canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=Minazuki_dev"]]) {
		[app openURL:[NSURL URLWithString:@"twitter://user?screen_name=Minazuki_dev"]];
	} else if ([app canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/Minazuki_dev"]]) {
		[app openURL:[NSURL URLWithString:@"tweetbot:///user_profile/Minazuki_dev"]];		
	} else {
		[app openURL:[NSURL URLWithString:@"https://mobile.twitter.com/Minazuki_dev"]];
        }
                }]];

    [alert addAction:[UIAlertAction 
        actionWithTitle:@"Discord"
        style:UIAlertActionStyleDefault 
        handler:^(UIAlertAction *action) {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://discord.gg/dEYpUwv"]];

                }]];

    [alert addAction:[UIAlertAction 
        actionWithTitle:@"Donate"
        style:UIAlertActionStyleDefault 
        handler:^(UIAlertAction *action) {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://donorbox.org/donate-for-minazuki"]];

                }]];

    [alert addAction:[UIAlertAction 
        actionWithTitle:@"Cancel"
        style:UIAlertActionStyleCancel 
        handler:^(UIAlertAction *action) {
            //キャンセル
                }]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
