package com.xxs.definedweek.dao.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.persistence.FlushModeType;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import com.xxs.definedweek.dao.NavigationDao;
import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.entity.Navigation.Position;
import com.xxs.definedweek.entity.Product;

/**
 * Dao - 导航
 */
@Repository("navigationDaoImpl")
public class NavigationDaoImpl extends BaseDaoImpl<Navigation, Long> implements NavigationDao {

	public List<Navigation> findList(Position position) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Navigation> criteriaQuery = criteriaBuilder.createQuery(Navigation.class);
		Root<Navigation> root = criteriaQuery.from(Navigation.class);
		criteriaQuery.select(root);
		if (position != null) {
			criteriaQuery.where(criteriaBuilder.equal(root.get("position"), position));
		}
		criteriaQuery.orderBy(criteriaBuilder.asc(root.get("order")));
		return entityManager.createQuery(criteriaQuery).setFlushMode(FlushModeType.COMMIT).getResultList();
	}
	
	public List<Navigation> findRoots(Integer count) {
		String jpql = "select navigation from Navigation navigation where navigation.parent is null order by navigation.order asc";
		TypedQuery<Navigation> query = entityManager.createQuery(jpql, Navigation.class).setFlushMode(FlushModeType.COMMIT);
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}
	
	public List<Navigation> findRoots(Integer count,Position position) {
		String jpql = "select navigation from Navigation navigation where navigation.parent is null and navigation.position = "+ position.ordinal() +" order by navigation.order asc";
		TypedQuery<Navigation> query = entityManager.createQuery(jpql, Navigation.class).setFlushMode(FlushModeType.COMMIT);
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<Navigation> findParents(Navigation navigation, Integer count) {
		if (navigation == null || navigation.getParent() == null) {
			return Collections.<Navigation> emptyList();
		}
		String jpql = "select navigation from Navigation navigation where navigation.id in (:ids) order by navigation.grade asc";
		TypedQuery<Navigation> query = entityManager.createQuery(jpql, Navigation.class).setFlushMode(FlushModeType.COMMIT).setParameter("ids", navigation.getTreePaths());
		if (count != null) {
			query.setMaxResults(count);
		}
		return query.getResultList();
	}

	public List<Navigation> findChildren(Navigation navigation, Integer count) {
		TypedQuery<Navigation> query;
		if (navigation != null) {
			String jpql = "select navigation from Navigation navigation where navigation.treePath like :treePath order by navigation.order asc";
			query = entityManager.createQuery(jpql, Navigation.class).setFlushMode(FlushModeType.COMMIT).setParameter("treePath", "%" + Navigation.TREE_PATH_SEPARATOR + navigation.getId() + Navigation.TREE_PATH_SEPARATOR + "%");
		} else {
			String jpql = "select navigation from Navigation navigation order by navigation.order asc";
			query = entityManager.createQuery(jpql, Navigation.class).setFlushMode(FlushModeType.COMMIT);
		}
		if (count != null) {
			query.setMaxResults(count);
		}
		return sort(query.getResultList(), navigation);
	}

	/**
	 * 设置treePath、grade并保存
	 * 
	 * @param navigation
	 *            导航分类
	 */
	@Override
	public void persist(Navigation navigation) {
		Assert.notNull(navigation);
		setValue(navigation);
		super.persist(navigation);
	}

	/**
	 * 设置treePath、grade并更新
	 * 
	 * @param navigation
	 *            导航分类
	 * @return 导航分类
	 */
	@Override
	public Navigation merge(Navigation navigation) {
		Assert.notNull(navigation);
		setValue(navigation);
		for (Navigation category : findChildren(navigation, null)) {
			setValue(category);
		}
		return super.merge(navigation);
	}

	/**
	 * 清除导航属性值并删除
	 * 
	 * @param navigation
	 *            导航分类
	 */
	@Override
	public void remove(Navigation navigation) {
		if (navigation != null) {
			StringBuffer jpql = new StringBuffer("update Product product set ");
			for (int i = 0; i < Product.ATTRIBUTE_VALUE_PROPERTY_COUNT; i++) {
				String propertyName = Product.ATTRIBUTE_VALUE_PROPERTY_NAME_PREFIX + i;
				if (i == 0) {
					jpql.append("product." + propertyName + " = null");
				} else {
					jpql.append(", product." + propertyName + " = null");
				}
			}
			jpql.append(" where product.navigation = :navigation");
			entityManager.createQuery(jpql.toString()).setFlushMode(FlushModeType.COMMIT).setParameter("navigation", navigation).executeUpdate();
			super.remove(navigation);
		}
	}

	/**
	 * 排序导航分类
	 * 
	 * @param productCategories
	 *            导航分类
	 * @param parent
	 *            上级导航分类
	 * @return 导航分类
	 */
	private List<Navigation> sort(List<Navigation> productCategories, Navigation parent) {
		List<Navigation> result = new ArrayList<Navigation>();
		if (productCategories != null) {
			for (Navigation navigation : productCategories) {
				if ((navigation.getParent() != null && navigation.getParent().equals(parent)) || (navigation.getParent() == null && parent == null)) {
					result.add(navigation);
					result.addAll(sort(productCategories, navigation));
				}
			}
		}
		return result;
	}

	/**
	 * 设置值
	 * 
	 * @param navigation
	 *            导航分类
	 */
	private void setValue(Navigation navigation) {
		if (navigation == null) {
			return;
		}
		Navigation parent = navigation.getParent();
		if (parent != null) {
			navigation.setTreePath(parent.getTreePath() + parent.getId() + Navigation.TREE_PATH_SEPARATOR);
		} else {
			navigation.setTreePath(Navigation.TREE_PATH_SEPARATOR);
		}
		navigation.setGrade(navigation.getTreePaths().size());
	}

}