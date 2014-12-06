 <div class="user-article left">
      <div class="userMenu">
		<div class="portal_list">
		    <div class="about_list"> 会员中心 </div>
			<ul class="about_menu">
				<li [#if current == "orderList"] class="current"[/#if]>
					<a href="${base}/member/order/list.jhtml">${message("shop.member.order.list")}</a>
				</li>
		        <li [#if current == "favoriteList"] class="current"[/#if]>
		        	<a href="${base}/member/favorite/list.jhtml">${message("shop.member.favorite.list")}</a>
		        </li>
		        <li [#if current == "reviewList"] class="current"[/#if]>
		        	<a href="${base}/member/review/list.jhtml">${message("shop.member.review.list")}</a>
		        </li>
				<li [#if current == "consultationList"] class="current"[/#if]>
					<a href="${base}/member/consultation/list.jhtml">${message("shop.member.consultation.list")}</a>
		        </li>
			</ul>
		</div>
		<div class="portal_list">
		    <div class="about_list"> 资金中心 </div>
			<ul class="about_menu">
				<li [#if current == "depositList"] class="current"[/#if]>
					<a href="${base}/member/deposit/list.jhtml">${message("shop.member.deposit.list")}</a>
				</li>
				<li [#if current == "depositRecharge"] class="current"[/#if]>
					<a href="${base}/member/deposit/recharge.jhtml">${message("shop.member.deposit.recharge")}</a>
				</li>
			</ul>
		</div>
		<div class="portal_list">
		    <div class="about_list"> 个人中心 </div>
			<ul class="about_menu">
				<li [#if current == "profileEdit"] class="current"[/#if]>
					<a href="${base}/member/profile/edit.jhtml"[#if current == "profileEdit"] class="current"[/#if]>${message("shop.member.profile.edit")}</a>
				</li>
				<li [#if current == "passwordEdit"] class="current"[/#if]>
					<a href="${base}/member/password/edit.jhtml"[#if current == "passwordEdit"] class="current"[/#if]>${message("shop.member.password.edit")}</a>
				</li>
			</ul>
		</div>
	</div>    
</div>
