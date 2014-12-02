package com.xxs.definedweek.template.directive;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.xxs.definedweek.Filter;
import com.xxs.definedweek.Order;
import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.service.NavigationService;

import org.springframework.stereotype.Component;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

/**
 * 模板指令 - 导航列表
 */
@Component("navigationListDirective")
public class NavigationListDirective extends BaseDirective {

	/** 变量名称 */
	private static final String VARIABLE_NAME = "navigations";

	@Resource(name = "navigationServiceImpl")
	private NavigationService navigationService;

	//此处等待修改
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		List<Navigation> navigations;
		boolean useCache = useCache(env, params);
		String cacheRegion = getCacheRegion(env, params);
		Integer count = getCount(params);
		List<Filter> filters = getFilters(params, Navigation.class);
		List<Order> orders = getOrders(params);
		if (useCache) {
			//不清楚缓存为什么不能用了
			//navigations = navigationService.findList(count, filters, orders, cacheRegion);
			navigations = navigationService.findList(count, filters, orders);
		} else {
			navigations = navigationService.findList(count, filters, orders);
		}
		setLocalVariable(VARIABLE_NAME, navigations, env, body);
	}

}