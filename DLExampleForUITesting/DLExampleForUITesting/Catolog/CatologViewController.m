//
//  CatologViewController.m
//  DLExampleForUITesting
//
//  Created by David on 16/2/14.
//  Copyright © 2016年 David. All rights reserved.
//

#define kCatologNamesArray @[@"ViewController",@"TopScrollViewController",@"CircleProgressViewController",@"SpiderNetViewController",@"DragViewController"]

#import "CatologViewController.h"

@interface CatologViewController()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation CatologViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    if (!_tableView) {
        CGRect frame = self.view.bounds;
//        CGFloat topEdge = 20.0f;
//        frame.origin.y = topEdge;
//        frame.size.height -= topEdge;
        _tableView = [[UITableView alloc] initWithFrame:frame];
        [self.view addSubview:_tableView];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - table view delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [kCatologNamesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"CellId";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    NSString *name = [kCatologNamesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [kCatologNamesArray objectAtIndex:indexPath.row];
    Class clazz = NSClassFromString(name);
    UIViewController *controller = [[clazz alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
