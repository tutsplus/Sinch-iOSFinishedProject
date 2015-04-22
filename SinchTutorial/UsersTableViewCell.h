//
//  UsersTableViewCell.h
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/31/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TextInsetLabel;

@interface UsersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TextInsetLabel *message;

@end
