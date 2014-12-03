package com.xxs.definedweek.dao;

import java.util.List;

import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.entity.Navigation.Position;

/**
 * Dao - 导航
 */
public interface NavigationDao extends BaseDao<Navigation, Long> {

	/**
	 * 查找导航
	 * 
	 * @param position
	 *            位置
	 * @return 导航
	 */
	List<Navigation> findList(Position position);
	/**
	 * 查找顶级导航分类
	 * 
	 * @param count
	 *            数量
	 * @return 顶级导航分类
	 */
	List<Navigation> findRoots(Integer count);
	/**
	 * 查找顶级导航分类
	 * 
	 * @param count
	 *            数量
	 * @param position
	 *           位置
	 * @return 顶级导航分类
	 */
	List<Navigation> findRoots(Integer count,Position position);

	/**
	 * 查找上级导航分类
	 * 
	 * @param Navigation
	 *            导航分类
	 * @param count
	 *            数量
	 * @return 上级导航分类
	 */
	List<Navigation> findParents(Navigation Navigation, Integer count);

	/**
	 * 查找下级导航分类
	 * 
	 * @param Navigation
	 *            导航分类
	 * @param count
	 *            数量
	 * @return 下级导航分类
	 */
	List<Navigation> findChildren(Navigation Navigation, Integer count);

}