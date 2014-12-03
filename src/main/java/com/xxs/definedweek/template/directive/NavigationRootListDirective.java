package com.xxs.definedweek.template.directive;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.xxs.definedweek.entity.Navigation;
import com.xxs.definedweek.entity.Navigation.Position;
import com.xxs.definedweek.service.NavigationService;
import com.xxs.definedweek.util.FreemarkerUtils;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;

/**
 * 模板指令 - 顶级导航分类列表
 */
@Component("navigationRootListDirective")
public class NavigationRootListDirective extends BaseDirective {

	/** "导航位置"参数名称 */
	private static final String POSITION_PARAMETER_NAME = "position";
	
	/** 变量名称 */
	private static final String VARIABLE_NAME = "navigations";

	@Resource(name = "navigationServiceImpl")
	private NavigationService navigationService;

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Position position = FreemarkerUtils.getParameter(POSITION_PARAMETER_NAME, Position.class, params);
		List<Navigation> productCategories;
		boolean useCache = useCache(env, params);
		String cacheRegion = getCacheRegion(env, params);
		Integer count = getCount(params);
		if (useCache) {
			if(!"".equals(position)){
				productCategories = navigationService.findRoots(count,position, cacheRegion);
			}else{
				productCategories = navigationService.findRoots(count, cacheRegion);
			}
		} else {
			if(!"".equals(position)){
				productCategories = navigationService.findRoots(count,position);
			}else{
				productCategories = navigationService.findRoots(count);
			}
		}
		setLocalVariable(VARIABLE_NAME, productCategories, env, body);
	}

}