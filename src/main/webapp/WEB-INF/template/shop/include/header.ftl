<script type="text/javascript">
$().ready(function() {

	var $headerLogin = $("#headerLogin");
	var $headerRegister = $("#headerRegister");
	var $headerUsername = $("#headerUsername");
	var $headerLogout = $("#headerLogout");
	var $productSearchForm = $("#productSearchForm");
	var $keyword = $("#productSearchForm input");
	var defaultKeyword = "${message("shop.header.keyword")}";
	
	var username = getCookie("username");
	if (username != null) {
		$headerUsername.text("${message("shop.header.welcome")}, " + username).show();
		$headerLogout.show();
	} else {
		$headerLogin.show();
		$headerRegister.show();
	}
	
	$keyword.focus(function() {
		if ($keyword.val() == defaultKeyword) {
			$keyword.val("");
		}
	});
	
	$keyword.blur(function() {
		if ($keyword.val() == "") {
			$keyword.val(defaultKeyword);
		}
	});
	
	$productSearchForm.submit(function() {
		if ($.trim($keyword.val()) == "" || $keyword.val() == defaultKeyword) {
			return false;
		}
	});

});
</script>

<div class="site-topbar">
    <div class="container">
        <div class="topbar-nav">
                               <a href="http://www.mi.com/"  >小米网</a>
                                   <span class="sep">|</span><a href="http://www.miui.com/"  target="_blank">MIUI</a>
                                   <span class="sep">|</span><a href="http://www.miliao.com/"  target="_blank">米聊</a>
                                   <span class="sep">|</span><a href="http://game.xiaomi.com/"  target="_blank">游戏</a>
                                   <span class="sep">|</span><a href="http://www.duokan.com/"  target="_blank">多看阅读</a>
                                   <span class="sep">|</span><a href="http://i.xiaomi.com/"  target="_blank">云服务</a>
                                   <span class="sep">|</span><a href="http://www.mi.com/c/appdownload/"  target="_blank">小米网移动版</a>
                                   <span class="sep">|</span><a href="javascript:void(0);"  class="J-modal-globalSites">Select region</a>
                        </div>
        <div class="topbar-info J_userInfo">
                                                    <a data-needlogin="true" href="http://order.mi.com/site/login?ac=1">登录</a>
                                    <span class="sep">|</span>                    <a  href="https://account.xiaomi.com/pass/register">注册</a>
                        </div>
    </div>
</div>
<!-- .site-topbar END -->

<div class="site-header container">
    <div class="site-logo">
        <a class="logo" href="http://www.mi.com/index.php" title="小米官网"><i class="iconfont">&#xe61d;</i></a>
            </div>
    <div class="header-info">
        <div class="search-section">
            <form id="J_searchForm" class="search-form clearfix" action="/search" method="get">
                <input class="search-text" type="search" name="keyword" autocomplete="off" data-search-config={'defaultWords':["小米手机3","红米手机","贴膜","后盖","耳机","电池","生活周边","挂饰","米兔"]} placeholder="搜索您需要的商品" />
                <input type="submit" class="search-btn iconfont" value="&#xe630;" />
                <!--[if IE 6]><div class="ie6-fix"></div><![endif]-->
                <div class="hot-words">
                	[#if setting.hotSearches?has_content]
						[#list setting.hotSearches as hotSearch]
							<a href="${base}/product/search.jhtml?keyword=${hotSearch?url}">${hotSearch}</a>
						[/#list]
					[/#if]
                 </div>
            </form>
        </div>
        <div class="cart-section">
            <a id="J_miniCart" class="mini-cart" href="http://order.mi.com/cart"><i class="iconfont">&#xe609;</i>购物车<span class="mini-cart-num J_cartNum"></span></a>
            <div id="J_miniCartList" class="mini-cart-list">
                <p class="loading">数据加载中，请稍后...</p>
            </div>
        </div>
    </div>
    <div class="header-nav clearfix">
        <div id="J_categoryContainer" class="nav-category">
            <a class="btn-category-list" href="http://www.mi.com/accessories">全部商品分类</a>
            <div class="nav-category-section" style="display: none;">
                <ul class="nav-category-list"></ul>
            </div>
        </div>
        <div class="nav-main">
            <ul class="nav-main-list J_menuNavMain clearfix">

        
                <li class="nav-main-item">
                    <a href="http://www.mi.com/index.php"><span class="text">首页</span></a>
                </li>
                
                <li class="nav-main-item">
                    <a href="javascript: void(0);"><span class="text">小米手机</span><span class="arrow"></span></a>
                    <div class="nav-main-children">
                        <ul class="children-list clearfix">
                        
                            <li class="first">
                                <a class="item-detail" href="http://www.mi.com/mi4">
                                    <span class="title" style="font-size:20px;">小米手机4</span>
                                    <span class="desc">工艺和手感，超乎想象</span>
                                    <span class="price"><b>1999</b>元起</span>
                                    <span class="thumb">
                                        <img src="Picture/nav-phone-mi4.jpg" srcset="http://img03.mifile.cn/webfile/images/2014/cn/nav/nav-phone-mi4_2x.jpg 2x" alt="小米手机3" width="160" height="160"/>
                                    </span>
                                </a>
                            </li>
                        
                            <li>
                                <a class="item-detail" href="http://www.mi.com/mi3">
                                    <span class="title" style="font-size:20px;">小米手机3</span>
                                    <span class="desc">经典旗舰机型性价比之王</span>
                                    <span class="price">特价：<b>1499</b>元起</span>
                                    <span class="thumb">
                                        <img src="Picture/nav-phone-mi3.jpg" srcset="http://img03.mifile.cn/webfile/images/2014/cn/nav/nav-phone-mi3_2x.jpg 2x" alt="小米手机3" width="160" height="160"/>
                                    </span>
                                </a>
                            </li>
                        
                        </ul>
                    </div>
                </li>
                
                <li class="nav-main-item">
                    <a href="javascript: void(0);"><span class="text">红米</span><span class="arrow"></span></a>
                    <div class="nav-main-children">
                        <ul class="children-list clearfix">
                        
                            <li class="first">
                                <a class="item-detail" href="http://www.mi.com/hongmi1s4g">
    <span class="title">红米1S 4G版</span>
    <span class="desc">千元4G手机性价比之王</span>
    <span class="price"><b>599</b>元起</span>
    <span class="thumb">
        <img src="Picture/nav-phone-hongmi.jpg" srcset="http://img03.mifile.cn/webfile/images/2014/cn/nav/nav-phone-hongmi_2x.jpg 2x" alt="红米手机" width="160" height="160"/>
    </span>
    <span class="desc">可选4G版 / 3G版</span>
</a>
                            </li>
                        
                            <li>
                                <a class="item-detail" href="http://www.mi.com/note4g">
    <span class="title">红米Note 4G版</span>
    <span class="desc">5.5英寸大屏，支持4G网络</span>
    <span class="price"><b>899</b>元</span>
    <span class="thumb">
        <img src="Picture/nav-phone-note.jpg" srcset="http://img03.mifile.cn/webfile/images/2014/cn/nav/nav-phone-note_2x.jpg 2x" alt="红米Note" width="160" height="160"/>
    </span>
</a>
                            </li>
                        
                        </ul>
                    </div>
                </li>
                
                <li class="nav-main-item">
                    <a href="http://www.mi.com/mipad"><span class="text">小米平板</span></a>
                </li>
                
                <li class="nav-main-item">
                    <a href="http://www.mi.com/mitv"><span class="text">小米电视</span></a>
                </li>
                
                <li class="nav-main-item">
                    <a href="http://www.mi.com/hezis"><span class="text">盒子</span></a>
                </li>
                
                <li class="nav-main-item">
                    <a href="javascript: void(0);"><span class="text">路由器</span><span class="arrow"></span></a>
                    <div class="nav-main-children">
                        <ul class="children-list clearfix">
                        
                            <li class="first">
                                <a class="item-detail" href="http://www.mi.com/miwifi">
                                    <span class="title">小米路由器</span>
                                    <span class="desc">顶配双频AC智能路由器<br>内置1TB大硬盘</span>
                                    <span class="price"><b>699</b>元</span>
                                    <span class="thumb">
                                        <img src="Picture/t17fyvbxwt1rxrhcrk!160x160.jpg"  alt="小米路由器" width="160" height="160"/>
                                    </span>
                                </a>
                            </li>
                        
                            <li>
                                <a class="item-detail" href="http://www.mi.com/miwifimini">
                                    <span class="title">小米路由器 mini</span>
                                    <span class="desc">主流双频AC智能路由器<br>性价比之王</span>
                                    <span class="price"><b>129</b>元</span>
                                    <span class="thumb">
                                        <img src="Picture/t1xsatbclt1rxrhcrk!160x160.jpg"  alt="小米路由器 mini" width="160" height="160"/>
                                    </span>
                                </a>
                            </li>
                        
                        </ul>
                    </div>
                </li>
                
                <li class="nav-main-item">
                    <a href="http://heyue.mi.com/"><span class="text">合约机</span></a>
                </li>
                
                <li class="nav-main-item">
                    <a href="http://www.mi.com/service"><span class="text">服务</span></a>
                </li>
                
                <li class="nav-main-item">
                    <a href="http://www.xiaomi.cn"><span class="text">社区</span></a>
                </li>
                            </ul>
        </div>
    </div>
    <div class="open-buy-info">
        <a href="http://hd.mi.com/webfile/zt/open/cn/index.html">11月18日预约开放购买</a>
    </div>
</div>
<!-- .site-header END --><!-- Main Content START -->


<div class="container header">
	<div class="span5">
		<div class="logo">
			<a href="${base}/">
				<img src="${setting.logo}" alt="${setting.siteName}" />
			</a>
		</div>
	</div>
	<div class="span9">
		[@ad_position id = 1 /]
	</div>
	<div class="span10 last">
		<div class="topNav clearfix">
			<ul>
				<li id="headerLogin" class="headerLogin">
					<a href="${base}/login.jhtml">${message("shop.header.login")}</a>|
				</li>
				<li id="headerRegister" class="headerRegister">
					<a href="${base}/register.jhtml">${message("shop.header.register")}</a>|
				</li>
				<li id="headerUsername" class="headerUsername"></li>
				<li id="headerLogout" class="headerLogout">
					<a href="${base}/logout.jhtml">[${message("shop.header.logout")}]</a>|
				</li>
				[@navigation_list position = "top"]
					[#list navigations as navigation]
						<li>
							<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
							[#if navigation_has_next]|[/#if]
						</li>
					[/#list]
				[/@navigation_list]
			</ul>
		</div>
		<div class="cart">
			<a href="${base}/cart/list.jhtml">${message("shop.header.cart")}</a>
		</div>
		[#if setting.phone??]
			<div class="phone">
				${message("shop.header.phone")}:
				<strong>${setting.phone}</strong>
			</div>
		[/#if]
	</div>
	<div class="span24">
		<ul class="mainNav">
			[@navigation_list position = "middle"]
				[#list navigations as navigation]
					<li[#if navigation.url = url] class="current"[/#if]>
						<a href="${navigation.url}"[#if navigation.isBlankTarget] target="_blank"[/#if]>${navigation.name}</a>
						[#if navigation_has_next]|[/#if]
					</li>
				[/#list]
			[/@navigation_list]
		</ul>
	</div>
	<div class="span24">
		<div class="tagWrap">
			<ul class="tag">
				[@tag_list type="product" count = 3]
					[#list tags as tag]
						<li[#if tag.icon??] class="icon" style="background: url(${tag.icon}) right no-repeat;"[/#if]>
							<a href="${base}/product/list.jhtml?tagIds=${tag.id}">${tag.name}</a>
						</li>
					[/#list]
				[/@tag_list]
			</ul>
			<div class="hotSearch">
				[#if setting.hotSearches?has_content]
					${message("shop.header.hotSearch")}:
					[#list setting.hotSearches as hotSearch]
						<a href="${base}/product/search.jhtml?keyword=${hotSearch?url}">${hotSearch}</a>
					[/#list]
				[/#if]
			</div>
			<div class="search">
				<form id="productSearchForm" action="${base}/product/search.jhtml" method="get">
					<input name="keyword" class="keyword" value="${productKeyword!message("shop.header.keyword")}" maxlength="30" />
					<button type="submit">${message("shop.header.search")}</button>
				</form>
			</div>
		</div>
	</div>
</div>