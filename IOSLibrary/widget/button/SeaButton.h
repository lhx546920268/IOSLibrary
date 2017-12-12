//
//  SeaButton.h

//

#import <UIKit/UIKit.h>

/**自定义button类型
 */
typedef enum
{
    SeaButtonTypeNumberAndSquare = 0, //数字和两个正方形，类似Safari中的底部工具条网页多窗口选择
    SeaButtonTypeAdd = 1, //加号
    SeaButtonTypeLeftArrow = 2, //朝向左边箭头
    SeaButtonTypeRightArrow = 3, //朝向右边箭头
    SeaButtonTypeBookmark = 4, //书签
    SeaButtonTypeRefresh = 5, //刷新
    SeaButtonTypeUpload = 6, //上传
    SeaButtonTypeClose = 7, //关闭按钮，一个X
    SeaButtonTypeSearch = 8, //搜索按钮
}SeaButtonType;

/**自定义的button 内容使用CGGraphic绘制
 */
@interface SeaButton : UIButton

/**线条颜色 default is '[UIColor greenColor]'
 */
@property(nonatomic,retain) UIColor *lineColor;

/**disable线条颜色 default is '[UIColor grayColor]'
 */
@property(nonatomic,retain) UIColor *disableLineColor;

/**线条大小 default is '1.2'
 */
@property(nonatomic,assign) CGFloat lineWidth;

/**内容区域 根据 seaButtonType 来设置默认值
 */
@property(nonatomic,assign) CGRect contentBounds;

/**当前数字 default is '1'
 */
@property(nonatomic,assign) int number;

/**button的类型
 */
@property(nonatomic,readonly) SeaButtonType seaButtonType;

/**构造方法 
 *@param frame button位置大小
 *@param type button类型
 *@return 一个初始化的 SeaButton对象
 */
- (id)initWithFrame:(CGRect)frame buttonType:(SeaButtonType) type;

@end
