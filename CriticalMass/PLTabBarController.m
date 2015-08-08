#import "PLTabBarController.h"
#import "PLMapViewController.h"
#import "PLRulesViewController.h"
#import "PLChatViewController.h"
#import "PLTwitterViewController.h"
#import "PLSettingsTableViewController.h"
#import "UIColor+Helper.h"

@implementation PLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [UIColor magicColor];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    if ([[UITabBar appearance] respondsToSelector:@selector(setTranslucent:)]) {
        [[UITabBar appearance] setTranslucent:NO];
    }
    
    UIViewController *viewController1 = [[PLMapViewController alloc] init];
    UIViewController *viewController2 = [[PLRulesViewController alloc] init];
    UIViewController *viewController3 = [[PLChatViewController alloc] init];
    UIViewController *viewController4 = [[PLTwitterViewController alloc] init];
    UIViewController *viewController5 = [[PLSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    viewController1.title = NSLocalizedString(@"map.title", nil);
    viewController2.title = NSLocalizedString(@"rules.title", nil);
    viewController3.title = NSLocalizedString(@"chat.title", nil);
    viewController4.title = NSLocalizedString(@"twitter.title", nil);
    viewController5.title = NSLocalizedString(@"settings.title", nil);
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:viewController1];
    [tabViewControllers addObject:viewController2];
    [tabViewControllers addObject:viewController3];
    [tabViewControllers addObject:viewController4];
    [tabViewControllers addObject:viewController5];
    
    viewController1.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"map.title", nil) image:[UIImage imageNamed:@"Map"] tag:0];
    viewController2.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"rules.title", nil) image:[UIImage imageNamed:@"List"] tag:1];
    viewController3.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"chat.title", nil) image:[UIImage imageNamed:@"Bubble"] tag:2];
    viewController4.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"twitter.title", nil) image:[UIImage imageNamed:@"Twitter"] tag:3];
    viewController5.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"settings.title", nil) image:[UIImage imageNamed:@"Settings"] tag:4];
    
    [self setViewControllers:tabViewControllers animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
