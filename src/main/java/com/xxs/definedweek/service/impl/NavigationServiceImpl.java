/*



 */
package com.xxs.definedweek.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xxs.definedweek.Filter;
import com.xxs.definedweek.Order;
import com.xxs.definedweek.dao.NavigationDao;
import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.entity.Navigation.Position;
import com.xxs.definedweek.service.NavigationService;

/**
 * Service - 导航
 * 


 */
@Service("navigationServiceImpl")
public class NavigationServiceImpl extends BaseServiceImpl<Navigation, Long> implements NavigationService {

	@Resource(name = "navigationDaoImpl")
	private NavigationDao navigationDao;

	@Resource(name = "navigationDaoImpl")
	public void setBaseDao(NavigationDao navigationDao) {
		super.setBaseDao(navigationDao);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findList(Position position) {
		return navigationDao.findList(position);
	}

	@Transactional(readOnly = true)
	@Cacheable("navigation")
	public List<Navigation> findList(Integer count, List<Filter> filters, List<Order> orders, String cacheRegion) {
		return navigationDao.findList(null, count, filters, orders);
	}

	@Override
	@Transactional
	@CacheEvict(value = "navigation", allEntries = true)
	public void save(Navigation navigation) {
		super.save(navigation);
	}

	@Override
	@Transactional
	@CacheEvict(value = "navigation", allEntries = true)
	public Navigation update(Navigation navigation) {
		return super.update(navigation);
	}

	@Override
	@Transactional
	@CacheEvict(value = "navigation", allEntries = true)
	public Navigation update(Navigation navigation, String... ignoreProperties) {
		return super.update(navigation, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "navigation", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "navigation", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "navigation", allEntries = true)
	public void delete(Navigation navigation) {
		super.delete(navigation);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findRoots() {
		return navigationDao.findRoots(null);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findRoots(Integer count,Position position) {
		return navigationDao.findRoots(count,position);
	}
	
	@Transactional(readOnly = true)
	public List<Navigation> findRoots(Integer count) {
		return navigationDao.findRoots(count);
	}

	@Transactional(readOnly = true)
	@Cacheable("navigation")
	public List<Navigation> findRoots(Integer count, String cacheRegion) {
		return navigationDao.findRoots(count);
	}
	@Transactional(readOnly = true)
	@Cacheable("navigation")
	public List<Navigation> findRoots(Integer count,Position position, String cacheRegion) {
		return navigationDao.findRoots(count,position);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findParents(Navigation navigation) {
		return navigationDao.findParents(navigation, null);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findParents(Navigation navigation, Integer count) {
		return navigationDao.findParents(navigation, count);
	}

	@Transactional(readOnly = true)
	@Cacheable("navigation")
	public List<Navigation> findParents(Navigation navigation, Integer count, String cacheRegion) {
		return navigationDao.findParents(navigation, count);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findTree() {
		return navigationDao.findChildren(null, null);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findChildren(Navigation navigation) {
		return navigationDao.findChildren(navigation, null);
	}

	@Transactional(readOnly = true)
	public List<Navigation> findChildren(Navigation navigation, Integer count) {
		return navigationDao.findChildren(navigation, count);
	}

	@Transactional(readOnly = true)
	@Cacheable("navigation")
	public List<Navigation> findChildren(Navigation navigation, Integer count, String cacheRegion) {
		return navigationDao.findChildren(navigation, count);
	}

}