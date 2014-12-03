<div class="xlj-footer container clearfix">
    <ul class="nums clearfix">
		<li>
			<a href="/article-220.html" rel="nofollow"> <span class="nums1"></span> <strong> <label>3小时</label> 部署更高效 </strong> </a> 
		</li>
		<li>
			<a href="/article-220.html" rel="nofollow"> <span class="nums2"></span> <strong> <label>15天</label> 送15天服务 </strong> </a> 
		</li>
		<li>
			<a href="/article-213.html" rel="nofollow"> <span class="nums3"></span> <strong> <label>12个双十一</label> 限时模板优惠 </strong> </a> 
		</li>
		<li class="last">
			<a href="/poststation.html" rel="nofollow"> <span class="nums4"></span> <strong> <label>全系统</label> 更多技术选型 </strong> </a> 
		</li>
	</ul>
	<div class="footer-links clearfix">
		[@navigation_root_list count = 5 position = "bottom"]
			[#list navigations as rootNavigation]
			<dl class="col-links col-links-first">
				<dt>
					<a href="${base}${rootNavigation.path}">${rootNavigation.name}</a>
				</dt>
				[#list rootNavigation.children as navigation]
					<dd>
						<a rel="nofollow" href="${base}${navigation.path}">${navigation.name}</a>
					</dd>
				[/#list]	
			</dl>
			[/#list]
		[/@navigation_root_list]
		<div class="col-contact">
			<p class="phone">400-888-888888</p>
			<p>仅收市话费，周一至周日9:00-21:00</p>
			<a rel="nofollow" class="serive" href="#" target="_blank" ><span></span>在线客服</a> 
		</div>
	</div>        
	<div class="info ">
		 <li></li>
			© <a href="http://www.dedweek.com">dedweek官网</a> xxxxxxxxxxxxxxxxxxxxxxxx
			<p>版权所有：dedweek 小小工作室 来自 自定义星期天 的支持 </p>
		[#include "/shop/include/statistics.ftl" /]
	</div>
</div>
