<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
[@seo type = "productContent"]
	<title>[#if product.seoTitle??]${product.seoTitle}[#elseif seo.title??][@seo.title?interpret /][/#if][#if systemShowPowered] - Powered By SHOP++[/#if]</title>
	<meta name="author" content="SHOP++ Team" />
	<meta name="copyright" content="SHOP++" />
	[#if product.seoKeywords??]
		<meta name="keywords" content="${product.seoKeywords}" />
	[#elseif seo.keywords??]
		<meta name="keywords" content="[@seo.keywords?interpret /]" />
	[/#if]
	[#if product.seoDescription??]
		<meta name="description" content="${product.seoDescription}" />
	[#elseif seo.description??]
		<meta name="description" content="[@seo.description?interpret /]" />
	[/#if]
[/@seo]
<link href="${base}/resources/shop/css/index.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.jqzoom.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.SuperSlide.2.1.1.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.lazyload.min.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/product.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $historyProduct = $("#historyProduct ul");
	var $clearHistoryProduct = $("#clearHistoryProduct");
	var $zoom = $("#zoom");
	var $scrollable = $("#scrollable");
	var $thumbnail = $("#scrollable a");
	var $specification = $("#specification dl");
	var $specificationTitle = $("#specification div");
	var $specificationValue = $("#specification a");
	var $quantity = $("#quantity");
	var $increase = $("#increase");
	var $decrease = $("#decrease");
	var $addCart = $("#addCart");
	var $addFavorite = $("#addFavorite");
	var $window = $(window);
	var $bar = $("#bar ul");
	var $introductionTab = $("#introductionTab");
	var $parameterTab = $("#parameterTab");
	var $reviewTab = $("#reviewTab");
	var $consultationTab = $("#consultationTab");
	var $introduction = $("#introduction");
	var $parameter = $("#parameter");
	var $review = $("#review");
	var $addReview = $("#addReview");
	var $consultation = $("#consultation");
	var $addConsultation = $("#addConsultation");
	var barTop = $bar.offset().top;
	var productMap = {};
	[@compress single_line = true]
		productMap[${product.id}] = {
			path: null,
			specificationValues: [
				[#list product.specificationValues as specificationValue]
					"${specificationValue.id}"[#if specificationValue_has_next],[/#if]
				[/#list]
			]
		};
		[#list product.siblings as product]
			productMap[${product.id}] = {
				path: "${product.path}",
				specificationValues: [
					[#list product.specificationValues as specificationValue]
						"${specificationValue.id}"[#if specificationValue_has_next],[/#if]
					[/#list]
				]
			};
		[/#list]
	[/@compress]
	
	// 锁定规格值
	lockSpecificationValue();
	
	// 商品缩略图滚动
	$scrollable.scrollable();
	
	$thumbnail.hover(function() {
		var $this = $(this);
		if ($this.hasClass("current")) {
			return false;
		} else {
			$thumbnail.removeClass("current");
			$this.addClass("current").click();
		}
	});
	
	// 规格值选择
	$specificationValue.click(function() {
		var $this = $(this);
		if ($this.hasClass("locked")) {
			return false;
		}
		$this.toggleClass("selected").parent().siblings().children("a").removeClass("selected");
		var selectedIds = new Array();
		$specificationValue.filter(".selected").each(function(i) {
			selectedIds[i] = $(this).attr("val");
		});
		var locked = true;
		$.each(productMap, function(i, product) {
			if (product.specificationValues.length == selectedIds.length && contains(product.specificationValues, selectedIds)) {
				if (product.path != null) {
					location.href = "${base}" + product.path;
					locked = false;
				}
				return false;
			}
		});
		if (locked) {
			lockSpecificationValue();
		}
		$specificationTitle.hide();
		return false;
	});
	
	// 锁定规格值
	function lockSpecificationValue() {
		var selectedIds = new Array();
		$specificationValue.filter(".selected").each(function(i) {
			selectedIds[i] = $(this).attr("val");
		});
		$specification.each(function() {
			var $this = $(this);
			var selectedId = $this.find("a.selected").attr("val");
			var otherIds = $.grep(selectedIds, function(n, i) {
				return n != selectedId;
			});
			$this.find("a").each(function() {
				var $this = $(this);
				otherIds.push($this.attr("val"));
				var locked = true;
				$.each(productMap, function(i, product) {
					if (contains(product.specificationValues, otherIds)) {
						locked = false;
						return false;
					}
				});
				if (locked) {
					$this.addClass("locked");
				} else {
					$this.removeClass("locked");
				}
				otherIds.pop();
			});
		});
	}
	
	// 判断是否包含
	function contains(array, values) {
		var contains = true;
		for(i in values) {
			if ($.inArray(values[i], array) < 0) {
				contains = false;
				break;
			}
		}
		return contains;
	}
	
	// 加入购物车
	$addCart.click(function() {
		[#if product.specifications?has_content]
			var specificationValueIds = new Array();
			$specificationValue.filter(".selected").each(function(i) {
				specificationValueIds[i] = $(this).attr("val");
			});
			if (specificationValueIds.length != ${product.specificationValues?size}) {
				$specificationTitle.show();
				return false;
			}
		[/#if]
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity) && parseInt(quantity) > 0) {
			$.ajax({
				url: "${base}/cart/add.jhtml",
				type: "POST",
				data: {id: ${product.id}, quantity: quantity},
				dataType: "json",
				cache: false,
				success: function(message) {
					$.message(message);
				}
			});
		} else {
			$.message("warn", "${message("shop.product.quantityPositive")}");
		}
	});
	
	// 添加商品收藏
	$addFavorite.click(function() {
		$.ajax({
			url: "${base}/member/favorite/add.jhtml?id=${product.id}",
			type: "POST",
			dataType: "json",
			cache: false,
			success: function(message) {
				$.message(message);
			}
		});
		return false;
	});
	
	$window.scroll(function() {
		var scrollTop = $(this).scrollTop();
		if (scrollTop > barTop) {
			if (window.XMLHttpRequest) {
				$bar.css({position: "fixed", top: 0});
			} else {
				$bar.css({top: scrollTop});
			}
			var introductionTop = $introduction.size() > 0 ? $introduction.offset().top - 36 : null;
			var parameterTop = $parameter.size() > 0 ? $parameter.offset().top - 36 : null;
			var reviewTop = $review.size() > 0 ? $review.offset().top - 36 : null;
			var consultationTop = $consultation.size() > 0 ? $consultation.offset().top - 36 : null;
			if (consultationTop != null && scrollTop >= consultationTop) {
				$bar.find("li").removeClass("current");
				$consultationTab.addClass("current");
			} else if (reviewTop != null && scrollTop >= reviewTop) {
				$bar.find("li").removeClass("current");
				$reviewTab.addClass("current");
			} else if (parameterTop != null && scrollTop >= parameterTop) {
				$bar.find("li").removeClass("current");
				$parameterTab.addClass("current");
			} else if (introductionTop != null && scrollTop >= introductionTop) {
				$bar.find("li").removeClass("current");
				$introductionTab.addClass("current");
			}
		} else {
			$bar.find("li").removeClass("current");
			$bar.css({position: "absolute", top: barTop});
		}
	});
	
	[#if setting.isReviewEnabled && setting.reviewAuthority != "anyone"]
		// 发表商品评论
		$addReview.click(function() {
			if ($.checkLogin()) {
				return true;
			} else {
				$.redirectLogin("${base}/review/add/${product.id}.jhtml", "${message("shop.product.addReviewNotAllowed")}");
				return false;
			}
		});
	[/#if]
	
	[#if setting.isConsultationEnabled && setting.consultationAuthority != "anyone"]
		// 发表商品咨询
		$addConsultation.click(function() {
			if ($.checkLogin()) {
				return true;
			} else {
				$.redirectLogin("${base}/consultation/add/${product.id}.jhtml", "${message("shop.product.addConsultationNotAllowed")}");
				return false;
			}
		});
	[/#if]
	
	// 浏览记录
	var historyProduct = getCookie("historyProduct");
	var historyProductIds = historyProduct != null ? historyProduct.split(",") : new Array();
	for (var i = 0; i < historyProductIds.length; i ++) {
		if (historyProductIds[i] == "${product.id}") {
			historyProductIds.splice(i, 1);
			break;
		}
	}
	historyProductIds.unshift("${product.id}");
	if (historyProductIds.length > 6) {
		historyProductIds.pop();
	}
	addCookie("historyProduct", historyProductIds.join(","), {path: "${base}/"});
	$.ajax({
		url: "${base}/product/history.jhtml",
		type: "GET",
		data: {ids: historyProductIds},
		dataType: "json",
		traditional: true,
		cache: false,
		success: function(data) {
			$.each(data, function (index, product) {
				var thumbnail = product.thumbnail != null ? product.thumbnail : "${setting.defaultThumbnailProductImage}";
				$historyProduct.append('<li><img src="' + thumbnail + '" \/><a href="${base}' + product.path + '">' + product.name + '<\/a><span>' + currency(product.price, true) + '<\/span><\/li>');
			});
		}
	});
	
	// 清空浏览记录
	$clearHistoryProduct.click(function() {
		$historyProduct.empty();
		$(this).text("${message("shop.product.noHistoryProduct")}");
		removeCookie("historyProduct", {path: "${base}/"});
	});
	
	// 点击数
	$.ajax({
		url: "${base}/product/hits/${product.id}.jhtml",
		type: "GET"
	});
	
});
</script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
	[#assign productCategory = product.productCategory /]
<div class="container clearfix" id="loadinfos">
 <div id="ur_here">
	<a href="${base}/">${message("shop.path.home")}</a>
		[@product_category_parent_list productCategoryId = productCategory.id]
			[#list productCategories as productCategory]
				<code>&gt;</code><a href="${base}${productCategory.path}">${productCategory.name}</a>
			[/#list]
		[/@product_category_parent_list]
			<code>&gt;</code><a href="${base}${productCategory.path}">${productCategory.name}</a>
		<code>&gt;</code><a href="#">${product.name}</a>
 </div>
<div id="goodsInfo" class="clearfix">
<div class="imgInfo">
<div class="imgInfo_img">
    <ul>
    	[#if product.productImages?has_content]
							[#list product.productImages as productImage]
								<li><a[#if productImage_index == 0] class="current"[/#if] href="javascript:;"><img src="${productImage.thumbnail}" title="${productImage.title}" /></a></li>
							[/#list]
						[#else]
							<li><a class="current" href="javascript:;"><img src="${setting.defaultThumbnailProductImage}" /></a></li>
						[/#if]
              </ul>
   </div>
    <div class="picture" id="imglist">
    	[#if product.productImages?has_content]
							[#list product.productImages as productImage]
								<a href="javascript:;"><img src="${productImage.thumbnail}" title="${productImage.title}" class="onbg" /></a>
							[/#list]
						[#else]
							<a href="javascript:;"><img src="${setting.defaultThumbnailProductImage}" class="onbg" /></a>
						[/#if]
           </div>
    <span id="goodsPicPrev" title="上一张" class="icon-slides icon-slides-prev" style="height: 460px;">上一张</span> <span id="goodsPicNext" title="下一张" class="icon-slides icon-slides-next" style="height: 460px;">下一张</span> </div>
         <div class="textInfo">
    <div class="clearfix">
    <div class="text">
     <div class="text_l" style=""><h1>${product.name}[#if product.isGift] [${message("shop.product.gifts")}][/#if]</h1></div>
     
      </div>
      <p class="goods-info-phone" ><font color="red">
      
      		[#if product.validPromotions?has_content]
					[#list product.validPromotions as promotion]
							${promotion.name} [#if promotion.beginDate?? || promotion.endDate??] 活动时间：${promotion.beginDate} ~ ${promotion.endDate} [/#if]
					[/#list]
			[/#if]
      </font></p> 
      <div class="dd">
      <p> 价<span style="margin-left:27px;"></span>格：<b class="price-num" >￥${product.price}元</b></p>
            <p>商品评价：
            	<span style="text-decoration:none; padding-left:8px;margin-top:-5px" class="goodsToComment icon-star icon-star-${(product.score * 2)?string("0")}"> </span>
            	<span style="cursor:pointer;" id="view_comment_count">(共${product.scoreCount}人评价)</span>
       </p>
          <p>服<span style="margin-left:27px;"></span>务：此模板售出后15天为服务期，提供即时咨询服务</p>
      </div> 
     </div>
      <div style=" clear:both"></div>
      
      <div class="goods-info-color dd clearfix">
            <p>可<span style="margin-left:27px;"></span>选：</p>
            <ul>
              <li class="select-on" title="银莲白"><a data-gid="180" href="javascript:void(0)">银莲白</a></li><li title="青木黑"><a data-gid="181" href="javascript:void(0)">青木黑</a></li>            </ul>
       </div>
      
      [#if product.specifications?has_content]
			<div id="specification" class=" clearfix">
					[#assign specificationValues = product.goods.specificationValues /]
						[#list product.specifications as specification]
						<div class="goods-info-color dd clearfix">
            				<p>${abbreviate(specification.name, 8)}：</p>
            				<ul>
            				[#list specification.specificationValues as specificationValue]
									[#if specificationValues?seq_contains(specificationValue)]
										<li class="select-on" title="${specificationValue.name}">
              								<a href="javascript:;" class="${specification.type}[#if product.specificationValues?seq_contains(specificationValue)] selected[/#if]" val="${specificationValue.id}">[#if specification.type == "text"]${specificationValue.name}[#else]<img src="${specificationValue.image}" alt="${specificationValue.name}" title="${specificationValue.name}" />[/#if]<span title="${message("shop.product.selected")}">&nbsp;</span></a>
              							</li>
									[/#if]
							[/#list]
              				</ul>
						[/#list]
					</div>
				[/#if]
           <div style="clear:both"></div>
       <ul class="dd  clearfix">  
      <li>
      	<a class="btn btn-primary btn_fp" id="addCart" href="javascript:void(0);" data-gid="118" data-cid="38" data-thumb="http://image.xiaolajiao.com/images/201404/thumb_img/118_thumb_G_1396421240282.jpg?v=20141202">
                    	立即购买
        </a>
        <a class="goods-collect-btn1" id="Favorites" data-gid="118" href="javascript:void(0)"><span></span> </a>
      </li>
      </ul>
     </div>
   </div>
   <div class="blank"></div>
  <div class="xlj-prodesc">
        <div class="goods-desc-menu">
             <ul class="hd clearfix">
                 <li class="first"><a href="#productDetail">产品详情</a> </li>
                 <li><a href="#specifications">规格参数</a></li>
                 <li><a href="#userRating">用户评价<span>(${product.scoreCount})</span></a> </li>
                 <li><a href="#Service">售后服务</a></li>
                                  <li><a href="#FAQs">常见问题</a></li>
                            </ul>
        </div>
      <div class="xlj-desc-box">
        
      <div class="xlj-box" >
          <div class="xlj-good-desc">
               ${product.introduction}
          </div>
      </div>
        <div class="xlj-box">
                <div class="bd">
                   [#if product.parameterValue?has_content]
                    <div style="padding-top: 20px;">声明：使用此模板如有商业用途，请先到各大系统提供商资讯商业授权事宜，许可后方可使用</div>
                    <div class="godds-desc-par">
                                
                                            
                      <table border="0" cellpadding="3" cellspacing="1" bgcolor="#dddddd" class="sp_talbe">
                      [#list productCategory.parameterGroups as parameterGroups]
                        <tr>
                          <th colspan="2" bgcolor="#FF00FF">${parameterGroups.name}</th>
                       	[#list parameterGroups.parameters as parameter]
								[#if product.parameterValue.get(parameter)??]
									<tr>
										<td bgcolor="#FFFFFF" align="right" width="20%" class="f1">${parameter.name}</td>
										<td bgcolor="#FFFFFF" align="left" width="80%">${product.parameterValue.get(parameter)}</td>
									</tr>
								[/#if]
							[/#list]
							[/#list]
                        </table>
                    </div>
                </div>
        </div>
			[/#if]        
        
         
        <div class="xlj-box" id="UserEvaluation">
            <div class="hd evaluation">
                    <div class="mc">
                         <div id="i-comment">   
                             <div class="rate">
                                <strong>${product.score?string("0.0")}</strong> <br> 
                                <span>好评度</span>  
                             </div>
                             <div class="percent">
                                <dl>
                                    <dt>好评<span>(93%)</span></dt>
                                    <dd> <div style="width: 93%;"></div></dd>
                                </dl>
                                <dl>
                                    <dt>中评<span>(2%)</span></dt>
                                    <dd class="d1"><div style="width: 2%;"> </div></dd> 
                               </dl>
                               <dl>
                                    <dt>差评<span>(5%)</span></dt>
                                    <dd class="d1"><div style="width: 5%;"> </div></dd>
                               </dl>
                            </div>   
                             <div class="actor-new">  
                                                                <dl>            
                                    <dt>买家印象：</dt>            
                                    <dd class="p-bfc">
                                                                             <span class="comm-tags">外观漂亮</span>
                                                                             <span class="comm-tags">性价比高</span>
                                                                             <span class="comm-tags">功能齐全</span>
                                                                             <span class="comm-tags">系统流畅</span>
                                                                             <span class="comm-tags">支持国产机</span>
                                                                             <span class="comm-tags">信号稳定</span>
                                                                             <span class="comm-tags">反应快</span>
                                                                             <span class="comm-tags">通话质量好</span>
                                                                        </dd>       
                                </dl>
                              
                            <div class="clr"></div> <b></b>    </div>   
                             <div class="btns">
                             <a href="#consultForm"> <i></i>发表评价</a>
                             <span class="hl_red">只有购买成功的用户才能评价</span>
                              </div>
                              </div>                   
                        </div>
                        <ul class="all-percent" id="percentComment">
                                <li class="on" data-code="AllPercent" data-num="88">全部评价（88）</li>
                                <li data-code="GoodPercent" data-num="82">好评（82）</li>
                                <li data-code="GeneralPercent" data-num="2">中评（2）</li>
                                <li data-code="BadPercent" class="last" data-num="4">差评（4）</li>
                        </ul>
                </div>
                
                <div class="bd">
                     <div class="goods-percent-list">
                        <div class="goods-percent">
                            <ul id="AllPercent" class="clearfix ">
                                                        <li><div class="user-precent-left">
                <img class="np-avatar" src="http://account.xiaolajiao.com/uc_server/avatar.php?uid=139211&size=big" alt="头像">
                <span>faye99129</span></div>
                <div class="user-precent-right"><div class="user-precent-header">
                <span class="icon-star icon-star-5 left"></span><span class="user-date right">2014-11-13 20:10:00</span></div>
                  <div class="user-precent-content"><p>帮别人买的，全贴合屏幕效果很好，挺流畅的</p></div></div></li><li><div class="user-precent-left">
                <img class="np-avatar" src="http://account.xiaolajiao.com/uc_server/avatar.php?uid=849788&size=big" alt="头像">
                <span>飞翔喜神</span></div>
                <div class="user-precent-right"><div class="user-precent-header">
                <span class="icon-star icon-star-5 left"></span><span class="user-date right">2014-11-13 18:10:00</span></div>
                  <div class="user-precent-content"><p>终于买到了，真的不错！上网快屏幕够大！</p></div></div></li><li><div class="user-precent-left">
                <img class="np-avatar" src="http://account.xiaolajiao.com/uc_server/avatar.php?uid=437110&size=big" alt="头像">
                <span>bzlichuang</span></div>
                <div class="user-precent-right"><div class="user-precent-header">
                <span class="icon-star icon-star-5 left"></span><span class="comm-tags-on">系统流畅</span><span class="comm-tags-on">外观漂亮</span><span class="comm-tags-on">功能齐全</span><span class="user-date right">2014-11-10 14:50:00</span></div>
                  <div class="user-precent-content"><p>这个价位物有所值，很满意。给个赞！</p></div></div></li><li><div class="user-precent-left">
                <img class="np-avatar" src="http://account.xiaolajiao.com/uc_server/avatar.php?uid=722870&size=big" alt="头像">
                <span>需要温暖</span></div>
                <div class="user-precent-right"><div class="user-precent-header">
                <span class="icon-star icon-star-5 left"></span><span class="user-date right">2014-11-09 21:42:00</span></div>
                  <div class="user-precent-content"><p>支持国产、用着还行、很轻、很方便</p></div></div></li><li><div class="user-precent-left">
                <img class="np-avatar" src="http://account.xiaolajiao.com/uc_server/avatar.php?uid=910989&size=big" alt="头像">
                <span>LINMINGL</span></div>
                <div class="user-precent-right"><div class="user-precent-header">
                <span class="icon-star icon-star-5 left"></span><span class="user-date right">2014-11-09 16:11:00</span></div>
                  <div class="user-precent-content"><p>很轻薄，屏幕大，分辨率又高，照相清晰，运行的快</p></div></div></li>                                                        </ul>
                        </div>
                                                <div class="more">查看更多评论&gt;&gt;</div>
                        <input name="more_num" type="hidden" id="more_num" value="5" />
                        <input name="comment_type" type="hidden" id="comment_type" value="0" />
                                                <div class="consulting">
                         <form action="javascript:;" onsubmit="submitComment(this)" method="post" name="consultForm" id="consultForm">
                                <table>
                                    <tr>
                                        <td  class="table-left">评分：</td>
                                        <td>
                                            <input name="comment_rank" type="radio" value="5" id="comment_rank5" checked="checked" > <label for="comment_rank5"><span class=" icon-star icon-star-5"></span></label>
                                            <input name="comment_rank" type="radio" value="4" id="comment_rank4"> <label for="comment_rank4"><span class=" icon-star icon-star-4"></span></label>
                                            <input name="comment_rank" type="radio" value="3" id="comment_rank3"> <label for="comment_rank3"><span class=" icon-star icon-star-3"></span></label>
                                            <input name="comment_rank" type="radio" value="2" id="comment_rank2"> <label for="comment_rank2"><span class=" icon-star icon-star-2"></span></label>
                                            <input name="comment_rank" type="radio" value="1" id="comment_rank1"> <label for="comment_rank1"><span class=" icon-star icon-star-1"></span></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="table-left">标签：</td>
                                        <td>
                                            <ul class="user-label">
                                                                                                                                        <li><input id="userLabel0" type="checkbox" name="items" value="72" /><label for="userLabel0">系统流畅</label></li>
                                                                                            <li><input id="userLabel1" type="checkbox" name="items" value="73" /><label for="userLabel1">外观漂亮</label></li>
                                                                                            <li><input id="userLabel2" type="checkbox" name="items" value="74" /><label for="userLabel2">功能齐全</label></li>
                                                                                            <li><input id="userLabel3" type="checkbox" name="items" value="75" /><label for="userLabel3">性价比高</label></li>
                                                                                            <li><input id="userLabel4" type="checkbox" name="items" value="76" /><label for="userLabel4">信号稳定</label></li>
                                                                                            <li><input id="userLabel5" type="checkbox" name="items" value="77" /><label for="userLabel5">电池耐用</label></li>
                                                                                            <li><input id="userLabel6" type="checkbox" name="items" value="78" /><label for="userLabel6">反应快</label></li>
                                                                                            <li><input id="userLabel7" type="checkbox" name="items" value="79" /><label for="userLabel7">支持国产机</label></li>
                                                                                            <li><input id="userLabel8" type="checkbox" name="items" value="80" /><label for="userLabel8">通话质量好</label></li>
                                                                                                                                        <li id="CustomLabel"><i></i>自定义</li>
                                                <li id="CustomSubmit">提交</li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="table-left">心得：</td>
                                        <td><textarea name="content" id="ConsultContent" maxlength="300" ></textarea></td>
                                        
                                    </tr>
                                     <tr>
                                        <td></td>
                                        <td><input class="submit" type="submit" name="submit" id="ContentSub" value="提交评论" data-val="0" /></td>
                                    </tr>
                                </table>
                          </form>
                      </div>
                     </div>
                </div>
            </div>
        
         
        <div class="xlj-box" id="GoodsService">
        <div class="hd goods-service">
	<h2>
		小辣椒承诺
	</h2>
	<p class="img">
		<img alt="" src="http://image.xiaolajiao.com/images/upload/image/20140823/20140823153406_33447.jpg" /> 
	</p>
</div>
<div class="hd goods-service">
	<h2>
		关于物流
	</h2>
	<p class="img">
		<img alt="" src="http://image.xiaolajiao.com/images/upload/image/20140823/20140823153351_15134.jpg" /> 
	</p>
</div>
<div class="hd goods-service">
	<h2>
		关于发票
	</h2>
	<p class="img">
		<img alt="" src="http://image.xiaolajiao.com/images/upload/image/20140823/20140823153240_30608.jpg" /> 
	</p>
</div>
<div class="hd goods-service">
	<h2>
		关于小辣椒
	</h2>
	<p>
		小辣椒成立于2012年2月，小辣椒智能手机是深圳语信时代通信设备有限公司旗下的互联网手机品牌。小辣椒为每一款手机配置全球一流的移动技术与品牌元器件，用互联网销售方式，打造最具性价比和国际品质的智能手机。小辣椒以独有的"挑战"精神，专为渴望不平凡、不甘心平淡、充满激情、坚持梦想、积极乐观、敢于挑战的群体而生，助力他们挑战梦想、绽放青春、创造非凡！
	</p>
	<p class="img">
		<img alt="" src="http://image.xiaolajiao.com/images/upload/image/20140823/20140823153219_40226.jpg" /> 
	</p>
</div> 
        </div>
        
        
                <div class="xlj-box" id="Faqs">
         
        </div>
                
      </div>
  </div>
<div class="blank"></div>
<div id="goodsSubBar" class="goods-sub-bar " style=" display:none">
    <div class="block">
        <div class="row">
            <div class="span3">
                <dl class="goods-sub-bar-info clearfix">
                    <dt><img src="${product.image}"></dt>
                    <dd>
                        <strong>${product.name}</strong>
                        <p>
                            <em>￥${product.price}</em>
                        </p>
                    </dd>
                </dl>
            </div>
            <div class="span12">
                <div class="fr">
                    <a class="btn btn-primary btn_fp" id="addCart2" href="javascript:void(0);" data-gid="118" data-cid="38" data-thumb="http://image.xiaolajiao.com/images/201404/thumb_img/118_thumb_G_1396421240282.jpg?v=20141202">
                                    立即购买
                  </a>
          </div>
                <div id="goodsSubMenu" class="godds-desc-menu">
                    <ul class="clearfix">
                        <li class="first"><a href="#productDetail">产品详情</a> </li>
                        <li><a href="#specifications">规格参数</a></li>
                        <li><a href="#userRating">用户评价<span>(${product.scoreCount})</span></a> </li>
                        <li><a href="#Service">售后服务</a></li>
                        <li><a href="#FAQs">常见问题</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div> 
</div>
	
	<div class="container productContent">
		<div class="span6">
			<div class="hotProductCategory">
				[@product_category_root_list]
					[#list productCategories as category]
						<dl[#if !category_has_next] class="last"[/#if]>
							<dt>
								<a href="${base}${category.path}">${category.name}</a>
							</dt>
							[@product_category_children_list productCategoryId = category.id count = 4]
								[#list productCategories as productCategory]
									<dd>
										<a href="${base}${productCategory.path}">${productCategory.name}</a>
									</dd>
								[/#list]
							[/@product_category_children_list]
						</dl>
					[/#list]
				[/@product_category_root_list]
			</div>
			<div class="hotProduct">
				<div class="title">${message("shop.product.hotProduct")}</div>
				<ul>
					[@product_list productCategoryId = productCategory.id count = 6 orderBy="monthSales desc"]
						[#list products as product]
							<li[#if !product_has_next] class="last"[/#if]>
								<a href="${base}${product.path}" title="${product.name}">${abbreviate(product.name, 30)}</a>
								[#if product.scoreCount > 0]
									<div>
										<div>${message("Product.score")}: </div>
										<div class="score${(product.score * 2)?string("0")}"></div>
										<div>${product.score?string("0.0")}</div>
									</div>
								[/#if]
								<div>${message("Product.price")}: <strong>${currency(product.price, true, true)}</strong></div>
								<div>${message("Product.monthSales")}: <em>${product.monthSales}</em></div>
							</li>
						[/#list]
					[/@product_list]
				</ul>
			</div>
			<div id="historyProduct" class="historyProduct">
				<div class="title">${message("shop.product.historyProduct")}</div>
				<ul></ul>
				<a href="javascript:;" id="clearHistoryProduct" class="clearHistoryProduct">${message("shop.product.clearHistoryProduct")}</a>
			</div>
		</div>
		<div class="span18 last">
			<div class="path">
				<ul>
					<li>
						<a href="${base}/">${message("shop.path.home")}</a>
					</li>
					[@product_category_parent_list productCategoryId = productCategory.id]
						[#list productCategories as productCategory]
							<li>
								<a href="${base}${productCategory.path}">${productCategory.name}</a>
							</li>
						[/#list]
					[/@product_category_parent_list]
					<li>
						<a href="${base}${productCategory.path}">${productCategory.name}</a>
					</li>
				</ul>
			</div>
			<div class="productImage">
				[#if product.productImages?has_content]
					<a id="zoom" href="${product.productImages[0].large}" rel="gallery">
						<img class="medium" src="${product.productImages[0].medium}" />
					</a>
				[#else]
					<a id="zoom" href="${setting.defaultLargeProductImage}" rel="gallery">
						<img class="medium" src="${setting.defaultMediumProductImage}" />
					</a>
				[/#if]
				<a href="javascript:;" class="prev"></a>
				<div id="scrollable" class="scrollable">
					<div class="items">
						[#if product.productImages?has_content]
							[#list product.productImages as productImage]
								<a[#if productImage_index == 0] class="current"[/#if] href="javascript:;" rel="{gallery: 'gallery', smallimage: '${productImage.medium}', largeimage: '${productImage.large}'}"><img src="${productImage.thumbnail}" title="${productImage.title}" /></a>
							[/#list]
						[#else]
							<a class="current" href="javascript:;"><img src="${setting.defaultThumbnailProductImage}" /></a>
						[/#if]
					</div>
				</div>
				<a href="javascript:;" class="next"></a>
			</div>
			<div class="name">${product.name}
			[#if product.isGift] [${message("shop.product.gifts")}][/#if]</div>
			<div class="sn">
				<div>${message("Product.sn")}: ${product.sn}</div>
				[#if product.scoreCount > 0]
					<div>${message("Product.score")}:</div>
					<div class="score${(product.score * 2)?string("0")}"></div>
					<div>${product.score?string("0.0")} (${message("Product.scoreCount")}: ${product.scoreCount})</div>
				[/#if]
			</div>
			<div class="info">
				<dl>
					<dt>${message("Product.price")}:</dt>
					<dd>
						<strong>${currency(product.price, true)}</strong>
						[#if setting.isShowMarketPrice]
							${message("Product.marketPrice")}:
							<del>${currency(product.marketPrice, true)}</del>
						[/#if]
					</dd>
				</dl>
				[#if product.memberPrice?has_content]
					<dl>
						<dt>${message("Product.memberPrice")}:</dt>
						<dd>
							[#list product.memberPrice.keySet() as memberRank]
								${memberRank.name}: <span>${currency(product.memberPrice.get(memberRank), true)}</span>
							[/#list]
						</dd>
					</dl>
				[/#if]
				[#if product.validPromotions?has_content]
					<dl>
						<dt>${message("Product.promotions")}:</dt>
						<dd>
							[#list product.validPromotions as promotion]
								<a href="${base}${promotion.path}" target="_blank"[#if promotion.beginDate?? || promotion.endDate??] title="${promotion.beginDate} ~ ${promotion.endDate}"[/#if]>${promotion.name}</a>
							[/#list]
						</dd>
					</dl>
				[/#if]
				[#if product.point > 0]
					<dl>
						<dt>${message("Product.point")}:</dt>
						<dd>
							<span>${product.point}</span>
						</dd>
					</dl>
				[/#if]
			</div>
			[#if !product.isGift]
				<div class="action">
					[#if product.specifications?has_content]
						<div id="specification" class="specification clearfix">
							<div class="title">${message("shop.product.specificationTitle")}</div>
							[#assign specificationValues = product.goods.specificationValues /]
							[#list product.specifications as specification]
								<dl>
									<dt>
										<span title="${specification.name}">${abbreviate(specification.name, 8)}:</span>
									</dt>
									[#list specification.specificationValues as specificationValue]
										[#if specificationValues?seq_contains(specificationValue)]
											<dd>
												<a href="javascript:;" class="${specification.type}[#if product.specificationValues?seq_contains(specificationValue)] selected[/#if]" val="${specificationValue.id}">[#if specification.type == "text"]${specificationValue.name}[#else]<img src="${specificationValue.image}" alt="${specificationValue.name}" title="${specificationValue.name}" />[/#if]<span title="${message("shop.product.selected")}">&nbsp;</span></a>
											</dd>
										[/#if]
									[/#list]
								</dl>
							[/#list]
						</div>
					[/#if]
					[#if product.isOutOfStock]
						<form id="productNotifyForm" action="${base}/product_notify/save.jhtml" method="post">
							<dl id="productNotify" class="productNotify">
								<dt>${message("shop.product.productNotifyEmail")}:</dt>
								<dd>
									<input type="text" name="email" maxlength="200" />
								</dd>
							</dl>
						</form>
					[#else]
						<dl class="quantity">
							<dt>${message("shop.product.quantity")}:</dt>
							<dd>
								<input type="text" id="quantity" name="quantity" value="1" maxlength="4" onpaste="return false;" />
								<div>
									<span id="increase" class="increase">&nbsp;</span>
									<span id="decrease" class="decrease">&nbsp;</span>
								</div>
							</dd>
							<dd>
								${product.unit!message("shop.product.defaultUnit")}
							</dd>
						</dl>
					[/#if]
					<div class="buy">
						[#if product.isOutOfStock]
							<input type="button" id="addProductNotify" class="addProductNotify" value="${message("shop.product.addProductNotify")}" />
						[#else]
							<input type="button" id="addCart" class="addCart" value="${message("shop.product.addCart")}" />
						[/#if]
						<a href="/" id="demoLink" class="addCart">演示地址</a>
						<a href="javascript:;" id="addFavorite">${message("shop.product.addFavorite")}</a>
					</div>
				</div>
			[/#if]
			[#if (product.parameterValue.size() >= 3)]
				<table class="brief">
					[#list product.parameterValue.keySet() as parameter]
						[#if parameter_index == 0]
							<tr>
						[/#if]
						<th>${abbreviate(parameter.name, 20)}</th>
						<td>
							<span title="${product.parameterValue.get(parameter)}">${abbreviate(product.parameterValue.get(parameter), 30, "...")}</span>
						</td>
						[#if (parameter_index == 2 && product.parameterValue?size < 6) || parameter_index == 5]
							</tr>
							[#break /]
						[#elseif (parameter_index + 1) % 3 == 0]
							</tr>
							<tr>
						[/#if]
					[/#list]
				</table>
			[/#if]
			[#if product.introduction?has_content]
				<div id="introduction" name="introduction" class="introduction">
					<div class="title">
						<strong>${message("shop.product.introduction")}</strong>
					</div>
					<div>
						${product.introduction}
					</div>
				</div>
			[/#if]
			[#if product.parameterValue?has_content]
				<div id="parameter" name="parameter" class="parameter">
					<div class="title">
						<strong>${message("shop.product.parameter")}</strong>
					</div>
					<table>
						[#list productCategory.parameterGroups as parameterGroups]
							<tr>
								<th class="group" colspan="2">${parameterGroups.name}</th>
							</tr>
							[#list parameterGroups.parameters as parameter]
								[#if product.parameterValue.get(parameter)??]
									<tr>
										<th>${parameter.name}</th>
										<td>${product.parameterValue.get(parameter)}</td>
									</tr>
								[/#if]
							[/#list]
						[/#list]
					</table>
				</div>
			[/#if]
			[#if setting.isReviewEnabled]
				<div id="review" name="review" class="review">
					<div class="title">${message("shop.product.review")}</div>
					<div class="content clearfix">
						[#if product.scoreCount > 0]
							<div class="score">
								<strong>${product.score?string("0.0")}</strong>
								<div>
									<div class="score${(product.score * 2)?string("0")}"></div>
									<div>${message("Product.scoreCount")}: ${product.scoreCount}</div>
								</div>
							</div>
							<div class="graph">
								<span style="width: ${(product.score * 20)?string("0.0")}%">
									<em>${product.score?string("0.0")}</em>
								</span>
								<div>&nbsp;</div>
								<ul>
									<li>${message("shop.product.graph1")}</li>
									<li>${message("shop.product.graph2")}</li>
									<li>${message("shop.product.graph3")}</li>
									<li>${message("shop.product.graph4")}</li>
									<li>${message("shop.product.graph5")}</li>
								</ul>
							</div>
							<div class="handle">
								<a href="${base}/review/add/${product.id}.jhtml" id="addReview">${message("shop.product.addReview")}</a>
							</div>
							[@review_list productId = product.id count = 5]
								[#if reviews?has_content]
									<table>
										[#list reviews as review]
											<tr>
												<th>
													${review.content}
													<div class="score${(review.score * 2)?string("0")}"></div>
												</th>
												<td>
													[#if review.member??]
														${review.member.username}
													[#else]
														${message("shop.product.anonymous")}
													[/#if]
													<span title="${review.createDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createDate?string("yyyy-MM-dd")}</span>
												</td>
											</tr>
										[/#list]
									</table>
									<p>
										<a href="${base}/review/content/${product.id}.jhtml">[${message("shop.product.viewReview")}]</a>
									</p>
								[/#if]
							[/@review_list]
						[#else]
							<p>
								${message("shop.product.noReview")} <a href="${base}/review/add/${product.id}.jhtml" id="addReview">[${message("shop.product.addReview")}]</a>
							</p>
						[/#if]
					</div>
				</div>
			[/#if]
			[#if setting.isConsultationEnabled]
				<div id="consultation" name="consultation" class="consultation">
					<div class="title">${message("shop.product.consultation")}</div>
					<div class="content">
						[@consultation_list productId = product.id count = 5]
							[#if consultations?has_content]
								<ul>
									[#list consultations as consultation]
										<li[#if !consultation_has_next] class="last"[/#if]>
											${consultation.content}
											<span>
												[#if consultation.member??]
													${consultation.member.username}
												[#else]
													${message("shop.consultation.anonymous")}
												[/#if]
												<span title="${consultation.createDate?string("yyyy-MM-dd HH:mm:ss")}">${consultation.createDate?string("yyyy-MM-dd")}</span>
											</span>
											[#if consultation.replyConsultations?has_content]
												<div class="arrow"></div>
												<ul>
													[#list consultation.replyConsultations as replyConsultation]
														<li>
															${replyConsultation.content}
															<span title="${replyConsultation.createDate?string("yyyy-MM-dd HH:mm:ss")}">${replyConsultation.createDate?string("yyyy-MM-dd")}</span>
														</li>
													[/#list]
												</ul>
											[/#if]
										</li>
									[/#list]
								</ul>
								<p>
									<a href="${base}/consultation/add/${product.id}.jhtml" id="addConsultation">[${message("shop.product.addConsultation")}]</a>
									<a href="${base}/consultation/content/${product.id}.jhtml">[${message("shop.product.viewConsultation")}]</a>
								</p>
							[#else]
								<p>
									${message("shop.product.noConsultation")} <a href="${base}/consultation/add/${product.id}.jhtml" id="addConsultation">[${message("shop.product.addConsultation")}]</a>
								</p>
							[/#if]
						[/@consultation_list]
					</div>
				</div>
			[/#if]
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>