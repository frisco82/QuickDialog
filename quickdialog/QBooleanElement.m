//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <objc/message.h>

@implementation QBooleanElement {
    __unsafe_unretained QuickDialogController *_controller;
}
@synthesize onImage = _onImage;
@synthesize offImage = _offImage;
@synthesize boolValue = _boolValue;
@synthesize enabled = _enabled;


- (QBooleanElement *)init {
    self = [self initWithTitle:nil BoolValue:YES];
    return self;
}

- (QBooleanElement *)initWithTitle:(NSString *)title BoolValue:(BOOL)value {
    self = [self initWithTitle:title Value:nil];
    self.boolValue = value;
    self.enabled = YES;
    return self;
}

- (void)setOnImageName:(NSString *)name {
    self.onImage = [UIImage imageNamed:name];
}

- (void)setOffImageName:(NSString *)name {
    self.offImage = [UIImage imageNamed:name];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];
    cell.accessoryType = self.sections!= nil ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectionStyle = self.sections!= nil ? UITableViewCellSelectionStyleBlue: UITableViewCellSelectionStyleNone;
    _controller = controller;
    if ((_onImage==nil) && (_offImage==nil))  {
        UISwitch *boolSwitch = [[UISwitch alloc] init];
        boolSwitch.on = self.boolValue;
        boolSwitch.enabled = self.enabled;
        [boolSwitch addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = boolSwitch;

    } else {
        UIButton *boolButton = [[UIButton alloc] init];
        [boolButton setImage:self.offImage forState:UIControlStateNormal];
        [boolButton setImage:self.onImage forState:UIControlStateSelected];
        cell.accessoryView = boolButton;
        boolButton.enabled = self.enabled;
        boolButton.selected = self.boolValue;
        [boolButton sizeToFit];
        [boolButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)path {
    ;
}

- (void)buttonPressed:(UIButton *)boolButton {
    self.boolValue = !boolButton.selected;
    boolButton.selected = _boolValue;
    if ((_controller != nil && self.controllerAction != nil) || _onSelected != nil) {
        [self handleElementSelected:_controller];
    }
}

- (void)switched:(id)boolSwitch {
    self.boolValue = ((UISwitch *)boolSwitch).on;
    if ((_controller != nil && self.controllerAction != nil) || _onSelected != nil) {
        [self handleElementSelected:_controller];
    }
}

- (void)fetchValueIntoObject:(id)obj {
	if (_key==nil)
		return;
    [obj setValue:[NSNumber numberWithBool:self.boolValue] forKey:_key];
}


@end