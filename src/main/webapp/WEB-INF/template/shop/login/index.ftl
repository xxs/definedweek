<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.login.title")}[#if systemShowPowered] - Powered By SHOP++[/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/css/index.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/login.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/css/user.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${base}/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/jsbn.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/prng4.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/rng.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/rsa.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/base64.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $loginForm = $("#loginForm");
	var $username = $("#username");
	var $password = $("#password");
	var $captcha = $("#captcha");
	var $captchaImage = $("#captchaImage");
	var $isRememberUsername = $("#isRememberUsername");
	var $submit = $(":submit");
	
	// 记住用户名
	if (getCookie("memberUsername") != null) {
		$isRememberUsername.prop("checked", true);
		$username.val(getCookie("memberUsername"));
		$password.focus();
	} else {
		$isRememberUsername.prop("checked", false);
		$username.focus();
	}
	
	// 更换验证码
	$captchaImage.click(function() {
		$captchaImage.attr("src", "${base}/common/captcha.jhtml?captchaId=${captchaId}&timestamp=" + (new Date()).valueOf());
	});
	
	// 表单验证、记住用户名
	$loginForm.validate({
		rules: {
			username: "required",
			password: "required"
			[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")]
				,captcha: "required"
			[/#if]
		},
		submitHandler: function(form) {
			$.ajax({
				url: "${base}/common/public_key.jhtml",
				type: "GET",
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					var rsaKey = new RSAKey();
					rsaKey.setPublic(b64tohex(data.modulus), b64tohex(data.exponent));
					var enPassword = hex2b64(rsaKey.encrypt($password.val()));
					$.ajax({
						url: $loginForm.attr("action"),
						type: "POST",
						data: {
							username: $username.val(),
							enPassword: enPassword
							[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")]
								,captchaId: "${captchaId}",
								captcha: $captcha.val()
							[/#if]
						},
						dataType: "json",
						cache: false,
						success: function(message) {
							if ($isRememberUsername.prop("checked")) {
								addCookie("memberUsername", $username.val(), {expires: 7 * 24 * 60 * 60});
							} else {
								removeCookie("memberUsername");
							}
							$submit.prop("disabled", false);
							if (message.type == "success") {
								[#if redirectUrl??]
									location.href = "${redirectUrl}";
								[#else]
									location.href = "${base}/";
								[/#if]
							} else {
								$.message(message);
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")]
									$captcha.val("");
									$captchaImage.attr("src", "${base}/common/captcha.jhtml?captchaId=${captchaId}&timestamp=" + (new Date()).valueOf());
								[/#if]
							}
						}
					});
				}
			});
		}
	});

});
</script>
</head>
<body>
	[#include "/shop/include/header_simple.ftl" /]
	
	<div class="block"> 
   <div class="usBox clearfix"> 
    <div class="login_form"> 
     <div class="usBox_1 clearfix"> 
      <h4>&nbsp;&nbsp;欢迎登录&nbsp;&nbsp;<span><a target="_blank" href="http://bbs.xiaolajiao.com/thread-13291-1-1.html">(账号不能登陆？请点击)</a></span></h4> 
      <form name="formLogin" action="http://account.xiaolajiao.com/passport.php" method="post" id="formLogin"> 
       <div class="login_tdon"> 
        <input name="username" id="login_username" type="text" value="邮箱/手机号码/用户名" class="inputBg input_kuang4" /> 
        <span class="error" id="login_usernameTip" style="display: none;"></span> 
       </div> 
       <div class="login_tdon" id="pw"> 
        <input type="text" value="密码" id="spwd" class="inputBg input_kuang4 disText" maxlength="25" style="display: block;" /> 
        <input name="password" type="password" value="" id="login_password" class="inputBg input_kuang4" maxlength="25" autocomplete="off" style="display: none;" /> 
        <span id="login_passwordTip" style="display: none;"></span> 
       </div> 
       <div class="login_tdon2"> 
        <div class="left"> 
         <input name="remember" type="checkbox" id="remember" value="1" checked="checked" /> 
         <label for="remember">保存登录信息</label> 
        </div> 
        <div class="right"> 
         <a title="忘记密码?" href="http://account.xiaolajiao.com/passport.php?act=get_password">忘记密码?</a> 
        </div> 
       </div> 
       <div class="login_tdon"> 
        <input type="hidden" name="act" value="act_login" /> 
        <input type="hidden" name="callback" value="http%3A%2F%2Fwww.xiaolajiao.com%2Fuser.php%3Fact%3Dorder_list" /> 
        <input name="submit" id="submit1" type="submit" value="立即登录" class="btn btn-primary portalmargin_top " style="border:none; width:100%; margin-top:-18px;*margin-top:0;" /> 
       </div> 
       <div class="login_tdon3"> 
        <div class="left"> 
         <span>其它帐号登录：</span> 
         <ul> 
          <li><a class="qq" title="qq" target="_blank" href="http://account.xiaolajiao.com/passport.php?act=oath&amp;type=qq&amp;callback=http%3A%2F%2Fwww.xiaolajiao.com%2Fuser.php%3Fact%3Dorder_list">qq</a></li> 
          <li><a class="weibo" title="微博" target="_blank" href="http://account.xiaolajiao.com/passport.php?act=oath&amp;type=weibo&amp;callback=http%3A%2F%2Fwww.xiaolajiao.com%2Fuser.php%3Fact%3Dorder_list">微博</a></li> 
          <li><a class="zfb" title="支付宝" target="_blank" href="http://account.xiaolajiao.com/passport.php?act=oath&amp;type=alipay&amp;callback=http%3A%2F%2Fwww.xiaolajiao.com%2Fuser.php%3Fact%3Dorder_list">支付宝</a></li> 
         </ul> 
        </div> 
        <div class="right"> 
         <a title="免费注册" href="http://account.xiaolajiao.com/passport.php?act=register&amp;callback=http%3A%2F%2Fwww.xiaolajiao.com%2Fuser.php%3Fact%3Dorder_list">免费注册</a> 
        </div> 
       </div> 
      </form> 
     </div> 
    </div> 
   </div> 
  </div> 
	
	<div class="container login">
		<div class="span12">
			[@ad_position id = 9 /]
		</div>
		<div class="span12 last">
			<div class="wrap">
				<div class="main">
					<div class="title">
						<strong>${message("shop.login.title")}</strong>USER LOGIN
					</div>
					<form id="loginForm" action="${base}/login/submit.jhtml" method="post">
						<table>
							<tr>
								<th>
									[#if setting.isEmailLogin]
										${message("shop.login.usernameOrEmail")}:
									[#else]
										${message("shop.login.username")}:
									[/#if]
								</th>
								<td>
									<input type="text" id="username" name="username" class="text" maxlength="${setting.usernameMaxLength}" />
								</td>
							</tr>
							<tr>
								<th>
									${message("shop.login.password")}:
								</th>
								<td>
									<input type="password" id="password" name="password" class="text" maxlength="${setting.passwordMaxLength}" autocomplete="off" />
								</td>
							</tr>
							[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")]
								<tr>
									<th>
										${message("shop.captcha.name")}:
									</th>
									<td>
										<span class="fieldSet">
											<input type="text" id="captcha" name="captcha" class="text captcha" maxlength="4" autocomplete="off" /><img id="captchaImage" class="captchaImage" src="${base}/common/captcha.jhtml?captchaId=${captchaId}" title="${message("shop.captcha.imageTitle")}" />
										</span>
									</td>
								</tr>
							[/#if]
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<label>
										<input type="checkbox" id="isRememberUsername" name="isRememberUsername" value="true" />${message("shop.login.isRememberUsername")}
									</label>
									<label>
										&nbsp;&nbsp;<a href="${base}/password/find.jhtml">${message("shop.login.findPassword")}</a>
									</label>
								</td>
							</tr>
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="submit" value="${message("shop.login.submit")}" />
								</td>
							</tr>
							<tr class="register">
								<th>
									&nbsp;
								</th>
								<td>
									<dl>
										<dt>${message("shop.login.noAccount")}</dt>
										<dd>
											${message("shop.login.tips")}
											<a href="${base}/register.jhtml">${message("shop.login.register")}</a>
										</dd>
									</dl>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/include/footer.ftl" /]
</body>
</html>