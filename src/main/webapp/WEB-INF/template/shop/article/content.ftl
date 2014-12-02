<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
[@seo type = "articleContent"]
	<title>[#if article.seoTitle??]${article.seoTitle}[#elseif seo.title??][@seo.title?interpret /][/#if][#if systemShowPowered] - Powered By SHOP++[/#if]</title>
	<meta name="author" content="SHOP++ Team" />
	<meta name="copyright" content="SHOP++" />
	[#if article.seoKeywords??]
		<meta name="keywords" content="${article.seoKeywords}" />
	[#elseif seo.keywords??]
		<meta name="keywords" content="[@seo.keywords?interpret /]" />
	[/#if]
	[#if article.seoDescription??]
		<meta name="description" content="${article.seoDescription}" />
	[#elseif seo.description??]
		<meta name="description" content="[@seo.description?interpret /]" />
	[/#if]
[/@seo]
<link rel="stylesheet" type="text/css" href="${base}/resources/shop/css/index.css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $hits = $("#hits");

	// 查看点击数
	$.ajax({
		url: "${base}/article/hits/${article.id}.jhtml",
		type: "GET",
		success: function(data) {
			$hits.text(data);
		}
	});

});
</script>
</head>
<body>
	[#assign articleCategory = article.articleCategory /]
	[#include "/shop/include/header.ftl" /]
	<div class="container">
     	<div id="ur_here">
     		<a href="${base}/">${message("shop.path.home")}</a>
				[@article_category_parent_list articleCategoryId = articleCategory.id]
					[#list articleCategories as articleCategory]
						<code>&gt;</code><a href="${base}${articleCategory.path}">${articleCategory.name}</a>
					[/#list]
				[/@article_category_parent_list]
			<code>&gt;</code><a href="${base}${articleCategory.path}">${articleCategory.name}</a>
		</div>
    	<div class="article clearfix">
    	<div class="article-left">
			<dl>
				<dt>
					<a href="#">${message("shop.article.articleCategory")}</a>
				</dt>
				[@article_category_root_list count = 10]
					[#list articleCategories as category]
						<dd>
							<a href="${base}${category.path}">${category.name}</a>
						</dd>
					[/#list]
				[/@article_category_root_list]
			</dl>
		</div>
         <div class="article-right">
              <div class="article-content">
                  <h2 align="center">${article.title}[#if article.pageNumber > 1] (${article.pageNumber})[/#if]</h2>
                  <div class="info">
					${message("shop.article.createDate")}: ${article.createDate?string("yyyy-MM-dd HH:mm:ss")}
					${message("shop.article.author")}: ${article.author}
					${message("shop.article.hits")}: <span id="hits">&nbsp;</span>
				</div>
				${article.content}
					[@pagination pageNumber = article.pageNumber totalPages = article.totalPages pattern = "{pageNumber}.html"]
					[#include "/shop/include/pagination.ftl"]
				[/@pagination]
           </div>
         </div>
     </div>
 </div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>