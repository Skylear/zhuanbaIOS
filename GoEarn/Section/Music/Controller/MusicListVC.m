//
//  MusicListVC.m
//  GoEarn
//
//  Created by Beyondream on 2016/11/18.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "MusicListVC.h"
#import "MusicPlayingViewController.h"
#import "MusicAudioTool.h"
@interface MusicListVC ()
@end

@implementation MusicListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.title = @"我的音乐";
}
-(void)getData
{
    self.musicArr  = [MusicModel objectArrayWithFilename:@"Musics.plist"];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.musicArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *musicString = @"music";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:musicString];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:musicString];
    }
    MusicModel *model = self.musicArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:model.singerIcon];
    cell.textLabel.text = model.name;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (MusicModel *model in self.musicArr) {
        [MusicAudioTool stopMusicWithMusicName:model.filename];
    }

    MusicModel *model = self.musicArr[indexPath.row];
    [MusicTool setPlayingMusic: model];
    MusicPlayingViewController*vc = [[MusicPlayingViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
