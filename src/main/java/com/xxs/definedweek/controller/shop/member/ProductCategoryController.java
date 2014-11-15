/*



 */
package com.xxs.definedweek.controller.shop.member;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.xxs.definedweek.controller.shop.BaseController;
import com.xxs.definedweek.entity.ProductCategory;
import com.xxs.definedweek.service.ProductCategoryService;

/**
 * Controller - 交互信息
 * 


 */
@Controller("shopMemberProductCategoryController")
@RequestMapping("/member/product_category")
public class ProductCategoryController extends BaseController {

	@Resource(name = "productCategoryServiceImpl")
	private ProductCategoryService productCategoryService;

	/**
	 * 首页
	 */
	@RequestMapping(method = RequestMethod.GET)
	public String index(ModelMap model) {
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("rootProductCategories", productCategoryService.findRoots());
		return "/shop/member/product_category/add";
	}
	/**
	 * 保存   这里考虑先不放置在分类中
	 * 应该只作为单纯的message
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public String save(ProductCategory productCategory, Long parentId, Long[] brandIds, RedirectAttributes redirectAttributes) {
		productCategory.setParent(productCategoryService.find(parentId));
		productCategory.setTreePath(null);
		productCategory.setGrade(null);
		productCategory.setChildren(null);
		productCategory.setProducts(null);
		productCategory.setParameterGroups(null);
		productCategory.setAttributes(null);
		productCategory.setPromotions(null);
		productCategoryService.save(productCategory);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "/shop/member/product_category/list";
	}
}