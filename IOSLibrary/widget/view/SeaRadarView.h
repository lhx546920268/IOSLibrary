//
//  SeaRadarView.h
//  BeautifulLife
//
//  Created by 罗海雄 on 17/9/9.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///雷达数据
@interface SeaRadarInfo : NSObject

//值
@property(nonatomic, assign) int value;

//标题
@property(nonatomic, copy) NSString *title;

@end

///雷达图
@interface SeaRadarView : UIView

//雷达线条颜色
@property(nonatomic, strong) UIColor *redarStrokeColor;

//数据线条颜色
@property(nonatomic, strong) UIColor *dataStrokeColor;

//内部填充颜色
@property(nonatomic, strong) UIColor *innerFillColor;

//外包填充颜色
@property(nonatomic, strong) UIColor *outerFillColor;

//雷达数据
@property(nonatomic, strong) NSArray<SeaRadarInfo*> *radarInfos;

//最大指数
@property(nonatomic, assign) int maxValue;

//y轴坐标偏移
@property(nonatomic, assign) int offsetY;

@end
