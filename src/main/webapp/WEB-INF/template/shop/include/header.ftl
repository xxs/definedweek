<script type="text/javascript">
$().ready(function() {

	var $headerLogin = $("#headerLogin");
	var $headerRegister = $("#headerRegister");
	var $headerUsername = $("#headerUsername");
	var $headerLogout = $("#headerLogout");
	var $productSearchForm = $("#productSearchForm");
	var $keyword = $(".search-input");
	var defaultKeyword = "${message("shop.header.keyword")}";
	
	var username = getCookie("username");
	if (username != null) {
		$headerUsername.text("${message("shop.header.welcome")}, " + username+"<span class'sep'>|</span>").show();
		$headerLogout.show();
	} else {
		$headerLogin.show();
		$headerRegister.show();
	}
	/*搜索框设置*/
	$keyword.focus(function(){
		$(".hot-search").hide();
	}).blur(function(){
		if($(this).val()==""){
			$(".hot-search").show();
		}
	})
	$productSearchForm.submit(function() {
		if ($.trim($keyword.val()) == "" || $keyword.val() == defaultKeyword) {
			return false;
		}
	});

});
</script>



<div class="site-topbar">
    <div class="container-top">
        <div class="topbar-nav">
            	[@navigation_list position = "top"]
					[#list navigations as navigation]
							<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
							[#if navigation_has_next]<span class="sep">|</span>[/#if]
					[/#list]
				[/@navigation_list]
            <div class="xlj-erweima" >
                <img src="themes/newxlj/images/erweima.jpg" width="86" height="86">
            </div>
        </div>
        <div class="xlj-login">
            <p>
            	<a href="${base}/login.jhtml"  id="headerLogin" class="headerLogin">${message("shop.header.login")}<span class="sep">|</span></a>
            	
            	<a href="${base}/register.jhtml" id="headerRegister" class="headerRegister">${message("shop.header.register")}<span class="sep">|</span></a>
            	
            	<a href="${base}/register.jhtml" id="headerUsername" class="headerUsername"></a>
            	
            	<a href="${base}/logout.jhtml" id="headerLogout" class="headerLogout">[${message("shop.header.logout")}]</a>
            </p>
        </div>
    </div>
</div>
	<div class="xlj-header container">
    	<div class="xlj-logo">
        	<a href="/">
        		<img src="${setting.logo}" alt="${setting.siteName}" />
        	</a>
        </div>
        <div class="xlj-header-info">
            <div id="xlj_cart_list" class="xlj-cart">
                <a href="flow.php" id="minCart" class="xlj-cart-off">
				<b class="cart"></b>购物车<span>(1)</span></a>
				<div id="ECS_CARTINFO" class="xlj-cart-list" style="display: none;">
					<ul>
						<li class="clearfix ">
						<a href="goods-118.html" class="pic"><img alt="红辣椒联通定制版3G手机（爽辣蓝）" src="http://image.xiaolajiao.com/images/201404/thumb_img/118_thumb_G_1396421240282.jpg?v=2014112001"></a>
						<a href="goods-118.html" class="name">红辣椒联通定制版3G手机（爽辣蓝...</a><span class="price">￥698.50元 x 1</span>
						<a class="btn-del delItem" href="javascript:void(0);" data-gid="207069"><i class="iconfont"></i></a>
						</li>
					</ul>
  					<div class="count clearfix">
       					<span class="total"><strong>合计：<em>￥698.50元</em></strong></span><a href="flow.php?step=checkout" class="btn btn-primary">去购物车结算</a>
  					</div>
				</div>
			</div>
            <div class="search">
                <form id="productSearchForm" class="xlj-search-form clearfix" action="${base}/product/search.jhtml" method="get">
                    <input class="search-input" type="search" name="keyword" autocomplete="off" maxlength="30" >
                    <label class="button-wrapper">
                        <input type="submit" class="search-btn iconfont" value="">
                    </label>
                    <div class="hot-search">
                    	[#if setting.hotSearches?has_content]
							[#list setting.hotSearches as hotSearch]
								<a href="${base}/product/search.jhtml?keyword=${hotSearch?url}">${hotSearch}</a>
								[#if hotSearch_has_next]<span class="sep">|</span>[/#if]
							[/#list]
						[/#if]
                    </div>
                </form>
            </div>
        </div>
        <ul class="xlj-header-nav clearfix">
        	<li class="nav-long"><span></span>全部模板分类</li>
			[@navigation_list position = "middle"]
				[#list navigations as navigation]
					<li[#if navigation.url = url] class="current"[/#if]>
						<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
						[#if navigation_index=2]<span class="hot-logo">hot !</span>[/#if]
					</li>
				[/#list]
			[/@navigation_list]
        </ul>
      </div> 