//
//  PLSettingsTableViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 17.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLSettingsTableViewController.h"
#import "PLData.h"
#import "PLConstants.h"

@interface PLSettingsTableViewController ()

@end

@implementation PLSettingsTableViewController{
    PLData *_data;
    UISwitch *_gpsSwitch;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _data = [PLData sharedManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGpsSwitch) name:kNotificationGpsStateChanged object:_data];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationGpsStateChanged object:_data];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 4;
    }else if(section == 3){
        return 2;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    if(indexPath.section == 0 && indexPath.row == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Enable GPS";
        
        _gpsSwitch = [[UISwitch alloc]init];
        [_gpsSwitch addTarget:self action:@selector(onSwitchGPS:) forControlEvents:UIControlEventTouchUpInside];
        [_gpsSwitch setOn:_data.gpsEnabled];
        cell.accessoryView = _gpsSwitch;
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Visit Facebook Fanpage";
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"Visit Twitter Page";
        }
    }else if (indexPath.section == 2){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Critical Mass Berlin";
            cell.detailTextLabel.text = @"www.criticalmass-berlin.org";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"GitHub Open Source";
            cell.detailTextLabel.text = @"www.github.com/headione/criticalmass-berlin";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Logo Design";
            cell.detailTextLabel.text = @"www.thomas-hollnack.de";
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"Programmierung";
            cell.detailTextLabel.text = @"www.pokuslabs.com";
        }
        
        
    }else if (indexPath.section == 3){
        if(indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"Donate"];
            cell.detailTextLabel.text = @"Help finacing our tracking server";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1){
        if(indexPath.row == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/pages/Critical-Mass-Berlin/74806304846"]];
        }else if(indexPath.row == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/cmberlin"]];
        }
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.criticalmass-berlin.org"]];
        }else if(indexPath.row == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/headione/criticalmass-berlin"]];
        }else if(indexPath.row == 2){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.thomas-hollnack.de"]];
        }else if(indexPath.row == 3){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.pokuslabs.com"]];
        }
        
    }else if (indexPath.section == 3){
        if(indexPath.row == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=TQGCAK3G3Z9GQ"]];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"GPS settings";
    }else if (section == 1){
        return @"Social Media";
    }else if (section == 2){
        return @"About";
    }else if (section == 3){
        return @"Please donate";
    }

    return @"";
}

- (void)updateGpsSwitch
{
    [_gpsSwitch setOn: _data.gpsEnabled];
}

-(IBAction)onSwitchGPS:(id)sender
{
    _data.gpsEnabledUser = [sender isOn];
    _data.gpsEnabledUser ? [_data enableGps] : [_data disableGps];
}

@end
