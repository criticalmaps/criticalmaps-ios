#import "PLTabBarController.h"
#import "PLChatViewController.h"
#import "PLTwitterViewController.h"
#import "PLSettingsTableViewController.h"
#import "CriticalMaps-Swift.h"
#import "UIColor+Helper.h"

@implementation PLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [UIColor magicColor];
    
    if ([[UITabBar appearance] respondsToSelector:@selector(setTranslucent:)]) {
        [[UITabBar appearance] setTranslucent:YES];
    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController1 = [[UINavigationController alloc]initWithRootViewController:[[MapViewController alloc] init]];
    UIViewController *viewController2 = [[UINavigationController alloc]initWithRootViewController:[[RulesViewController alloc] init]];
    UIViewController *viewController3 = [[UINavigationController alloc]initWithRootViewController:[ChatViewController new]];;
    UIViewController *viewController4 = [[UINavigationController alloc]initWithRootViewController:[[PLTwitterViewController alloc] init]];
    UIViewController *viewController5 = [[UINavigationController alloc] initWithRootViewController:[[PLSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    
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
    
    viewController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"map.title", nil) image:[UIImage imageNamed:@"Map"] selectedImage:[UIImage imageNamed:@"Map_Active"]];
    viewController1.tabBarItem.tag = 0;
    viewController2.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"rules.title", nil) image:[UIImage imageNamed:@"List"] selectedImage:[UIImage imageNamed:@"List_Active"]];
    viewController2.tabBarItem.tag = 1;
    viewController3.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"chat.title", nil) image:[UIImage imageNamed:@"Bubble"] selectedImage:[UIImage imageNamed:@"Bubble_Active"]];
    viewController3.tabBarItem.tag = 2;
    viewController4.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"twitter.title", nil) image:[UIImage imageNamed:@"Twitter"] selectedImage:[UIImage imageNamed:@"Twitter_Active"]];
    viewController4.tabBarItem.tag = 3;
    viewController5.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"settings.title", nil) image:[UIImage imageNamed:@"Settings"] selectedImage:[UIImage imageNamed:@"Settings_Active"]];
    viewController5.tabBarItem.tag = 4;
    
    [self setViewControllers:tabViewControllers animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
