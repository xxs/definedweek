/*



 */
package com.xxs.definedweek.entity;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Entity - 导航
 * 


 */
@Entity
@Table(name = "xx_navigation")
@SequenceGenerator(name = "sequenceGenerator", sequenceName = "xx_navigation_sequence")
public class Navigation extends OrderEntity {

	private static final long serialVersionUID = -7635757647887646795L;

	/** 树路径分隔符 */
	public static final String TREE_PATH_SEPARATOR = ",";
	
	/**
	 * 位置
	 */
	public enum Position {

		/** 顶部 */
		top,

		/** 中间 */
		middle,

		/** 底部 */
		bottom
	}

	/** 名称 */
	private String name;

	/** 位置 */
	private Position position;
	
	/** 标签 icon */
	private String icon;

	/** 树路径 */
	private String treePath;

	/** 层级 */
	private Integer grade;
	
	/** 上级分类 */
	private Navigation parent;

	/** 下级分类 */
	private Set<Navigation> children = new HashSet<Navigation>();

	/** 链接地址 */
	private String url;

	/** 是否新窗口打开 */
	private Boolean isBlankTarget;
	
	/** 是否显示 */
	private Boolean isShow;

	/**
	 * 获取名称
	 * 
	 * @return 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	public String getName() {
		return name;
	}

	/**
	 * 设置名称
	 * 
	 * @param name
	 *            名称
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * 获取位置
	 * 
	 * @return 位置
	 */
	@NotNull
	@Column(nullable = false)
	public Position getPosition() {
		return position;
	}

	/**
	 * 设置位置
	 * 
	 * @param position
	 *            位置
	 */
	public void setPosition(Position position) {
		this.position = position;
	}

	/**
	 * 获取icon
	 * 
	 * @return 链接地址
	 */
	@Length(max = 200)
	@Column(nullable = false)
	public String getIcon() {
		return icon;
	}

	/**
	 * 设置icon
	 * 
	 * @param url
	 *            icon
	 */
	public void setIcon(String icon) {
		this.url = icon;
	}
	
	/**
	 * 获取链接地址
	 * 
	 * @return 链接地址
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	public String getUrl() {
		return url;
	}

	/**
	 * 设置链接地址
	 * 
	 * @param url
	 *            链接地址
	 */
	public void setUrl(String url) {
		this.url = url;
	}
	
	/**
	 * 获取树路径
	 * 
	 * @return 树路径
	 */
	@Column(nullable = false)
	public String getTreePath() {
		return treePath;
	}

	/**
	 * 设置树路径
	 * 
	 * @param treePath
	 *            树路径
	 */
	public void setTreePath(String treePath) {
		this.treePath = treePath;
	}

	/**
	 * 获取层级
	 * 
	 * @return 层级
	 */
	@Column(nullable = false)
	public Integer getGrade() {
		return grade;
	}

	/**
	 * 设置层级
	 * 
	 * @param grade
	 *            层级
	 */
	public void setGrade(Integer grade) {
		this.grade = grade;
	}
	
	/**
	 * 获取上级分类
	 * 
	 * @return 上级分类
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	public Navigation getParent() {
		return parent;
	}

	/**
	 * 设置上级分类
	 * 
	 * @param parent
	 *            上级分类
	 */
	public void setParent(Navigation parent) {
		this.parent = parent;
	}

	/**
	 * 获取下级分类
	 * 
	 * @return 下级分类
	 */
	@OneToMany(mappedBy = "parent", fetch = FetchType.LAZY)
	@OrderBy("order asc")
	public Set<Navigation> getChildren() {
		return children;
	}

	/**
	 * 设置下级分类
	 * 
	 * @param children
	 *            下级分类
	 */
	public void setChildren(Set<Navigation> children) {
		this.children = children;
	}

	/**
	 * 获取是否新窗口打开
	 * 
	 * @return 是否新窗口打开
	 */
	@NotNull
	@Column(nullable = false)
	public Boolean getIsBlankTarget() {
		return isBlankTarget;
	}

	/**
	 * 设置是否新窗口打开
	 * 
	 * @param isBlankTarget
	 *            是否新窗口打开
	 */
	public void setIsBlankTarget(Boolean isBlankTarget) {
		this.isBlankTarget = isBlankTarget;
	}
	
	/**
	 * 获取是否显示
	 * 
	 * @return 是否显示
	 */
	@NotNull
	@Column(nullable = false)
	public Boolean getIsShow() {
		return isShow;
	}

	/**
	 * 设置是否显示
	 * 
	 * @param isShow
	 *            是否显示
	 */
	public void setIsShow(Boolean isShow) {
		this.isShow = isShow;
	}
	
	/**
	 * 获取树路径
	 * 
	 * @return 树路径
	 */
	@Transient
	public List<Long> getTreePaths() {
		List<Long> treePaths = new ArrayList<Long>();
		String[] ids = StringUtils.split(getTreePath(), TREE_PATH_SEPARATOR);
		if (ids != null) {
			for (String id : ids) {
				treePaths.add(Long.valueOf(id));
			}
		}
		return treePaths;
	}

}