//
//  ChooseSexVC.m
//  GoEarn
//
//  Created by miaomiaokeji on 2016/10/8.
//  Copyright © 2016年 Beyondream. All rights reserved.
//

#import "ChooseSexVC.h"
#import "CustomView.h"
#import "CustomCell.h"
#import "LTPickerView.h"
#import "PickerView.h"
#import "PickerChoiceView.h"
#import "IndustryListModel.h"
#import "CityListModel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CityModel.h"
#import "LWAccount.h"

@interface ChooseSexVC ()<TFPickerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@property (nonatomic,strong) NSString  * workString;
@property (nonatomic,strong) NSString  * LocationStr;
@property (nonatomic,assign) BOOL  isselect;

@property (nonatomic,strong)  UILabel *dayLab;
@property (nonatomic,strong) NSMutableArray  * IndustryArr;
@property (nonatomic,strong) NSMutableArray  * CityArr;
@property (nonatomic,strong) NSString  * passValue;
@property (nonatomic,strong) NSString  * timeStr;
@property (nonatomic,strong) UIButton  * selectedBtn;
@property (nonatomic,strong) NSString  * cityID;
@property (nonatomic,strong) NSString  * industryID;
@property (nonatomic,strong) NSMutableArray  * induArr;
@end

@implementation ChooseSexVC
{
    UIButton *manSex;
    UIButton *womanSex;
    UILabel *workChange;
    CustomView *age;
    CustomView *working;
    UILabel *locationLab;
    CustomView *location;
    UIButton *locationChang;
    NSInteger selectIndex;
    NSString *city;
}

static NSString *cellIdentifier =@"cell";

-(NSMutableArray *)IndustryArr{
    if (!_IndustryArr) {
        _IndustryArr = [NSMutableArray array];
    }
    return _IndustryArr;
}

-(NSMutableArray *)CityArr{
    if (!_CityArr) {
        _CityArr = [NSMutableArray array];
    }
    return _CityArr;
}
#pragma mark - 定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //经度
    DLog(@"经度----%@",[NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude]);
    //将纬度现实到label上
    DLog(@"纬度-----%@",[NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude]);
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获得的信息
            DLog(@"获得的信息----%@",placemark.name);
            
            //获取城市
            city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            locationLab.text = city;
            UserDefaultSetObjectForKey(city, @"LOCATIONCITY");
            //找出城市ID
           for (int i=0; i<self.CityArr.count; i++) {
                CityListModel *cModel = self.CityArr[i];
               for (int a=0; a<cModel.child.count; a++) {
                    NSDictionary *dic = cModel.child[a];
                  NSString *cityName = [city stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"市"]];//该方法是去掉指定符号
                    if ([[NSString stringWithFormat:@"%@",dic[@"name"]] containsString:[NSString stringWithFormat:@"%@",cityName]]) {
                       UserDefaultSetObjectForKey(dic[@"id"], @"CITYID");
                   }
              }
            }
        }
        
        else if (error == nil && [array count] == 0)
        {
            DLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            DLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isselect = YES;
    self.passValue = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!UserDefaultObjectForKey(@"industryFirst")) {
        UserDefaultSetObjectForKey(@"1", @"industryFirst")
        [self GetIndustryListRequest];
        [self GetAreaListRequest];
    }else
    {
        NSArray *industryData = [NSKeyedUnarchiver unarchiveObjectWithFile:INDUSTRYPATH];
        NSArray *cityARR      = [NSKeyedUnarchiver unarchiveObjectWithFile:CITYLISTPATH];
        //hangyelist
        [UserDefaultObjectForKey(INDUSTRYLISTDATA) boolValue] ==YES?[self GetIndustryListRequest]:[self.IndustryArr addObjectsFromArray:industryData];
        //chengshilist
        [UserDefaultObjectForKey(AREALISTDATA) boolValue] ==YES?[self GetAreaListRequest]:[self.CityArr addObjectsFromArray:cityARR];
    }
    if (self.IndustryArr.count==0) {
        [self GetIndustryListRequest];
    }else if (self.CityArr.count==0){
         [self GetAreaListRequest];
    }
    
    [self initializeLocationService];//地理位置
    [self createUI];
    

    
}
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    [_locationManager startUpdatingLocation];
}
-(void)createUI{
 //头标
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    headerTitle.text = @"花七秒钟让我们了解你";
    headerTitle.textAlignment = NSTextAlignmentCenter;
    headerTitle.textColor = UIColorFromRGB(0xff4c61);
    headerTitle.font = Font(20);
    headerTitle.backgroundColor = kClearColor;
    [self.view addSubview:headerTitle];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, headerTitle.bottom+15, SCREEN_WIDTH, 10)];
    titleLab.text = @"提交后就不能修改了哦";
    titleLab.textColor = UIColorFromRGB(0x999999);
    titleLab.font = Font(13);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.backgroundColor = kClearColor;
    [self.view addSubview:titleLab];
    //退出按钮
    UIButton *dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissBtn.frame = CGRectMake(SCREEN_WIDTH-38, 25, 26, 26);
    [dissBtn setImage:[UIImage imageNamed:@"complete_close"] forState:UIControlStateNormal];
    dissBtn.backgroundColor = kClearColor;
    [dissBtn addTarget:self action:@selector(dissClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dissBtn];
  //选择性别
    CustomView *chooseSex = [[CustomView alloc] initWithFrame:CGRectMake(36, titleLab.bottom+20, SCREEN_WIDTH-72, 75) title:@"选择性别"];
    chooseSex.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chooseSex];
    
    manSex = [UIButton buttonWithType:UIButtonTypeCustom];
    manSex.frame = CGRectMake(chooseSex.left+90, chooseSex.top+(chooseSex.height-10)/2-5, 18, 18);
    [manSex setTitle:@"男" forState:UIControlStateNormal];
    manSex.titleLabel.font = Font(18);
    manSex.tag = 10011;
    [manSex setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    [manSex setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [manSex addTarget:self action:@selector(manClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manSex];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(manSex.right+20, chooseSex.top+(chooseSex.height-10)/2-5, 0.5, 18)];
    line.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:line];
    
    womanSex = [UIButton buttonWithType:UIButtonTypeCustom];
    womanSex.frame = CGRectMake(line.right+20, chooseSex.top+(chooseSex.height-10)/2-5, 18, 18);
    womanSex.tag = 10012;
    womanSex.titleLabel.font = Font(18);
    [womanSex setTitle:@"女" forState:UIControlStateNormal];
    [womanSex setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    [womanSex setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [womanSex addTarget:self action:@selector(manClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:womanSex];
  
    if ([[LWAccountTool account].sex isEqualToString:@"男"]) {
        manSex.selected = YES;
        womanSex.selected = NO;
    }else if([[LWAccountTool account].sex isEqualToString:@"女"]){
        manSex.selected  = NO;
        womanSex.selected = YES;
    }
    
    //选择年龄段
    age = [[CustomView alloc] initWithFrame:CGRectMake(36, chooseSex.bottom, SCREEN_WIDTH-72, 75) title:@"填写生日"];
    age.backgroundColor = [UIColor clearColor];
    [self.view addSubview:age];
    
    
    self.dayLab = [[UILabel alloc] initWithFrame:CGRectMake(age.left+90, age.top, 120, 75)];
    self.dayLab.userInteractionEnabled = YES;
    self.dayLab.text = [[LWAccountTool account].birthday isEmptyString]?@"请选择生日":[LWAccountTool account].birthday;
    self.dayLab.textColor = UIColorFromRGB(0x999999);
    self.dayLab.font = Font(15);
    [self.view addSubview:self.dayLab];
    
    UITapGestureRecognizer *dayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayClick)];
    [self.dayLab addGestureRecognizer:dayTap];
    
    UIButton *dayBtn = [[UIButton alloc] initWithFrame:CGRectMake(age.right-7 , age.top+(age.height-4)/2, 7, 4)];
    [dayBtn setImage:[UIImage imageNamed:@"filtrate_arrow_gray"] forState:UIControlStateNormal];
    [dayBtn addTarget:self action:@selector(dayClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dayBtn];
    
    //选择所属行业
    working = [[CustomView alloc] initWithFrame:CGRectMake(36, age.bottom, SCREEN_WIDTH-72, 75) title:@"所属行业"];
    working.userInteractionEnabled = YES;
    working.backgroundColor = [UIColor clearColor];
    [self.view addSubview:working];
    
    workChange = [[UILabel alloc] initWithFrame:CGRectMake(working.left+90, age.bottom, 120, 75)];
    workChange.userInteractionEnabled = YES;
    workChange.text = [[LWAccountTool account].industry isEmptyString]?@"请选择行业":[LWAccountTool account].industry;
    workChange.textColor = UIColorFromRGB(0x999999);
    workChange.font = Font(15);
    [self.view addSubview:workChange];
    
    UITapGestureRecognizer *worCha = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workingClick)];
    [workChange addGestureRecognizer:worCha];
    
    UIButton *workBtn = [[UIButton alloc] initWithFrame:CGRectMake(working.right-7 , working.top+(working.height-4)/2, 7, 4)];
    [workBtn setImage:[UIImage imageNamed:@"filtrate_arrow_gray"] forState:UIControlStateNormal];
    [workBtn addTarget:self action:@selector(workingClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:workBtn];
    
    //设常居地
    location = [[CustomView alloc] initWithFrame:CGRectMake(36, working.bottom, SCREEN_WIDTH-72, 75) title:@"所属城市"];
    location.backgroundColor = [UIColor clearColor];
    [self.view addSubview:location];

    locationLab = [[UILabel alloc] initWithFrame:CGRectMake(age.left+90, working.bottom,85, 75)];
    locationLab.textColor = UIColorFromRGB(0x999999);
    locationLab.text = [[LWAccountTool account].city isEmptyString]?@"未选择":[LWAccountTool account].city;
    locationLab.font = Font(15);
    [self.view addSubview:locationLab];
    
    locationChang = [[UIButton alloc] initWithFrame:CGRectMake(locationLab.right, location.top+(location.height-24)/2, 40, 24)];
    [locationChang setImage:[UIImage imageNamed:@"edit_btn"] forState:UIControlStateNormal];
    [locationChang addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationChang];

    UIButton* enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame= CGRectMake(36, location.bottom+35, SCREEN_WIDTH-72, 45);
    [enterBtn setTitle:@"提交信息" forState:UIControlStateNormal];
    enterBtn.backgroundColor = UIColorFromRGB(0xFF4c61);
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterBtn.cornerRadius = 3;
    enterBtn.titleLabel.font = Font(16);
    [enterBtn addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];

}
//生日
-(void)dayClick{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
//    selectIndex = indexPath.row;
    picker.delegate = self;
    picker.arrayType = DeteArray;
    
    [self.view addSubview:picker];

}
#pragma mark -------- TFPickerDelegate
//代理
- (void)PickerSelectorIndixString:(NSString *)str{
    self.dayLab.text = nil;
    self.dayLab.text = str;
    [self.view addSubview:self.dayLab];
    
    NSString *replaceStr;
    replaceStr = [str stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    replaceStr = [replaceStr stringByReplacingOccurrencesOfString:@"日" withString:@" "];
    UserDefaultSetObjectForKey(replaceStr, @"MANBIRTHDAY");
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    dateformatter.timeZone = [NSTimeZone systemTimeZone];
    dateformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date=[dateformatter dateFromString:replaceStr];
 //解决8个小时时间差
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    
    //转成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    self.timeStr = timeSp;
    UserDefaultSetObjectForKey(timeSp, @"TIMESP");
    DLog(@"%@，%@,%@",replaceStr,localDate,timeSp);
}
//提交个人信息
-(void)enterClick{
    [self GetUserDataSettingRequest];
    
}

-(void)manClick:(UIButton*)sender{
    manSex.selected = NO;
    womanSex.selected = NO;
    _selectedBtn.selected = NO;
    sender.selected = YES;
    _selectedBtn = sender;
    
    NSInteger value = sender.tag;
    if (value==10011) {
        UserDefaultSetObjectForKey(@"男", @"MANSEX");
        self.passValue = @"1";
    }else{
        UserDefaultSetObjectForKey(@"女", @"MANSEX");
    self.passValue = @"2";
    }
}
-(void)dissClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//行业
-(void)workingClick{
    LTPickerView* pickerView = [[LTPickerView alloc] init];
   NSArray *array = [IndustryListModel mj_keyValuesArrayWithObjectArray:self.IndustryArr];//设置要显示的数据
    NSMutableArray *ARR= [NSMutableArray array];
    
    for (int i =0; i<array.count; i++) {
       NSDictionary *dic = array[i];
        [ARR addObject:dic[@"name"]];
    }
    if (ARR.count>0) {
      pickerView.dataSource =ARR;
    }
   pickerView.defaultStr = @"";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        
        DLog(@"选择了第%d行的%@",num,str);
        UserDefaultSetObjectForKey(str, @"WORKINGINDUSTRY");
        
      self.induArr = [IndustryListModel mj_objectArrayWithKeyValuesArray:array];
        IndustryListModel *model = [[IndustryListModel alloc] init];
         model = self.induArr[num];
        self.industryID = model.ID;
        _workString = str;

        workChange.text = str;
        UserDefaultSetObjectForKey(str, @"WORKING");
        [self.view addSubview:workChange];
    };
}
//地区
-(void)locationClick{
    PickerView *picker = [[PickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*0.45)];
    [picker show];
    if (self.CityArr>0) {
      picker.princeArr = self.CityArr;//传值
    }
    picker.locationStr = ^(NSString *proName,NSString *cityName,NSString *proID,NSString *cityID){
        self.LocationStr = [NSString stringWithFormat:@"%@ %@",proName,cityName];
        self.cityID = cityID;
        UserDefaultSetObjectForKey(self.LocationStr , @"LOCATIOANSTR");
        LWAccount *account = [[LWAccount alloc] init];
        account.city = [NSString stringWithFormat:@"%@",cityName];
        
        CGSize maxTextSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, CGFLOAT_MAX);
        CGSize textSize = [self.LocationStr sizeWithFont:Font(15) maxSize:maxTextSize];
        CGFloat textViewW = textSize.width;
        [locationLab removeFromSuperview];
        locationLab = [[UILabel alloc] initWithFrame:CGRectMake(age.left+90, working.bottom,textViewW+8, 75)];
        locationLab.textColor = UIColorFromRGB(0x999999);
        locationLab.text = self.LocationStr;
        locationLab.font = Font(15);
        [self.view addSubview:locationLab];
        
        [locationChang removeFromSuperview];
        locationChang = [[UIButton alloc] initWithFrame:CGRectMake(locationLab.right, location.top+(location.height-14)/2, 40, 14)];
        [locationChang setImage:[UIImage imageNamed:@"edit_btn"] forState:UIControlStateNormal];
        [locationChang addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:locationChang];

        
    };
}

//行业请求
-(void)GetIndustryListRequest{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetIndustryListURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [weakSelf.IndustryArr removeAllObjects];
            [NSKeyedArchiver archiveRootObject:[IndustryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]] toFile:INDUSTRYPATH];
            NSArray *industryData = [NSKeyedUnarchiver unarchiveObjectWithFile:INDUSTRYPATH];
            [self.IndustryArr addObjectsFromArray:industryData];
        }else
        {
            [MBProgressHUD showMessage:@"链接错误"];
        }
    }];
}
//地区请求
-(void)GetAreaListRequest{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetAreaListURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [weakSelf.CityArr removeAllObjects];
            [NSKeyedArchiver archiveRootObject:[CityListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]] toFile:CITYLISTPATH];
            NSArray *cityArr = [NSKeyedUnarchiver unarchiveObjectWithFile:CITYLISTPATH];
            [self.CityArr addObjectsFromArray:cityArr];
            
        }else
        {
            [MBProgressHUD showMessage:@"链接错误"];
        }
    }];
}
//个人数据请求
-(void)GetUserDataSettingRequest{
    NSString *timesp = UserDefaultObjectForKey(@"TIMESP");
    NSString *IDSTR  = UserDefaultObjectForKey(@"CITYID");
    if ([self.industryID intValue]==0) {
        self.industryID = @"1";
    }
    if (IDSTR){
        self.cityID = IDSTR;
    }else{
        self.cityID = @"105";
    }
    
    NSString *string = UserDefaultObjectForKey(USER_INFO_LOGIN);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LWAccountTool account].no forKey:@"no"];
    [dic setValue:string forKey:@"session"];
    [dic setValue:self.passValue forKey:@"sex"];
    [dic setValue:timesp forKey:@"birthday"];
    [dic setValue:self.industryID forKey:@"iid"];
    [dic setValue:self.cityID forKey:@"aid"];
    
    [[[AFNetworkRequest alloc]init] requestWithVC:[UIApplication sharedApplication].keyWindow.rootViewController URLString:[NSString stringWithFormat:@"%@%@",KBASE_URL,GetUserSetURL] parameters:dic type:NetworkRequestTypePost resultBlock:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"code"] intValue] ==0) {
            [MBProgressHUD showMessage:@"提交成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICERELOAD" object:nil];
        }else if([responseObject[@"code"] intValue] ==60005)
        {
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }else{
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
