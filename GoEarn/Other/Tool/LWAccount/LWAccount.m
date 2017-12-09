//
//  LWAccount.m
//  MIAOTUI2
//
//  Created by tangxiaowei on 16/5/24.
//  Copyright © 2016年 miaoMiao. All rights reserved.
//

#import "LWAccount.h"

@implementation LWAccount
- (void)encodeWithCoder:(NSCoder *)encode
{
    
    if (self.no) {
        
        [encode encodeObject:self.no forKey:@"no"];
            }
    if (self.avatar) {
        
        [encode encodeObject:self.avatar forKey:@"avatar"];
    }
    if (self.nickname) {
        
        [encode encodeObject:self.nickname forKey:@"nickname"];
    }
    if (self.sex) {
        
        [encode encodeObject:self.sex forKey:@"sex"];
    }
    if (self.birthday) {
        
        [encode encodeObject:self.birthday forKey:@"birthday"];
    }
    if (self.industry) {
        
        [encode encodeObject:self.industry forKey:@"industry"];
    }
    if (self.city) {
        
        [encode encodeObject:self.city forKey:@"city"];
    }
    if (self.total_score) {
        
        [encode encodeObject:[NSString stringWithFormat:@"%ld",(long)self.total_score] forKey:@"total_score"];
    }
    if (self.score) {
        
        [encode encodeObject:[NSString stringWithFormat:@"%ld",(long)self.score] forKey:@"score"];
    }
    if (self.check_money) {
         [encode encodeObject:self.check_money forKey:@"check_money"];
    }
    if (self.total_money) {
        
        [encode encodeObject:self.total_money forKey:@"total_money"];
    }
    if (self.money) {
        
        [encode encodeObject:self.money forKey:@"money"];
    }
    if (self.phone) {
        
        [encode encodeObject:self.phone forKey:@"phone"];
    }
    if (self.openid) {
        
        [encode encodeObject:self.openid forKey:@"openid"];
    }
    if (self.device_udid) {
        
        [encode encodeObject:self.device_udid forKey:@"device_udid"];
    }
    if (self.device_imei) {
        [encode encodeObject:self.device_imei forKey:@"device_imei"];
    }
    if (self.getCashMoney) {
        [encode encodeObject:self.getCashMoney forKey:@"getCashMoney"];
    }
    if (self.today_money) {
        [encode encodeObject:self.today_money forKey:@"today_money"];
    }
    if (self.agreement) {
        [encode encodeObject:self.agreement forKey:@"agreement"];
    }
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.no            = [decoder decodeObjectForKey:@"no"] ;
        self.avatar        = [decoder decodeObjectForKey:@"avatar"];
        self.nickname      = [decoder decodeObjectForKey:@"nickname"];
        self.sex           = [decoder decodeObjectForKey:@"sex"] ;
        self.birthday      = [decoder decodeObjectForKey:@"birthday"] ;
        self.industry      = [decoder decodeObjectForKey:@"industry"];
        self.city          = [decoder decodeObjectForKey:@"city"];
        self.total_score   = [[decoder decodeObjectForKey:@"total_score"]intValue];
        self.today_money   = [decoder decodeObjectForKey:@"today_money"];
        self.score         = [[decoder decodeObjectForKey:@"score"] intValue];
        self.check_money   = [decoder decodeObjectForKey:@"check_money"];
        self.total_money   = [decoder decodeObjectForKey:@"total_money"];
        self.money         = [decoder decodeObjectForKey:@"money"];
        self.phone         = [decoder decodeObjectForKey:@"phone"];
        self.openid        = [decoder decodeObjectForKey:@"openid"];
        self.device_imei   = [decoder decodeObjectForKey:@"device_imei"];
        self.device_udid   = [decoder decodeObjectForKey:@"device_udid"];
        self.getCashMoney  = [decoder decodeObjectForKey:@"getCashMoney"];
        self.agreement     = [decoder decodeObjectForKey:@"agreement"];
    }
    return self;
}
@end
