//
//  ViewController.m
//  MWPhotoBrowserTest
//
//  Created by mac on 16/3/24.
//  Copyright © 2016年 Seven. All rights reserved.
//

#import "ViewController.h"
#import <MWPhotoBrowser.h>
@interface ViewController ()<MWPhotoBrowserDelegate>

@end

@implementation ViewController
{
    NSMutableArray *photoes;
    NSMutableArray *selections;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self MWPhotoBrowserTest];
}
-(void)MWPhotoBrowserTest
{
    selections=[[NSMutableArray alloc]init];
    photoes=[[NSMutableArray alloc]init];
    
    for (int i=1; i<6; i++) {
        [photoes addObject:[MWPhoto photoWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]]]];
        //caption==标题，给图片设置标题
    }
    //增加网络图片
    [photoes addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://img2.imgtn.bdimg.com/it/u=2934601455,4000730499&fm=21&gp=0.jpg"]]];
    //增加视频
    MWPhoto *video=[MWPhoto photoWithURL:[NSURL URLWithString:@"http://img2.imgtn.bdimg.com/it/u=2934601455,4000730499&fm=21&gp=0.jpg"]];//视频封面地址
    video.videoURL=[NSURL URLWithString:@""];//视频地址
    
    
    
    //创建MWPhotoBrowser对象==继承于UIViewController
    MWPhotoBrowser *browser=[[MWPhotoBrowser alloc]initWithDelegate:self];
    
    //设置MWPhotoBrowser的属性
    browser.enableGrid=YES;//以网格的形式展示图片
    browser.startOnGrid=YES;//一进入的时候就以网格的形式展现
    browser.displayActionButton=YES;//展示action按钮==就是右上角的按钮，用于分享，拷贝的按钮，默认yes
    browser.displayNavArrows=YES;//是否在工具栏显示左和右导航箭头（默认为No）
    browser.displaySelectionButtons=YES;//是否展示选中按钮（默认为No）
    browser.zoomPhotosToFill=YES;//是否满屏展示图片(默认为Yes)
    browser.alwaysShowControls=NO;//是否一直展示导航控制器的导航条，即便是他将要消失或全屏展示图片的时候（默认为No）
    browser.autoPlayOnAppear=NO;//是否自动播放视频
    
    
    
    //设置当前默认展示的图片==可选的设置
    [browser setCurrentPhotoIndex:1];
    
    [browser showNextPhotoAnimated:YES];//动画展示下一张图片
    [browser showPreviousPhotoAnimated:YES];//动画展示当前被操作的图片
    
    
    if (browser.displaySelectionButtons) {
        selections=[NSMutableArray new];
        for (int i=0; i<photoes.count; i++) {
            [selections addObject:[NSNumber numberWithBool:NO]];//默认都是补选中的
        }
    }
    
    [self presentViewController:browser animated:YES completion:^{
        NSLog(@"开始展示图片");
    }];
    
}

#pragma mark==MWPhotoBrowserDelegate必须实现的代理方法
//设置要在PhotoBrowser中展示的图片总数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return photoes.count;
}
//按索引返回图片
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index<photoes.count) {
        return [photoes objectAtIndex:index];
    }
    return nil;
}
#pragma mark==MWPhotoBrowserDelegate按需实现的代理方法
//要想图片以网格的格式展示就必须实现这个方法==thumb==缩略图
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index<photoes.count) {
        return [photoes objectAtIndex:index];
    }
    return nil;
}
//这个是点击了action按钮后调用的方法==PS：如果实现了这个方法就不会再走作者原先预设的action了。
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    // Do your thing!
//    
//    NSLog(@"点击了action按钮");
//}
//选中图片的代理方法
- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index
{
    
    
    NSLog(@"选中第%lu张图片",(unsigned long)index);
    
    return [[selections objectAtIndex:index] boolValue];;//返回Yes就是选中的意思
}
//选中图片的改变显示位置
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected
{
    [selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
