<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
[@seo type = "index"]
	<meta name="author" content="dedweek" />
	<meta name="copyright" content="dedweek 专业的模板销售网站" />
[/@seo]
<link rel="icon" href="${base}/favicon.ico" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="${base}/resources/shop/css/index.css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.lazyload.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<!--[if IE 6]>
<script src="http://www.xiaolajiao.com/themes/newxlj/script/DD_belatedPNG_0.0.8a.js"></script>
<script>
    /* EXAMPLE */
    DD_belatedPNG.fix('.slideBox .hd ul li,.xlj-footer .nums li span,.xlj-footer .col-links dd span,.xlj-footer .serive span,.xlj-header .xlj-header-nav li.nav-long span,.xlj-header .xlj-header-info .xlj-login span,.xlj-header .xlj-header-info .xlj-cart .cart,.goods-collect-btn1 span,.icon-star,.xlj-cart .xlj-cart-list .iconfont,.fitting-content h3 span,.xlj-address-list .item dd p a .address-del,.xlj-address-list .item dd p a .address-edit,.user-label li i,.shop-cart-box-none .cart-box,.pay-success .success-box,.pay-tip,.self-service .customer .customer-box h4 span,.self-service .customer .customer-box h4 span.tel,.xlj-address-list .use-new-addr .icon-add,.modal .close span');
</script>
<![endif]-->
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	<div class="xlj-nav container clearfix">
		<div class="xlj-left-nav">
        	<ul class="nav-left-list">
        			[@product_category_root_list count = 6]
							[#list productCategories as rootProductCategory]
								<li>
									<div class="nav-category-content">
									<a href="${base}${rootProductCategory.path}">${rootProductCategory.name}</a>
									<div class="links">
										[#list rootProductCategory.children as productCategory]
											<a href="${base}${productCategory.path}">${productCategory.name}</a>[#if productCategory_has_next]<span class="sep">|</span>[/#if]
										[/#list]	
									</div>
								</tr>
							[/#list]
						</table>
					[/@product_category_root_list]
			</ul>	
		</div>
		[@ad_position id = 3 /]
    </div> 
    <!-- 精品展示模块-->
     <div class="xlj-hot-product container clearfix">
        <div class="xlj-plain-box">
            <h3>精品模板</h3>
            <div class="box-bd">
                <div class="xlj-hot-product-list-wrap" >
					[@product_list count = 4]
						[#list products as product]
							<div class="xlj-product-item hot-product">
								<div class="item-content hot-product-hover">
									<a class="hot-img" href="${base}${product.path}" title="${product.name}" target="_blank">
										<img src="[#if product.image??]${product.image}[#else]${setting.defaultThumbnailProductImage}[/#if]" alt="${product.name}" />
									</a>
									<span class="item-title">${abbreviate(product.name, 24)}</span>
									<span class="item-desc">${abbreviate(product.name, 24)}</span>
									<span class="item-price">${currency(product.price, true)}</span>
									
									<span class="item-flag">热销</span>
									<!-- <span class="hot-logo"></span> -->
									
									<a class="item-buy" href="${base}${product.path}" target="_blank" >立即购买</a>
								</div>
							</div>	
						[/#list]
					[/@product_list]
				</div>
           	</div>
       	</div>
   	</div> 
    <!-- 新闻资讯 -->
    <div class="xlj-news-box container clearfix">
    	<div class="xlj-plain-box">
         	<h3>新闻资讯</h3>
            <div class="box-bd">
            	[@article_category_root_list count = 3]
					[#list articleCategories as category]
					<div class="xlj-news  [#if !category_has_next] xlj-news-last [/#if]">
						<a href="${base}${category.path}"><h4>${category.name}</h4></a>
						<ul>
							[@article_list articleCategoryId = category.id count = 6]
								[#list articles as article]
									[#if article_index == 6]
									[#break /]
								[/#if]
								<li>
									<a href="${base}${article.path}" title="${article.title}" target="_blank"><span class="dot">•</span>${abbreviate(article.title, 30)}</a>
								</li>
							[/#list]
						[/@article_list]
						</ul>
					</div>
					[/#list]
				[/@article_category_root_list]
            </div>
        </div>
    </div> 
	[#include "/shop/include/footer.ftl" /]
	<script>
		$(function(){
    		jQuery(".slideBox").slide({mainCell:".bd ul",autoPlay:true})
		})
    </script>
    <script src="${base}/resources/shop/js/base.min.js"></script>
    <script src="${base}/resources/shop/js/jquery.SuperSlide.2.1.1.js"></script>
</body>
</html>