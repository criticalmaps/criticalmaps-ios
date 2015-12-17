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
#import "PLTabBarController.h"

@interface PLChatViewController ()

@property (nonatomic, strong) PLChatModel *chatModel;
@property (nonatomic, strong) PLDataModel *dataModel;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlsBottomConstraint;

@end

@implementation PLChatViewController

#define kOFFSET_FOR_KEYBOARD 200.0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataModel = [PLDataModel sharedManager];
    _chatModel = [PLChatModel sharedManager];
    
    // navbar
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.translucent = NO;
    self.navBar.topItem.title = [NSLocalizedString(@"chat.title", nil) uppercaseString];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.btnSend setTitle:NSLocalizedString(@"chat.send", nil) forState:UIControlStateNormal];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.tableView addGestureRecognizer:gesture];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessagesReceived) name:kNotificationChatMessagesReceived object:_chatModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationChatMessagesReceived
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view endEditing:YES]; // Hide keyboard
    
}

- (IBAction)onSend:(id)sender {
    if([self.textField.text isEqualToString: @""]) {
        return;
    }
    
    [_chatModel collectMessage: self.textField.text];
    self.textField.text = @"";
    
    [self.textField resignFirstResponder];
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

#pragma mark - UITableView Methods

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

#pragma mark - Notification Handlers

- (void)keyboardWillShow:(NSNotification *)sender {
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat constraintHeight = keyboardFrame.size.height - self.tabBarController.tabBar.frame.size.height;
    self.controlsBottomConstraint.constant = constraintHeight;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.controlsBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

@end
