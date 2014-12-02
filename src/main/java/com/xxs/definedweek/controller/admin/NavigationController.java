package com.xxs.definedweek.controller.admin;

import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.xxs.definedweek.Message;
import com.xxs.definedweek.Pageable;
import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.entity.Navigation.Position;
import com.xxs.definedweek.service.ArticleCategoryService;
import com.xxs.definedweek.service.NavigationService;
import com.xxs.definedweek.service.ProductCategoryService;
import com.xxs.definedweek.service.TagService;

/**
 * Controller - 导航
 */
@Controller("adminNavigationController")
@RequestMapping("/admin/navigation")
public class NavigationController extends BaseController {

	@Resource(name = "navigationServiceImpl")
	private NavigationService navigationService;
	@Resource(name = "articleCategoryServiceImpl")
	private ArticleCategoryService articleCategoryService;
	@Resource(name = "productCategoryServiceImpl")
	private ProductCategoryService productCategoryService;
	@Resource(name = "tagServiceImpl")
	private TagService tagService;

	/**
	 * 添加
	 */
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(ModelMap model) {
		model.addAttribute("positions", Position.values());
		model.addAttribute("navigationTree",navigationService.findTree());
		model.addAttribute("articleCategoryTree", articleCategoryService.findTree());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "/admin/navigation/add";
	}

	/**
	 * 保存
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(Navigation navigation,Long parentId, RedirectAttributes redirectAttributes) {
		navigation.setParent(navigationService.find(parentId));
		if (!isValid(navigation)) {
			return ERROR_VIEW;
		}
		navigation.setTreePath(null);
		navigation.setGrade(null);
		navigation.setChildren(null);
		navigationService.save(navigation);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list.jhtml";
	}

	/**
	 * 编辑
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.GET)
	public String edit(Long id, ModelMap model) {
		model.addAttribute("positions", Position.values());
		model.addAttribute("navigationTree",navigationService.findTree());
		model.addAttribute("articleCategoryTree", articleCategoryService.findTree());
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("navigation", navigationService.find(id));
		return "/admin/navigation/edit";
	}

	/**
	 * 更新
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String update(Navigation navigation, Long parentId, RedirectAttributes redirectAttributes) {
		navigation.setParent(navigationService.find(parentId));
		if (!isValid(navigation)) {
			return ERROR_VIEW;
		}
		if (navigation.getParent() != null) {
			Navigation parent = navigation.getParent();
			if (parent.equals(navigation)) {
				return ERROR_VIEW;
			}
			List<Navigation> children = navigationService.findChildren(parent);
			if (children != null && children.contains(parent)) {
				return ERROR_VIEW;
			}
		}
		navigationService.update(navigation, "treePath", "grade", "children", "articles");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list.jhtml";
	}

	/**
	 * 列表
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("navigationTree",navigationService.findTree());
		model.addAttribute("topNavigations", navigationService.findList(Position.top));
		model.addAttribute("middleNavigations", navigationService.findList(Position.middle));
		model.addAttribute("bottomNavigations", navigationService.findList(Position.bottom));
		return "/admin/navigation/list";
	}

	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public @ResponseBody
	Message delete(Long[] ids) {
		for (int i = 0; i < ids.length; i++) {
			Navigation navigation = navigationService.find(ids[i]);
			if (navigation == null) {
				return ERROR_MESSAGE;
			}
			Set<Navigation> children = navigation.getChildren();
			if (children != null && !children.isEmpty()) {
				return Message.error("admin.navigation.deleteExistChildrenNotAllowed");
			}
			navigationService.delete(ids[i]);
		}
		return SUCCESS_MESSAGE;
	}

}