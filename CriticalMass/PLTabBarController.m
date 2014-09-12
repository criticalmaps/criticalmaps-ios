#import "PLTabBarController.h"
#import "PLMapViewController.h"
#import "PLRulesViewController.h"


@interface PLTabBarController ()

@end

@implementation PLTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *viewController1 = [[PLMapViewController alloc] init];
    UIViewController *viewController2 = [[PLRulesViewController alloc] init];
    UIViewController *viewController3 = [[UIViewController alloc] init ];
    UIViewController *viewController4 = [[UIViewController alloc] init ];
    
    viewController1.title = @"Karte";
    viewController2.title = @"Rules";
    viewController3.title = @"Social";
    viewController4.title = @"About";
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:viewController1];
    [tabViewControllers addObject:viewController2];
    [tabViewControllers addObject:viewController3];
    [tabViewControllers addObject:viewController4];
    
    viewController1.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Map" image:nil tag:1];
    viewController2.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Rules" image:nil tag:2];
    viewController3.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Social" image:nil tag:3];
    viewController4.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"About" image:nil tag:4];
    
    /*
     viewController1.tabBarItem =
     [[UITabBarItem alloc] initWithTitle:@"Map"
     image:[UIImage imageNamed:@"Map"]
     tag:1];
     viewController2.tabBarItem =
     [[UITabBarItem alloc] initWithTitle:@"Rules"
     image:[UIImage imageNamed:@"Map"]
     tag:2];
     viewController3.tabBarItem =
     [[UITabBarItem alloc] initWithTitle:@"Social"
     image:[UIImage imageNamed:@"Map"]
     tag:3];
     viewController4.tabBarItem =
     [[UITabBarItem alloc] initWithTitle:@"About"
     image:[UIImage imageNamed:@"Map"]
     tag:4];
     */
    
    
    [self setViewControllers:tabViewControllers animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
