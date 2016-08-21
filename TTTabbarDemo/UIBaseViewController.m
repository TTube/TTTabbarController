//
//  UIBaseViewController.m
//  JFZUIBaseFrame
//
//  Created by Galvin on 16/3/1.
//  Copyright © 2016年 Galvin. All rights reserved.
//

#import "UIBaseViewController.h"
#import "UIViewController+TTTabbar.h"
@interface UIBaseViewController ()

@end

@implementation UIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickPush:(id)sender {
    UIBaseViewController *baseViewController = [[UIBaseViewController alloc] initWithNibName:@"UIBaseViewController" bundle:nil];
    baseViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baseViewController animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
