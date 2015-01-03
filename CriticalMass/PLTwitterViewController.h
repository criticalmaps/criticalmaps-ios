//
//  PLTwitterViewController.h
//  CriticalMass
//
//  Created by Norman Sander on 09.11.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTWitter.h"
#import "SAMLoadingView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PLTwitterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    STTwitterAPI *_twitter;
    UITableView *_tableView;
    NSArray *_statuses;
    SAMLoadingView *_loadingView;
}

@end