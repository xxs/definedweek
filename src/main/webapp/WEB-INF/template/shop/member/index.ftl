<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.member.index")}[#if systemShowPowered] - Powered By SHOP++[/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/index.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/user.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/member.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
</head>
<body>
	[#include "/shop/include/header.ftl" /]
    <div class="container clearfix">
		[#include "/shop/member/include/navigation.ftl" /]
		
		
		
		<div class="user-section left">
    <div class="row border-bottom">
    <div class="left"><img src="/upload/image/profile_default.gif" /></div>
    <div class="user-head left">
      <h3 class="font-size-18 color-333">${member.name} &nbsp; 欢迎您回来！～</h3>
      <div>
        您的上一次登录时间:2014-12-06 13:14:24<br/>
                         您还没有通过邮件认证 <a href="javascript:sendHashMail()" style="color:#cc0000;">点此发送认证邮件</a><br />
              </div>
    </div>
  </div>

  <div class="row border-bottom">
      <h3>您的账户</h3>
  </div>
  <div class="row border-bottom line-height-24">
      <div>
                    优惠券: <a href="user.php?act=bonus">共计<span class="text-red"> 0 </span>个,价值<span class="text-red"> ￥0.00 </span></a><br/>
          积分: <a href="user.php?act=transform_points" style="color:#cc0000;"><span class="text-red"></span></a>
      </div>
  </div>
  
  <div class="row border-bottom">
      <h3>用户提醒</h3>
  </div>
  <div class="row border-bottom">
      <div>
                     您最近30天内提交了0个订单<br />
                             </div>
  </div>
  
  <div class="row border-bottom">
      <h3>官方QQ群</h3>
  </div>
  <div class="row">
                红辣椒手机官方②群 37241939    欢迎大家加入
  </div>
  
  
  
    </div>
		
		
		
		
		<div class="span18 last">
			<div class="index">
				<div class="top clearfix">
					<div>
						<ul>
							<li>
								${message("shop.member.index.memberRank")}: ${member.memberRank.name}
							</li>
							<li>
								${message("shop.member.index.balance")}:
								<strong>${currency(member.balance, true, true)}</strong>
							</li>
							<li>
								${message("shop.member.index.amount")}:
								<strong>${currency(member.amount, true, true)}</strong>
							</li>
							<li>
								${message("shop.member.index.point")}:
								<em>${member.point}</em>
								<a href="coupon_code/exchange.jhtml">${message("shop.member.index.exchange")}</a>
							</li>
						</ul>
						<ul>
							<li>
								<a href="order/list.jhtml">${message("shop.member.index.waitingPaymentOrderCount")}(<em>${waitingPaymentOrderCount}</em>)</a>
								<a href="order/list.jhtml">${message("shop.member.index.waitingShippingOrderCount")}(<em>${waitingShippingOrderCount}</em>)</a>
							</li>
							<li>
								<a href="message/list.jhtml">${message("shop.member.index.messageCount")}(<em>${messageCount}</em>)</a>
								<a href="coupon_code/list.jhtml">${message("shop.member.index.couponCodeCount")}(<em>${couponCodeCount}</em>)</a>
							</li>
							<li>
								<a href="favorite/list.jhtml">${message("shop.member.index.favoriteCount")}(<em>${favoriteCount}</em>)</a>
								<a href="product_notify/list.jhtml">${message("shop.member.index.productNotifyCount")}(<em>${productNotifyCount}</em>)</a>
							</li>
							<li>
								<a href="review/list.jhtml">${message("shop.member.index.reviewCount")}(<em>${reviewCount}</em>)</a>
								<a href="consultation/list.jhtml">${message("shop.member.index.consultationCount")}(<em>${consultationCount}</em>)</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="list">
					<div class="title">${message("shop.member.index.newOrder")}</div>
					<table class="list">
						<tr>
							<th>
								${message("Order.sn")}
							</th>
							<th>
								${message("shop.member.index.product")}
							</th>
							<th>
								${message("Order.consignee")}
							</th>
							<th>
								${message("Order.amount")}
							</th>
							<th>
								${message("shop.common.createDate")}
							</th>
							<th>
								${message("shop.member.index.orderStatus")}
							</th>
							<th>
								${message("shop.member.handle")}
							</th>
						</tr>
						[#list newOrders as order]
							<tr[#if !order_has_next] class="last"[/#if]>
								<td>
									${order.sn}
								</td>
								<td>
									[#list order.orderItems as orderItem]
										<img src="[#if orderItem.thumbnail??]${orderItem.thumbnail}[#else]${setting.defaultThumbnailProductImage}[/#if]" class="thumbnail" alt="${orderItem.fullName}" />
										[#if orderItem_index == 2]
											[#break /]
										[/#if]
									[/#list]
								</td>
								<td>
									${order.consignee}
								</td>
								<td>
									${currency(order.amount, true)}
								</td>
								<td>
									<span title="${order.createDate?string("yyyy-MM-dd HH:mm:ss")}">${order.createDate}</span>
								</td>
								<td>
									[#if order.expired]
										${message("shop.member.order.hasExpired")}
									[#elseif order.orderStatus == "completed" || order.orderStatus == "cancelled"]
										${message("Order.OrderStatus." + order.orderStatus)}
									[#elseif order.paymentStatus == "unpaid" || order.paymentStatus == "partialPayment"]
										${message("shop.member.order.waitingPayment")}
										[#if order.shippingStatus != "unshipped"]
											${message("Order.ShippingStatus." + order.shippingStatus)}
										[/#if]
									[#else]
										${message("Order.PaymentStatus." + order.paymentStatus)}
										[#if order.paymentStatus == "paid" && order.shippingStatus == "unshipped"]
											${message("shop.member.order.waitingShipping")}
										[#else]
											${message("Order.ShippingStatus." + order.shippingStatus)}
										[/#if]
									[/#if]
								</td>
								<td>
									<a href="order/view.jhtml?sn=${order.sn}">[${message("shop.member.handle.view")}]</a>
								</td>
							</tr>
						[/#list]
					</table>
					[#if !newOrders?has_content]
						<p>${message("shop.member.noResult")}</p>
					[/#if]
				</div>
			</div>
		</div>
		[#include "/shop/include/footer.ftl" /]
	</div>
</body>
</html>