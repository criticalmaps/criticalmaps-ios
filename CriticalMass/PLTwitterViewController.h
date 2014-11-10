//
//  PLTwitterViewController.h
//  CriticalMass
//
//  Created by Norman Sander on 09.11.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLTwitterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_statuses;
}

@end