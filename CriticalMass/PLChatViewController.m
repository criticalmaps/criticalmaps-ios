//
//  PLChatViewController.m
//  CriticalMaps
//
//  Created by Norman Sander on 18.01.15.
//  Copyright (c) 2015 Pokus Labs. All rights reserved.
//

#import "PLChatViewController.h"
#import "PLChatObject.h"
#import "PLConstants.h"
#import "UIColor+Helper.h"

@interface PLChatViewController ()

@property (nonatomic, strong) PLChatModel *chatModel;
@property (nonatomic, strong) PLDataModel *dataModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) HOButton *btnSend;

@end

@implementation PLChatViewController

#define kOFFSET_FOR_KEYBOARD 200.0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataModel = [PLDataModel sharedManager];
    _chatModel = [PLChatModel sharedManager];
    
    // navbar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = [NSLocalizedString(@"chat.title", nil) uppercaseString];
    navBar.items = @[ navItem ];
    navBar.translucent = NO;
    [self.view addSubview:navBar];
    
    // add table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, self.view.frame.size.width, self.view.frame.size.height-189)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
    
    // add gesture recognizer
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.tableView addGestureRecognizer:gesture];
    
    // add control
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-110, self.view.frame.size.width, 50)];
    [self.view addSubview:self.controlView];
    
    // add textfield
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 240, 50)];
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.textField.layer.cornerRadius = 3;
    self.textField.delegate = self;
    [self.controlView addSubview: self.textField];
    
    // add button
    self.btnSend = [HOButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnSend.frame = CGRectMake(260,  0, 50, 50);
    self.btnSend.layer.borderWidth = 1.0;
    [self.btnSend setBackgroundColor:[UIColor clearColor]];
    [self.btnSend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.btnSend addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSend setTitle:NSLocalizedString(@"chat.send", nil) forState:UIControlStateNormal];
    [self.controlView addSubview: self.btnSend];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessagesReceived) name:kNotificationChatMessagesReceived object:_chatModel];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationChatMessagesReceived
                                                  object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view endEditing:YES]; // Hide keyboard
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onSend {
    
    if([self.textField.text isEqualToString: @""]){
        return;
    }
    
    [_chatModel collectMessage: self.textField.text];
    self.textField.text = @"";
}

- (void)moveContent:(BOOL)moveUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rectControl = self.controlView.frame;
    CGRect rectTable = self.tableView.frame;
    if (moveUp)
    {
        rectTable.size.height -= kOFFSET_FOR_KEYBOARD;
        rectControl.origin.y -= kOFFSET_FOR_KEYBOARD;
        
    }
    else
    {
        rectTable.size.height += kOFFSET_FOR_KEYBOARD;
        rectControl.origin.y += kOFFSET_FOR_KEYBOARD;
    }
    
    self.tableView.frame = rectTable;
    self.controlView.frame = rectControl;
    
    [UIView commitAnimations];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_chatModel.messages.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
        return 1;
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = NSLocalizedString(@"chat.noChatActivity", nil);
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chatModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >= [_chatModel.messages count]) {
        return nil;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    PLChatObject *message = [_chatModel.messages objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [self fontForCell];
    cell.textLabel.text = message.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.imageView.image = [UIImage imageNamed:@"Punk"];
    cell.imageView.image = [cell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.tintColor = [UIColor magicColor];
    cell.imageView.frame = CGRectMake(0,0,12,12);
    
    if(message.isActive){
        return cell;
    }
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Spacer is a 1x1 transparent png
    UIImage *spacer = [UIImage imageNamed:@"Spacer"];
    UIGraphicsBeginImageContext(spinner.frame.size);
    
    [spacer drawInRect:CGRectMake(0,0,spinner.frame.size.width,spinner.frame.size.height)];
    UIImage* resizedSpacer = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    cell.imageView.image = resizedSpacer;
    [cell.imageView addSubview:spinner];
    [spinner startAnimating];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLChatObject *message = [_chatModel.messages objectAtIndex:indexPath.row];
    NSString *cellText = message.text;
    NSDictionary *attributes = @{NSFontAttributeName: [self fontForCell]};
    CGRect rect = [cellText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    return rect.size.height + 20;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self moveContent:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self moveContent:NO];
}

- (void)onTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES]; // Hide keyboard
}

- (void)onMessagesReceived {
    [self.tableView reloadData];
//    NSIndexPath* ipath = [NSIndexPath indexPathForRow: _chatModel.sortedMessages.count-1 inSection: 0];
//    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

- (UIFont*)fontForCell {
    return [UIFont systemFontOfSize:18.0];
}

@end
