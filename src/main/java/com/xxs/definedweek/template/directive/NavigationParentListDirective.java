package com.xxs.definedweek.template.directive;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.service.NavigationService;
import com.xxs.definedweek.util.FreemarkerUtils;

import org.springframework.stereotype.Component;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

/**
 * 模板指令 - 上级导航分类列表
 */
@Component("navigationParentListDirective")
public class NavigationParentListDirective extends BaseDirective {

	/** "导航分类ID"参数名称 */
	private static final String NAVIGATION_ID_PARAMETER_NAME = "navigationId";

	/** 变量名称 */
	private static final String VARIABLE_NAME = "navigations";

	@Resource(name = "navigationServiceImpl")
	private NavigationService navigationService;

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Long navigationId = FreemarkerUtils.getParameter(NAVIGATION_ID_PARAMETER_NAME, Long.class, params);

		Navigation navigation = navigationService.find(navigationId);

		List<Navigation> productCategories;
		if (navigationId != null && navigation == null) {
			productCategories = new ArrayList<Navigation>();
		} else {
			boolean useCache = useCache(env, params);
			String cacheRegion = getCacheRegion(env, params);
			Integer count = getCount(params);
			if (useCache) {
				productCategories = navigationService.findParents(navigation, count, cacheRegion);
			} else {
				productCategories = navigationService.findParents(navigation, count);
			}
		}
		setLocalVariable(VARIABLE_NAME, productCategories, env, body);
	}

}