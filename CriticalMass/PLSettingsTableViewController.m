//
//  PLSettingsTableViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 17.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLSettingsTableViewController.h"
#import "PLDataModel.h"
#import "PLConstants.h"
#import "UIColor+Helper.h"

@interface PLSettingsTableViewController()

@property(nonatomic,strong) PLDataModel *data;
@property(nonatomic,strong) UISwitch *gpsSwitch;
@property(nonatomic,strong) NSArray *titles;

@end

@implementation PLSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _data = [PLDataModel sharedManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGpsSwitch)
                                                     name:kNotificationGpsStateChanged object:_data];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @[
                    NSLocalizedString(@"settings.gpsSettings", nil),
                    NSLocalizedString(@"settings.socialMedia", nil),
                    NSLocalizedString(@"settings.openSource", nil),
                    NSLocalizedString(@"settings.about", nil)
                    ];
    
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationGpsStateChanged object:_data];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 2;
    }
    else if(section == 2){
        return 1;
    }
    else if(section == 3){
        return 4;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = NSLocalizedString(@"settings.enableGps", nil);
        
        _gpsSwitch = [[UISwitch alloc]init];
        _gpsSwitch.onTintColor = [UIColor magicColor];
        [_gpsSwitch addTarget:self action:@selector(onSwitchGPS:) forControlEvents:UIControlEventTouchUpInside];
        [_gpsSwitch setOn:_data.gpsEnabled];
        cell.accessoryView = _gpsSwitch;
    }
    else if (indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(@"settings.facebook", nil);
        }
        if(indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"settings.twitter", nil);
        }
    }
    else if (indexPath.section == 2){
        if(indexPath.row == 0){
            cell.textLabel.text = @"www.github.com/criticalmaps";
        }
    }
    else if (indexPath.section == 3){
        if(indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(@"settings.cmBerlin", nil);
            cell.detailTextLabel.text = @"www.criticalmass-berlin.org";
        }else if(indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"settings.logoDesign", nil);
            cell.detailTextLabel.text = @"Gitti la mar";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if(indexPath.row == 2){
            cell.textLabel.text = NSLocalizedString(@"settings.programming", nil);
            cell.detailTextLabel.text = @"Norman Sander";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1){
        if(indexPath.row == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        @"https://www.facebook.com/pages/Critical-Mass-Berlin/74806304846"]];
        }
        else if(indexPath.row == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        @"https://twitter.com/criticalmaps/"]];
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        @"https://github.com/criticalmaps/"]];
        }
    }
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        @"http://www.criticalmass-berlin.org"]];
        }
        else if(indexPath.row == 2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        @"http://www.nsander.de"]];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titles[section];
}

- (void)updateGpsSwitch {
    [_gpsSwitch setOn: _data.gpsEnabled];
}

-(IBAction)onSwitchGPS:(id)sender {
    _data.gpsEnabledUser = [sender isOn];
    _data.gpsEnabledUser ? [_data enableGps] : [_data disableGps];
}

@end
