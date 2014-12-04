var dw = {
	base: "/definedweek",
	locale: "zh_CN"
};

var setting = {
	priceScale: "2",
	priceRoundType: "roundHalfUp",
	currencySign: "￥",
	currencyUnit: "元",
	uploadImageExtension: "jpg,jpeg,bmp,gif,png",
	uploadFlashExtension: "swf,flv",
	uploadMediaExtension: "swf,flv,mp3,wav,avi,rm,rmvb",
	uploadFileExtension: "zip,rar,7z,doc,docx,xls,xlsx,ppt,pptx"
};

var messages = {
	"shop.message.success": "操作成功",
	"shop.message.error": "操作错误",
	"shop.dialog.ok": "确&nbsp;&nbsp;定",
	"shop.dialog.cancel": "取&nbsp;&nbsp;消",
	"shop.dialog.deleteConfirm": "您确定要删除吗？",
	"shop.dialog.clearConfirm": "您确定要清空吗？",
	"shop.validate.required": "必填",
	"shop.validate.email": "E-mail格式错误",
	"shop.validate.url": "网址格式错误",
	"shop.validate.date": "日期格式错误",
	"shop.validate.dateISO": "日期格式错误",
	"shop.validate.pointcard": "信用卡格式错误",
	"shop.validate.number": "只允许输入数字",
	"shop.validate.digits": "只允许输入零或正整数",
	"shop.validate.minlength": "长度不允许小于{0}",
	"shop.validate.maxlength": "长度不允许大于{0}",
	"shop.validate.rangelength": "长度必须在{0}-{1}之间",
	"shop.validate.min": "不允许小于{0}",
	"shop.validate.max": "不允许大于{0}",
	"shop.validate.range": "必须在{0}-{1}之间",
	"shop.validate.accept": "输入后缀错误",
	"shop.validate.equalTo": "两次输入不一致",
	"shop.validate.remote": "输入错误",
	"shop.validate.integer": "只允许输入整数",
	"shop.validate.positive": "只允许输入正数",
	"shop.validate.negative": "只允许输入负数",
	"shop.validate.decimal": "数值超出了允许范围",
	"shop.validate.pattern": "格式错误",
	"shop.validate.extension": "文件格式错误"
};

// 添加Cookie
function addCookie(name, value, options) {
	if (arguments.length > 1 && name != null) {
		if (options == null) {
			options = {};
		}
		if (value == null) {
			options.expires = -1;
		}
		if (typeof options.expires == "number") {
			var time = options.expires;
			var expires = options.expires = new Date();
			expires.setTime(expires.getTime() + time * 1000);
		}
		document.cookie = encodeURIComponent(String(name)) + "=" + encodeURIComponent(String(value)) + (options.expires ? "; expires=" + options.expires.toUTCString() : "") + (options.path ? "; path=" + options.path : "") + (options.domain ? "; domain=" + options.domain : ""), (options.secure ? "; secure" : "");
	}
}

// 获取Cookie
function getCookie(name) {
	if (name != null) {
		var value = new RegExp("(?:^|; )" + encodeURIComponent(String(name)) + "=([^;]*)").exec(document.cookie);
		return value ? decodeURIComponent(value[1]) : null;
	}
}

// 移除Cookie
function removeCookie(name, options) {
	addCookie(name, null, options);
}

// 货币格式化
function currency(value, showSign, showUnit) {
	if (value != null) {
		var price;
		if (setting.priceRoundType == "roundHalfUp") {
			price = (Math.round(value * Math.pow(10, setting.priceScale)) / Math.pow(10, setting.priceScale)).toFixed(setting.priceScale);
		} else if (setting.priceRoundType == "roundUp") {
			price = (Math.ceil(value * Math.pow(10, setting.priceScale)) / Math.pow(10, setting.priceScale)).toFixed(setting.priceScale);
		} else {
			price = (Math.floor(value * Math.pow(10, setting.priceScale)) / Math.pow(10, setting.priceScale)).toFixed(setting.priceScale);
		}
		if (showSign) {
			price = setting.currencySign + price;
		}
		if (showUnit) {
			price += setting.currencyUnit;
		}
		return price;
	}
}

// 多语言
function message(code) {
	if (code != null) {
		var content = messages[code] != null ? messages[code] : code;
		if (arguments.length == 1) {
			return content;
		} else {
			if ($.isArray(arguments[1])) {
				$.each(arguments[1], function(i, n) {
					content = content.replace(new RegExp("\\{" + i + "\\}", "g"), n);
				});
				return content;
			} else {
				$.each(Array.prototype.slice.apply(arguments).slice(1), function(i, n) {
					content = content.replace(new RegExp("\\{" + i + "\\}", "g"), n);
				});
				return content;
			}
		}
	}
}

(function($) {

	var zIndex = 100;

	// 检测登录
	$.checkLogin = function() {
		var result = false;
		$.ajax({
			url: dw.base + "/login/check.jhtml",
			type: "GET",
			dataType: "json",
			cache: false,
			async: false,
			success: function(data) {
				result = data;
			}
		});
		return result;
	}

	// 跳转登录
	$.redirectLogin = function (redirectUrl, message) {
		var href = dw.base + "/login.jhtml";
		if (redirectUrl != null) {
			href += "?redirectUrl=" + encodeURIComponent(redirectUrl);
		}
		if (message != null) {
			$.message("warn", message);
			setTimeout(function() {
				location.href = href;
			}, 1000);
		} else {
			location.href = href;
		}
	}

	// 消息框
	var $message;
	var messageTimer;
	$.message = function() {
		var message = {};
		if ($.isPlainObject(arguments[0])) {
			message = arguments[0];
		} else if (typeof arguments[0] === "string" && typeof arguments[1] === "string") {
			message.type = arguments[0];
			message.content = arguments[1];
		} else {
			return false;
		}
		
		if (message.type == null || message.content == null) {
			return false;
		}
		
		if ($message == null) {
			$message = $('<div class="xxMessage"><div class="messageContent message' + message.type + 'Icon"><\/div><\/div>');
			if (!window.XMLHttpRequest) {
				$message.append('<iframe class="messageIframe"><\/iframe>');
			}
			$message.appendTo("body");
		}
		
		$message.children("div").removeClass("messagewarnIcon messageerrorIcon messagesuccessIcon").addClass("message" + message.type + "Icon").html(message.content);
		$message.css({"margin-left": - parseInt($message.outerWidth() / 2), "z-index": zIndex ++}).show();
		
		clearTimeout(messageTimer);
		messageTimer = setTimeout(function() {
			$message.hide();
		}, 3000);
		return $message;
	}

	// 令牌	
	$(document).ajaxSend(function(event, request, settings) {
		if (!settings.crossDomain && settings.type != null && settings.type.toLowerCase() == "post") {
			var token = getCookie("token");
			if (token != null) {
				request.setRequestHeader("token", token);
			}
		}
	});
	
	$(document).ajaxComplete(function(event, request, settings) {
		var loginStatus = request.getResponseHeader("loginStatus");
		var tokenStatus = request.getResponseHeader("tokenStatus");
		
		if (loginStatus == "accessDenied") {
			$.redirectLogin(location.href, "请登录后再进行操作");
		} else if (tokenStatus == "accessDenied") {
			var token = getCookie("token");
			if (token != null) {
				$.extend(settings, {
					global: false,
					headers: {token: token}
				});
				$.ajax(settings);
			}
		}
	});

})(jQuery);

// 令牌
$().ready(function() {

	$("form").submit(function() {
		var $this = $(this);
		if ($this.attr("method") != null && $this.attr("method").toLowerCase() == "post" && $this.find("input[name='token']").size() == 0) {
			var token = getCookie("token");
			if (token != null) {
				$this.append('<input type="hidden" name="token" value="' + token + '" \/>');
			}
		}
	});

});

// 验证消息
if ($.validator != null) {
	$.extend($.validator.messages, {
		required: message("shop.validate.required"),
		email: message("shop.validate.email"),
		url: message("shop.validate.url"),
		date: message("shop.validate.date"),
		dateISO: message("shop.validate.dateISO"),
		pointcard: message("shop.validate.pointcard"),
		number: message("shop.validate.number"),
		digits: message("shop.validate.digits"),
		minlength: $.validator.format(message("shop.validate.minlength")),
		maxlength: $.validator.format(message("shop.validate.maxlength")),
		rangelength: $.validator.format(message("shop.validate.rangelength")),
		min: $.validator.format(message("shop.validate.min")),
		max: $.validator.format(message("shop.validate.max")),
		range: $.validator.format(message("shop.validate.range")),
		accept: message("shop.validate.accept"),
		equalTo: message("shop.validate.equalTo"),
		remote: message("shop.validate.remote"),
		integer: message("shop.validate.integer"),
		positive: message("shop.validate.positive"),
		negative: message("shop.validate.negative"),
		decimal: message("shop.validate.decimal"),
		pattern: message("shop.validate.pattern"),
		extension: message("shop.validate.extension")
	});
	
	$.validator.setDefaults({
		errorClass: "fieldError",
		ignore: ".ignore",
		ignoreTitle: true,
		errorPlacement: function(error, element) {
			var fieldSet = element.closest("span.fieldSet");
			if (fieldSet.size() > 0) {
				error.appendTo(fieldSet);
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler: function(form) {
			$(form).find(":submit").prop("disabled", true);
			form.submit();
		}
	});
}

var xlj={};
xlj.miniCart = {
    elmCartBtn: $("#minCart"),
    elmCartList: $("#ECS_CARTINFO"),
    speed: 500,
    init: function () {
        		var _this = this,
            	timeOut = null;
       		 return  (_this.elmCartBtn.on({
            mouseenter: function () {
                clearTimeout(timeOut), $(this).hasClass("xlj-cart-on") || ($(this).addClass("xlj-cart-on"), _this.show()
                    )
            },

            mouseleave: function () {
                timeOut = setTimeout(function () {
                    _this.close();
                }, _this.speed)
            }
        }),
		 _this.elmCartList.on({
            mouseenter: function () {
                clearTimeout(timeOut)
            },
            mouseleave: function () {
                timeOut = setTimeout(function () {
                    _this.close()
                }, _this.speed)
            }
        })
		)
    },
    show: function () {
        var _this = this;
        _this.elmCartList.show()
    },
    close: function () {
        var _this = this;
        _this.elmCartBtn.removeClass("xlj-cart-on"), _this.elmCartList.hide()
    }

};
xlj.leftNav = {
        elmCartBtn: $(".nav-long"),
        elmCartList: $("#nav_category_list"),
        navUrl:window.location.href,
        speed: 500,
        init: function () {
            var _this = this,
          		timeOut = null;
                return  (_this.elmCartBtn.on({
                    mouseenter: function () {
                        clearTimeout(timeOut), $(this).find("em").hasClass("xlj-nav-on") || ($(this).find("em").addClass("xlj-nav-on"), _this.show()
                            )
                    },

                    mouseleave: function () {
                        timeOut = setTimeout(function () {
                            _this.close();
                        }, _this.speed)
                    }
                }),
                    _this.elmCartList.on({
                        mouseenter: function () {
                            clearTimeout(timeOut)
                        },
                        mouseleave: function () {
                            timeOut = setTimeout(function () {
                                _this.close()
                            }, _this.speed)
                        }
                    })
                    )

        },
        show: function () {
            var _this = this;

            _this.elmCartList.show().css("top","147px")

        },
        close: function () {
            var _this = this;
            _this.elmCartBtn.find("em").removeClass("xlj-nav-on"), _this.elmCartList.hide()
        }

    };
    xlj.mainNav = {
        elmCartBtn: $(".nav-item-parent"),
        elmCartList: $(".nav-main-children"),
        navUrl:window.location.href,
        speed: 500,
        init: function () {
            var _this = this,
                timeOut = null;
            return  (_this.elmCartBtn.on({
                mouseenter: function () {
                    clearTimeout(timeOut), $(this).find("em").hasClass("xlj-nav-on") || ($(this).find("em").addClass("xlj-nav-on"), _this.show()
                        )
                },

                mouseleave: function () {
                    timeOut = setTimeout(function () {
                        _this.close();
                    }, _this.speed)
                }
            }),
                _this.elmCartList.on({
                    mouseenter: function () {
                        clearTimeout(timeOut)
                    },
                    mouseleave: function () {
                        timeOut = setTimeout(function () {
                            _this.close()
                        }, _this.speed)
                    }
                })
                )

        },
        show: function () {
            var _this = this;

            _this.elmCartList.slideDown('fast').parent().find('.arrow').css('display','block');



        },
        close: function () {
            var _this = this;
            _this.elmCartList.parent().find('.arrow').css('display','none');
            _this.elmCartList .slideUp('fast');
        }

    };
xlj.miniCart.init();
xlj.leftNav.init();
xlj.mainNav.init();

 /*导航*/



    $("#ECS_CARTINFO .delItem").off().on("click",function(){
    var dataGid=$(this).attr("data-gid");
    deleteCartGoods(dataGid);
});
    function isPlaceholer() {

        var input = document.createElement('input');
        return "placeholder" in input;
    }

    if (!isPlaceholer()) {
        var  minput=$('input[type="text"][placeholder],textarea');
        var  mlabel= minput.prev("label");
        mlabel.show();
        minput.off("focus").on("focus",function(){

            $(this).prev("label").hide();
        }).off("blur").on("blur",function(){
            if($(this).val()==""){
                $(this).prev("label").show();
            }
        }),
            mlabel.off().on("click",function(){
                $(this).next().focus();
            })

    }
    $(".article-left dd").mouseenter(function(){
        if($(this).hasClass("on")){
            return;
        }else{
            $(this).find("span").css("display","block");
        }


    }).mouseleave(function(){
        if($(this).hasClass("on")){
            return;
        }else{
            $(this).find("span").css("display","none");
        }
    }).click(function(e){
        e.defaultIndex
        if($(this).hasClass("on")){
            return;
        }else{

            $(this).addClass("on").siblings().removeClass("on");

        }
    });
    $("#xljMobile").hover(function(){
            $('.xlj-erweima').show();
    },function(){
       setTimeout(function(){$('.xlj-erweima').hide();},500);
    })

})
function getByteLen(val) {
    var len = 0;
    for (var i = 0; i < val.length; i++) {
        var a = val.charAt(i);
        if (a.match(/[^\x00-\xff]/ig) != null)
        {
            len += 2;
        }
        else
        {
            len += 1;
        }
    }
    return len;
}

/* *
 * 添加商品到购物车
 */
function addToCart(goodsId, parentId, thumb, effect, number, sid)
{
    var goods        = new Object();
    var spec_arr     = new Array();
    var fittings_arr = new Array();
    var number       = number;
    var formBuy      = document.forms['ECS_FORMBUY'];
    var quick		 = 0;
	var sid		 	 = sid;

    // 检查是否有商品规格
    if (formBuy)
    {
        spec_arr = getSelectedAttributes(formBuy);
        quick = 1;
    } else {
        spec_arr = 1;
        quick = 1;
    }

    goods.quick    = quick;
    goods.spec     = spec_arr;
    goods.goods_id = goodsId;
    goods.number   = number;
    goods.eimg     = thumb;
	goods.sid      = sid;

	if(parentId > 0) {
	   goods.cat_id   = parentId;
	   goods.types    = 0;
	   goods.effect   = 0;
	} else {
	   goods.parent   = (typeof(parentId) == "undefined") ? 0 : parseInt(parentId);
	   goods.cat_id   = 0;
	   goods.types    = 1;
	   goods.effect   = effect;
	}

    $.post("flow.php?step=add_to_cart", 'goods=' + $.toJSON(goods), addToCartResponse, "json");
}
/* *
 * 处理添加商品到购物车的反馈信息
 */
function addToCartResponse(result)
{
    if (result.error > 0)
    {
        // 预约跳转
        if (result.error == 9)
        {
            location.href = result.urls;
        }
        else if (result.error == 8)
        {
            if (confirm(result.message))
            {
                location.href = result.urls;
            }
        }
        // 如果需要缺货登记，跳转
        else if (result.error == 2)
        {
            ArrivalNotice(result.goods_id);
        }
        // 没选规格，弹出属性选择框
        else if (result.error == 6)
        {
            openSpeDiv(result.message, result.goods_id, result.parent);
        }
        else
        {
            alert(result.message);
        }
    }
    else
    {
        addToCartEffect(result['goods_id'], result['eimg'], result['effect']);
        var cartInfo = document.getElementById('xlj_cart_list');
        var cart_url = 'flow.php';//直接进购物车
        var discount_url = 'discount.php?goods_id='+result.goods_id;//选择套餐
        var fitting_url = 'fitting.php?goods_id='+result.goods_id;//选择配件

        if (cartInfo)
        {
			$.getScript(result.js+"public/common.js"+result.PARAMETER_CDN);
            cartInfo.innerHTML = result.content;
        }

        if (result.one_step_buy == '1')
        {
            location.href = cart_url;
        }
        else
        {
            if(result.types == 4){
                location.href = discount_url;
            }else if(result.types == 0){
                location.href = fitting_url;
            }else{
                switch(result.confirm_type)
                {
                    case '1' :
                        if (confirm(result.message)) location.href = cart_url;
                        break;
                    case '2' :
                        if (!confirm(result.message)) location.href = cart_url;
                        break;
                    case '3' :
                        location.href = cart_url;
                        break;
                    default :
                        break;
                }
            }
        }
    }
}

/* *
 * 移动飞到购物车效果
 */
function addToCartEffect(goods_id, eimg, effect)
{
    if(effect == 3) {
        $('#addCart2').css({position:"relative",overflow:"hidden"});
        var c = $("<span>");
        c.html('<i class="cart_icon-add-success"></i>加入成功!').appendTo(
                $('#addCart2')).addClass("item-action-cart").animate(
            {top:"0px"},500,function(){{
                var a=$(this);
                setTimeout(function(){
                    a.animate({top:"50px"},500,function(){
                        $(this).remove();
                    });
                }, 800);
            }}
        );
    } else
    if(effect == 1) {
        var eveSuccess;
        eveSuccess = $('<div class="item-action-icon"><span class="icon-common icon-add-success"></span>已成功加入购物车</div>'),


        $('#list_'+goods_id).append(eveSuccess);

        eveSuccess.animate({'bottom': '-7px'},  100, 'linear', function () {
            $(this).animate({'bottom': '-10px'},  100, 'linear').delay('1000').animate({'bottom': '-7px'},  100, 'linear', function () {
                $(this).animate({'bottom': '-65px'},  100, 'linear', function() {
                    $(this).remove();
                });
            });
        });

        eveSuccess.on('click', function () {
            $(this).clearQueue().animate({'bottom': '-10px'},  100, 'linear', function () {
                $(this).animate({'bottom': '-65px'},  100, 'linear', function() {
                    $(this).remove();
                });
            })
        });
    } else {
        if($('#cart_'+goods_id).length > 0) {
            var set_top = parseInt($('#cart_'+goods_id).offset().top);
            var set_left = parseInt($('#cart_'+goods_id).offset().left)-700;
        } else {
            var set_top = 450;
            var set_left = 230;
        }

        var $pic = $('<div class="to-cart-effect"><img src="'+eimg+'" width="150" /></div>');
        $pic.css({position:'absolute', top:set_top, left:($(window).width()/2)+set_left, zindex:'9999'});
        $(document.body).append($pic);
        $pic.animate({width:0, top:44,left:($(window).width()/2)+508});
        $pic.children("img").animate({width:0, top:44,left:($(window).width()/2)+508}, "normal",function(){
            $pic.css("display","none");
        });
    }
}
/**
 * 获得选定的商品属性
 */
function getSelectedAttributes(formBuy)
{
    var spec_arr = new Array();
    var j = 0;

    for (i = 0; i < formBuy.elements.length; i ++ )
    {
        var prefix = formBuy.elements[i].name.substr(0, 5);

        if (prefix == 'spec_' && (
            ((formBuy.elements[i].type == 'radio' || formBuy.elements[i].type == 'checkbox') && formBuy.elements[i].checked) ||
                formBuy.elements[i].tagName == 'SELECT')||formBuy.elements[i].type == 'hidden')
        {
            spec_arr[j] = formBuy.elements[i].value;
            j++ ;
        }
    }

    return spec_arr;
}

/*删除商品*/
function deleteCartGoods(rec_id)
{
    $.post('delete_cart_goods.php', 'id='+rec_id+'&random='+Math.random(), deleteCartGoodsResponse,  'JSON');
}

/**
 * 接收返回的信息
 */
function deleteCartGoodsResponse(res)
{
    if (res.error)
    {
        alert(res.err_msg);
    }
    else
    {
		$.getScript(res.js+"public/common.js"+res.PARAMETER_CDN);
        $('#xlj_cart_list').html(res.content);
    }
}

function ArrivalNotice(id){
    $.getScript("themes/newxlj/script/library/jquery-ui.js", function(){
        $.ajax({
            type: "get",
            dataType: "json",
            url: "goods.php?act=out_of_stock",
            data:"goods_id="+id+"&t="+new Date().getTime(),
            success: function(data){
				if(data.error == 1) {
					if (confirm(data.message)) location.href = data.url;
				} else {
                    $("#dialog-modal").html(data.message).show().dialog({width: 550,height:260,modal: true});
				}
            }
        });
    });


}