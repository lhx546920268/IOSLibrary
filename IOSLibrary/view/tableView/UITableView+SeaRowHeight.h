//
//  UITableView+SeaRowHeight.h
//  BeautifulLife
//
//  Created by 罗海雄 on 17/9/2.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///在计算cell大小时，要先配置cell内容，否则无法准确计算cell大小
typedef void(^SeaTableCellConfiguration)(__kindof UITableViewCell *cell);
typedef void(^SeaTableHeaderFooterConfiguration)(__kindof UIView *headerOrFooter);

///cell高度
@interface UITableView (SeaRowHeight)

/**获取cell高度
 *@param identifier cell唯一标识
 *@param indexPath cell下标
 *@return cell 高度
 */
- (CGFloat)sea_rowHeightForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath configuration:(SeaTableCellConfiguration) configuration;


/**获取cell高度 主要用于静态cell，不重用的cell
 *@warning 如果使用静态的cell，刷新行时不要使用 reloadRows，使用reloadData
 *@param cell 要计算高度的cell
 *@param indexPath cell下标
 */
- (CGFloat)sea_rowHeightForCell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath;

/**获取cell高度 主要用于静态cell，不重用的cell
 *@warning 如果使用静态的cell，刷新行时不要使用 reloadRows，使用reloadData
 *@param cell 要计算高度的cell
 *@param indexPath cell下标
 *@return cell 高度
 */
- (CGFloat)sea_rowHeightForCell:(UITableViewCell*) cell indexPath:(NSIndexPath*) indexPath configuration:(SeaTableCellConfiguration) configuration;


/**获取header高度
 *@param identifier header唯一标识
 *@param section header下标
 *@return header 高度
 */
- (CGFloat)sea_headerHeightForIdentifier:(NSString*) identifier section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration;

/**获取header高度 主要用于静态 header，不重用的header
 *@warning 如果使用静态的header，刷新行时不要使用 reloadSections，使用reloadData
 *@param header 要计算高度的header
 *@param section header下标
 */
- (CGFloat)sea_heightForHeader:(UIView*) header section:(NSInteger) section;

/**获取header高度 主要用于静态 header，不重用的header
 *@warning 如果使用静态的header，刷新行时不要使用 reloadSections，使用reloadData
 *@param header 要计算高度的header
 *@param section header下标
 */
- (CGFloat)sea_heightForHeader:(UIView*) header section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration;

/**获取footer高度
 *@param identifier footer唯一标识
 *@param section footer下标
 *@return header 高度
 */
- (CGFloat)sea_footerHeightForIdentifier:(NSString*) identifier section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration;

/**获取footer高度 主要用于静态 footer，不重用的footer
 *@warning 如果使用静态的footer，刷新行时不要使用 reloadSections，使用reloadData
 *@param footer 要计算高度的footer
 *@param section footer下标
 */
- (CGFloat)sea_heightForFooter:(UIView*) footer section:(NSInteger) section;

/**获取footer高度 主要用于静态 footer，不重用的footer
 *@warning 如果使用静态的footer，刷新行时不要使用 reloadSections，使用reloadData
 *@param footer 要计算高度的footer
 *@param section footer下标
 */
- (CGFloat)sea_heightForFooter:(UIView*) footer section:(NSInteger) section configuration:(SeaTableHeaderFooterConfiguration) configuration;

@end
