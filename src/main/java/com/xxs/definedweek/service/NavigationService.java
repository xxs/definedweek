package com.xxs.definedweek.service;

import java.util.List;

import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.entity.Navigation.Position;

/**
 * Service - 导航
 */
public interface NavigationService extends BaseService<Navigation, Long> {

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
	 * @return 顶级导航分类
	 */
	List<Navigation> findRoots();

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
	 * @return 顶级导航分类
	 */
	List<Navigation> findRoots(Integer count,Position position);

	/**
	 * 查找顶级导航分类(缓存)
	 * 
	 * @param count
	 *            数量
	 * @param cacheRegion
	 *            缓存区域
	 * @return 顶级导航分类(缓存)
	 */
	List<Navigation> findRoots(Integer count, String cacheRegion);
	/**
	 * 查找顶级导航分类(缓存)
	 * 
	 * @param count
	 *            数量
	 * @param cacheRegion
	 *            缓存区域
	 * @return 顶级导航分类(缓存)
	 */
	List<Navigation> findRoots(Integer count,Position position, String cacheRegion);

	/**
	 * 查找上级导航分类
	 * 
	 * @param navigation
	 *            导航分类
	 * @return 上级导航分类
	 */
	List<Navigation> findParents(Navigation navigation);

	/**
	 * 查找上级导航分类
	 * 
	 * @param navigation
	 *            导航分类
	 * @param count
	 *            数量
	 * @return 上级导航分类
	 */
	List<Navigation> findParents(Navigation navigation, Integer count);

	/**
	 * 查找上级导航分类(缓存)
	 * 
	 * @param navigation
	 *            导航分类
	 * @param count
	 *            数量
	 * @param cacheRegion
	 *            缓存区域
	 * @return 上级导航分类(缓存)
	 */
	List<Navigation> findParents(Navigation navigation, Integer count, String cacheRegion);

	/**
	 * 查找导航分类树
	 * 
	 * @return 导航分类树
	 */
	List<Navigation> findTree();

	/**
	 * 查找下级导航分类
	 * 
	 * @param navigation
	 *            导航分类
	 * @return 下级导航分类
	 */
	List<Navigation> findChildren(Navigation navigation);

	/**
	 * 查找下级导航分类
	 * 
	 * @param navigation
	 *            导航分类
	 * @param count
	 *            数量
	 * @return 下级导航分类
	 */
	List<Navigation> findChildren(Navigation navigation, Integer count);

	/**
	 * 查找下级导航分类(缓存)
	 * 
	 * @param navigation
	 *            导航分类
	 * @param count
	 *            数量
	 * @param cacheRegion
	 *            缓存区域
	 * @return 下级导航分类(缓存)
	 */
	List<Navigation> findChildren(Navigation navigation, Integer count, String cacheRegion);


}