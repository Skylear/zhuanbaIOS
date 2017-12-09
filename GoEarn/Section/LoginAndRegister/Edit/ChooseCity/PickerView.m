//
//  PickerView.m
//  PickerDemo
//
//  Created by miaomiaokeji on 16/8/30.
//  Copyright © 2016年 demo. All rights reserved.
//

#import "PickerView.h"
#import "UIView+RGSize.h"

#import "UIWindow+Extension.h"
#import "CityListModel.h"
#import "ProviceModel.h"
#import "CityModel.h"



#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))

@interface PickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,assign)NSInteger firstRow;
@property (nonatomic, strong) UIView *maskView; // 遮罩层
@property (nonatomic, strong) UIView *supPickerView; // 装载pickerView
@property (nonatomic, strong) UIPickerView *myPickerView; // pickerView
@property (nonatomic, strong) UIView *smallView; // 装载button
@property(nonatomic,strong)NSMutableArray  * cityArr;
@property (nonatomic,strong)  NSMutableArray  * ProviceNameArr;
@property (nonatomic,strong) NSMutableArray  * CityNameArr;
@end


@implementation PickerView
{
    NSString *proViceID;
    NSString *CityID;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self CreateUI];
        if ([[NSString stringWithFormat:@"%ld",(long)_firstRow] isEmptyString]) {
            _firstRow = 0;
        }
    }
    return self;

}

-(void)show{

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreen_Height-kScreen_Height*0.45, kScreenWidth,kScreen_Height * 0.45 );
        [[UIWindow lastWindow] addSubview:self];

    }];

    
}

-(void)CreateUI{
    
    [self initViews];
    [self.supPickerView addSubview:self.smallView];
    [self addSubview:self.supPickerView];
    
}

- (void) initViews
{
    self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.maskView];
    
    self.supPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-kScreen_Height * 0.45, kScreen_Width, kScreen_Height * 0.45)];
  
    self.supPickerView.backgroundColor = [UIColor whiteColor];
    
    self.myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreen_Width, 200)];
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    [self.supPickerView addSubview:_myPickerView];
    
    self.smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    self.smallView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(kScreen_Width - 60, 0, 50, 50);
    sureButton.titleLabel.font = [UIFont systemFontOfSize: 22];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    [self.smallView addSubview:sureButton];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(10, 0, 50, 50);
    cancleButton.titleLabel.font = [UIFont systemFontOfSize: 22];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(makeCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.smallView addSubview:cancleButton];
    
}

- (void) hideMyPicker
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.supPickerView.frame = CGRectMake(0, kScreenHeight, SCREEN_WIDTH, kScreen_Height*0.45);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        [self.supPickerView removeFromSuperview];
        
        self.maskView = nil;
        self.supPickerView = nil;
    }];
}

- (void) makeCancel
{
    DLog(@"点击了取消")
    
    [self hideMyPicker];
}

#pragma mark - set
-(void)makeSure
{
    NSInteger row1 = [self.myPickerView selectedRowInComponent:0];
    NSInteger row2 = [self.myPickerView selectedRowInComponent:1];
    CityListModel *Model = [_ProviceNameArr objectAtIndex:row1];
    NSString *CityName = [self.CityNameArr[_firstRow] objectAtIndex:row2][@"name"];
    DLog(@"确定:%@,%@",Model.name,CityName);
    
    
    NSArray *cityArr = self.CityNameArr[row1];
    CityID = cityArr[row2][@"id"];
  
    
    if (self.locationStr) {
        self.locationStr(Model.name,CityName,proViceID,CityID);
    }

  [self hideMyPicker];
}
-(void)setPrinceArr:(NSMutableArray *)princeArr{
    _princeArr = princeArr;


    self.ProviceNameArr = [NSMutableArray array];
    self.CityNameArr = [NSMutableArray array];
    for (int i=0; i<princeArr.count; i++)
    {
        CityListModel *model = princeArr[i];
        [_ProviceNameArr addObject:model];
        
        DLog(@"name---%@",model.name);
        
        [_CityNameArr addObject:model.child];
        
        DLog(@"child ---%@",model.child);
    }
    
    [self.myPickerView reloadAllComponents];
}
#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _ProviceNameArr.count;
    }
    else
    {
        NSArray *cityArr =self.CityNameArr[_firstRow];
        return cityArr.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CityListModel *proModel = _ProviceNameArr[row];
     if (component == 0) {
        return proModel.name;
    }
    else
    {
        NSArray *cityArr =self.CityNameArr[_firstRow];

        DLog(@"0000000----%@",cityArr[row][@"name"]);
        return cityArr[row][@"name"];
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"选中%ld",(long)component);
    CityListModel *proModel = [[CityListModel alloc] init];
   //pickerview 在未选择 状态下出现component==1无选择bug
    if (component == 0) {
        _firstRow = row;
        proModel = _ProviceNameArr[row];
        proViceID = proModel.ID;
        [self.myPickerView reloadComponent:1];
    }else if (component==1) {
       NSArray *cityArr = self.CityNameArr[_firstRow];
        CityID = cityArr[row][@"id"];
    }
    
    
    [self.myPickerView reloadAllComponents];
}



@end
