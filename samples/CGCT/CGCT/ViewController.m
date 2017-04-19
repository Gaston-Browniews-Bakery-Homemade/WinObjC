//
//  ViewController.m
//  CGCT
//
//  Created by Henry Fox on 11/04/2017.
//  Copyright © 2017 Microsoft. All rights reserved.
//

#import "ViewController.h"
#import "PathDemoTableViewCell.h"
#import "CGView.h"

#define VC_WIDTH self.view.frame.size.width
#define VC_HEIGHT self.view.frame.size.height

@interface ViewController ()
@property UITableView* CGMenu;
@property CGContextRef stageContext;
@property CGRect stageBounds;
@property CGView* stage;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)loadView {
    [super loadView];

    //[_stage.topAnchor constraintEqualToAnchor : self.view.topAnchor].active = YES;
    //[_stage.bottomAnchor constraintEqualToAnchor : self.view.bottomAnchor].active = YES;
    //[_stage.leftAnchor constraintEqualToAnchor : self.view.leftAnchor].active = YES;
    //[_stage.rightAnchor constraintEqualToAnchor : self.view.rightAnchor].active = YES;
    //
    //[_CGMenu.leftAnchor constraintEqualToAnchor : self.view.leftAnchor].active = YES;
}

- (void)viewWillLayoutSubviews {
    _stageBounds = self.view.bounds;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_CGMenu setNeedsLayout];
    [_CGMenu layoutIfNeeded];
    [_stage setNeedsLayout];
    [_stage setNeedsDisplay];

    CGRect newFrame = CGRectMake(0, 0, _stageBounds.size.width / 5.0, _stageBounds.size.height);
    _CGMenu.frame = newFrame;

    CGFloat stageSize = _stageBounds.size.width / 5 * 4;
    if (stageSize > _stageBounds.size.height) {
        stageSize = _stageBounds.size.height;
    }
    CGRect newStageFrame = CGRectMake(_stageBounds.size.width / 5.0, 0, stageSize, stageSize);
    _stage.frame = newStageFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _CGMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VC_WIDTH / 5.0, VC_HEIGHT) style:UITableViewStylePlain];
    _CGMenu.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    _CGMenu.rowHeight = 30;
    _CGMenu.scrollEnabled = YES;
    _CGMenu.userInteractionEnabled = YES;
    _CGMenu.bounces = NO;

    _CGMenu.delegate = self;
    _CGMenu.dataSource = self;

    _stage = [[CGView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:_stage];
    [self.view addSubview:_CGMenu];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (tableView == _CGMenu) {
        // Cast to story overview type, but for now just cast to our only story view.
        _stage.backgroundColor = [UIColor colorWithRed:.1 green:.3 blue:1 alpha:1];
        [_stage updateCurrentDemo:[tableView cellForRowAtIndexPath:indexPath]];
        [_stage setNeedsDisplay];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    // In reality, we want to keep track of an array of the actual CellViewControllers
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath*)indexPath {
    if (tableView == _CGMenu) {
        // use const
        UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"CGStory1"];
        if (aCell == nil) {
            aCell = [[PathDemoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CGStory1"];
        }
        aCell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        aCell.textLabel.text = @"CGPathDemo1";

        return aCell;
    }

    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
