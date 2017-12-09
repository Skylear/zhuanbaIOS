/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_2G_NAMESTRING            @"iPhone 2G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS" 
#define IPHONE_4_NAMESTRING             @"iPhone 4" 
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5S_NAMESTRING             @"iPhone 5S"
#define IPHONE_6_NAMESTRING             @"iPhone 6"
#define IPHONE_6P_NAMESTRING             @"iPhone 6P"
#define IPHONE_6S_NAMESTRING             @"iPhone 6S"
#define IPHONE_6SP_NAMESTRING             @"iPhone 6SP"
#define IPHONE_7_NAMESTRING             @"iPhone 7"
#define IPHONE_7P_NAMESTRING             @"iPhone 7P"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_mini_NAMESTRING              @"iPad mini"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

//iPhone 3G 以后各代的CPU型号和频率
#define IPHONE_3G_CPUTYPE               @"ARM11"
#define IPHONE_3G_CPUFREQUENCY          @"412MHz"
#define IPHONE_3GS_CPUTYPE              @"ARM Cortex A8"
#define IPHONE_3GS_CPUFREQUENCY         @"600MHz" 
#define IPHONE_4_CPUTYPE                @"Apple A4"
#define IPHONE_4_CPUFREQUENCY           @"1GMHz"
#define IPHONE_4S_CPUTYPE               @"Apple A5 Double Core"
#define IPHONE_4S_CPUFREQUENCY          @"800MHz"

//iPod touch 4G 的CPU型号和频率
#define IPOD_4G_CPUTYPE                 @"Apple A4"
#define IPOD_4G_CPUFREQUENCY            @"800MHz"

#define IOS_CPUTYPE_UNKNOWN             @"Unknown CPU type"
#define IOS_CPUFREQUENCY_UNKNOWN        @"Unknown CPU frequency"

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceSimulator,
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDevice2GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4SiPhone,
    UIDevice5iPhone,
    UIDevice5SiPhone,
    UIDevice6iPhone,
    UIDevice6PiPhone,
    UIDevice6SiPhone,
    UIDevice6SPiPhone,
    UIDevice7iPhone,
    UIDevice7PiPhone,

    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    UIDevice5GiPod,
    
    UIDevice1GiPad,
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDevice4GiPad,
    UIDeviceiPadMini,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,

} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
    
} UIDeviceFamily;

@interface UIDevice (Hardware)

- (NSString *) idfaString;          //IDFA 广告标识符

- (NSString *) platformString;      //平台信息

- (NSString *) cpuType;             //cpu型号
- (NSString *) cpuFrequency;        //cpu频率
- (NSUInteger) cpuCount;            //cpu核数
- (NSArray *) cpuUsage;                 //cpu利用率

- (NSUInteger) totalMemoryBytes;    //获取手机内存总量,返回的是字节数
- (NSUInteger) freeMemoryBytes;     //获取手机可用内存,返回的是字节数

- (long long) freeDiskSpaceBytes;   //获取手机硬盘空闲空间,返回的是字节数
- (long long) totalDiskSpaceBytes;  //获取手机硬盘总空间,返回的是字节数
- (NSString*) getbatteryLevel; //电池电量

-  (NSString*) getbatteryState;//电池状态

- (NSString *) getTelephonyInfo;//运营商

- (BOOL) isJailBreak;               //是否越狱

- (BOOL) bluetoothCheck;            //是否支持蓝牙

- (NSString *) getWifiName;      //获取Wifi名字

- (NSString *) localIPAddress;//局域网IP

- (NSString *) openTime;//开机时间

- (NSMutableDictionary*) phoneMessageDictionary;



@end
