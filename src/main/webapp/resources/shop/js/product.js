$(function(){
	pageload();

    try { 
	  onload_leftTime();
	}
	catch (e) {};
	
	$("#CustomLabel").off().on("click",function(){
		var _this=$(this);
		var numlength=$(this).parent().find("li").length;
		if(numlength>=11){
				alert("最多只能自定义三个标签")
		 }else {
			 // 插入一个文本框,并选中里面内容
			 var inputObj = $('<li><input type="text" class="user-label-input" maxlength="10" /></li>');
			 $(this).hide().before(inputObj).prev().find("input").select();
		 }

	});
	$("#CustomSubmit").off().on("click",function(){
		var userLabelInput= $(".user-label-input")
		if(userLabelInput.val()!=""){
			var text=userLabelInput.val();
			  if(getByteLen(text)>10){
					alert("自定义标签不能超过10个字符");
			  }else{
				  $(".user-label-input").parent().html('<input id="userLabel7" type="checkbox"  name="items" checked value="'+text+'" /><label for="userLabel7">'+text+'</label>');
				  if($(this).parent().find("li").length>=11){

					  $(this).hide();
				  }else{
					  $("#CustomLabel").show();
				  }
			  }



		}else{
			alert("请自定义内容")
		}

	});
	/*加入购物车*/
	$("#addCart").off().on("click",function(e){
		e.preventDefault();
		var gid=$(this).attr("data-gid");
		var cid=$(this).attr("data-cid");
		var thumb=$(this).attr("data-thumb");
		var number=$('#number').val();
		
		// 商品套餐
		if($("#plans_id").length > 0) {
			var sid=$('#plans_id').val();
		} else {
			var sid=0;
		}
		addToCart(gid,cid,thumb,0,number,sid);
	})
	
	$("#addCart2").off().on("click",function(e){
		e.preventDefault();
		var gid=$(this).attr("data-gid");
		var cid=$(this).attr("data-cid");
		var thumb=$(this).attr("data-thumb");
		var effect=$(this).attr("data-effect");
		var number=$('#number').val();
		
		// 商品套餐
		if($("#plans_id").length > 0) {
			var sid=$('#plans_id').val();
		} else {
			var sid=0;
		}
		addToCart(gid,cid,thumb,effect,number,sid);
	})
	
	/*预约*/
	$("#addReservation").off().on("click",function(e){
		e.preventDefault();
		var gid=$(this).attr("data-gid");
		var goods = new Object();
		goods.quick    = 1;
		goods.goods_id = gid;
		goods.number   = 1;
		goods.effect   = 0;
		$.post("open.php", 'goods=' + $.toJSON(goods), addToCartResponse, "json");
	})
	
	/* *
	 * 添加商品到收藏夹
	 */
	$("#Favorites").off().on("click",function(){
		var gid=$(this).attr("data-gid");
		$.ajax({
			type: "GET",
			dataType:"JSON",
			url: "eventlib/goods.php?act=collect",
			data: 'id=' + gid,
			success: function(result){
				alert(result.message);
			}
		});
	});
	
	/*点击跳转到商品评价*/
	  $("#view_comment_count").off().on("click",function(){
		$(".goods-desc-menu li").each(function(index){
			if(index == 2) {
			    $(this).addClass("on");
			} else {
			    $(this).removeClass("on");
			}
		});
		$(".xlj-desc-box .xlj-box").each(function(index){
			if(index == 2) {
			    $(this).css({'display':'block'});
			} else {
			    $(this).css({'display':'none'});
			}
		});
		$("html,body").animate({scrollTop:$(".goods-desc-menu").offset().top},1000);
	});
	
	/*型号切换*/
	$(".goods-info-standard li").off().on("click",function(){
		if($(this).hasClass("select-on")){
			return;
		}else{
			$(this).addClass("select-on").siblings().removeClass("select-on");
			var gid = $(this).find("a").attr("data-gid");
			$.ajax({
				type: "POST",
				dataType:"JSON",
				url: "goods.php",
				data: 'event=1&id=' + gid,
				success: function(result){
					$(document).attr("title",result.title);
					$.getScript(result.js+"goods.js"+result.PARAMETER_CDN);
					pageload();
					$("#loadinfos").html(result.content);
				}
			});
		}
	});

	/*颜色切换*/
	$(".goods-info-color li").off().on("click",function(){
		if($(this).hasClass("select-on")){
			return;
		}else{
			$(this).addClass("select-on").siblings().removeClass("select-on");
			var gid = $(this).find("a").attr("data-gid");
			$.ajax({
				type: "POST",
				dataType:"JSON",
				url: "goods.php",
				data: 'event=1&id=' + gid,
				success: function(result){
					$(document).attr("title",result.title);
					$.getScript(result.js+"goods.js"+result.PARAMETER_CDN);
					pageload();
					$("#loadinfos").html(result.content);
				}
			});
		}
	});
	/*套餐切换*/
	$(".goods-info-plans li").off().on("click",function(){
		if($(this).hasClass("select-on")){
			return;
		}else{
			$(this).addClass("select-on").siblings().removeClass("select-on");
			var gid = $(this).find("a").attr("data-gid");
			var sid = $(this).find("a").attr("data-sid");
			$.ajax({
				type: "GET",
				dataType:"JSON",
				url: "eventlib/goods.php",
				data: 'act=plans_price&id=' + gid+ '&sid=' + sid,
				success: function(result){
					if($("#ECS_SHOPPRICE").length > 0) {
						$("#ECS_SHOPPRICE").html(result.price);
					} else {
						$(".price-num").html(result.price);
					}
					$("#plans_id").val(result.sid);
				}
			});
		}
	});
	
	/*数量切换*/
	  $("#DelNum").off().on("click",function(){
		var numInput=$(this).parent().find("#number");
		var num=$(this).parent().find("#number").val();

		if(num>1){
			num--;
			numInput.val(num);
		}else{return}
	});
	$("#AddNum").off().on("click",function(){
		var numInput=$(this).parent().find("#number");
		var num=$(this).parent().find("#number").val();

		if(num<1){
			return;
		}else{
			num++;
			numInput.val(num);}
	});
	/*加载更多数据*/
	$(".more").off().on("click",function(){
			var _this=this;
		   var parent= $(this).parent().parent().parent().attr("id");
		   var ul=$(this).parent().find("ul");
		   var text=$(this).html();
		   if(parent&&parent=="Faqs"){
			   $.ajax({

				   type: "GET",
				   dataType:"JSON",
				   url: "test.json",
				   data: null,
				   beforeSend:function(){
						$(_this).html("加载中……");
				   },
				   complete:function(){
					   $(_this).html(text);
				   },
					   success: function(result){
							var x=5;
							var list=[];
							if(x<1){
								alert("没有更多留言");
							}else{
								for(var i=0;i<x;i++){
									list.push('<li>');
									list.push('<h2><span>?</span>收藏商品功能'+i+'</h2>');
									list.push('<p><span>··</span>点击"收藏"按钮，页面会弹出收藏成功的提示。您可在"个人中心"的我的收藏查看所有收藏商品。在我的收藏中可以选择加入购物车，或删除已收藏的商品。</p>');
									list.push('</li>')
								}
								$(list.join("")).appendTo(ul);
							}


				   }
			   });
		   }else if(parent&&parent=="goodsFaq"){
			   $.ajax({

				   type: "GET",
				   dataType:"JSON",
				   url: "test.json",
				   data: null,
				   beforeSend:function(){
					   $(_this).html("加载中……");
				   },
				   complete:function(){
					   $(_this).html(text);
				   },
				   success: function(result){
					   var x=5;
					   var list=[];
					   if(x<1){
						   alert("没有更多留言");
					   }else{
						   for(var i=0;i<x;i++){
							   list.push('<li>');
							   list.push('<h2><span>?</span><strong>咨询内容：</strong>'+i+'</h2>');
							   list.push('<p><span>··</span><strong>小辣椒商城回复：</strong>页面会弹出收藏成功的提示。您可在"个人中心"的我的收藏查看所有收藏商品。在我的收藏中可以选择加入购物车，或删除已收藏的商品。</p>');
							   list.push('</li>')
						   }
						   $(list.join("")).appendTo(ul);
					   }


				   }
			   });
		   }else if(parent&&parent=="UserEvaluation"){


			  var num= ($("#"+parent).find(".all-percent li")).index($(".all-percent li.on")[0])
			   $.ajax({

				   type: "GET",
				   dataType:"JSON",
				   url: "eventlib/goods.php?act=comment_more",
				   data: "goods_id="+$('#goods_id').val()+'&more_num='+$('#more_num').val()+'&comment_type='+$('#comment_type').val(),
				   beforeSend:function(){
					   $(_this).html("加载中……");
				   },
				   complete:function(){
					   $(_this).html(text);
				   },
				   success: function(result){
					   $('#AllPercent').last().append(result.message);
					   $("#more_num").val(result.more_num);
					   if(result.data_num != 5) {
						   $(".more").hide();
					   }
				   }
			   });
		   }

	});
	/*表单提交*/
	$("#ContentSub").off().on("click",function(e){
		e.stopPropagation();
		e.preventDefault();
		var ConsultContent=$("#ConsultContent").val();
		var str="";
		var stat=$('[name=comment_rank]:radio:checked').val();

		if($(this).attr("data-val") == 1){
			alert("评论已经提交, 请等待显示!");
			return false;
		}

		$('[name=items]:checkbox:checked').each(function(){
			str += $(this).val()+',';
		});
		if(ConsultContent==""){
			alert("您尚未输入评论内容!");
			return;
		}
		else if(getByteLen(ConsultContent)>300){
			alert("您输入的咨询内容超过字数限制，请减少字数输入！")
		}
		 $.ajax({
			type: "POST",
			dataType:"JSON",
			url: "eventlib/goods.php?act=comment_insert",
			data: "goods_id="+$('#goods_id').val()+"&comment_rank="+stat+"&content="+$('#ConsultContent').val()+"&items="+str,
			success: function(result){
				if(result.error == 2) {
					if(confirm(result.message)) {
						location = result.url;
					}
				} else 
				if(result.error == 5) {
					alert(result.message);
					$('#ConsultContent').val('');
					$("#ContentSub").attr("data-val",1);
				} else 
					alert(result.message);
				}
		 });
	});
	
	 /*
	 * 切换评论类型
	 */
	$("#percentComment li").on("click",function(){
		var comment_type = 0;
		var code = $(this).attr("data-code");
		var nums = $(this).attr("data-num");
		
		if(nums < 1) {
		    return false;
		}
		
		var AllPercent = $('#AllPercent');
		if(code == 'GoodPercent') {
			comment_type = 1;
		} else 
		if(code == 'GeneralPercent') {
			comment_type = 2;
		} else 
		if(code == 'BadPercent') {
			comment_type = 3;
		}
		$.ajax({
		   type: "GET",
		   dataType:"JSON",
		   url: "eventlib/goods.php?act=comment_more",
		   data: "goods_id="+$('#goods_id').val()+'&more_num=0&comment_type='+comment_type,
		   beforeSend:function(){
			   $(AllPercent).html("加载中……");
		   },
		   success: function(result){
			   $(AllPercent).html(result.message);
			   $("#more_num").val(result.more_num);
			   $("#comment_type").val(comment_type);
			   if(result.data_num != 5) {
				   $(".more").hide();
			   } else {
				   $(".more").show();
			   }
		   }
		});
	});
    $(document).off("click","#close").on("click","#close",function(e){
        e.stopPropagation();
        $("#dialog-modal").dialog("close");
    });
    $(document).off("click","#ArrivalSubmit").on("click","#ArrivalSubmit",function(){
        var ArrivalTel=$("#ArrivalTel").val(),
            ArrivalEmail=$("#ArrivalEmail").val(),
            tel=/^1[3|4|5|8|7][0-9]\d{8}$/,
            temail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)/;
        if(ArrivalTel==""){
            alert("联系电话不能为空！");
            return;
        }else if(!tel.test(ArrivalTel)){
            alert("联系电话不正确！");
            return;
        }else if(ArrivalEmail==""){
            alert("电子邮箱不能为空！");
        }else if(!temail.test(ArrivalEmail)){
            alert("电子邮箱不正确！");
        }else{
            $("#dialog-modal").dialog("close");
		    document.forms['out_of_stock'].submit();
            return true;
        }
    })
})

/*加载指定参数*/
function pageload(){
	$(".xlj-prodesc").slide({titCell:".goods-desc-menu li",mainCell:".xlj-desc-box"});
	$("#UserEvaluation").slide({titCell:".all-percent li",mainCell:".goods-percent"});
	$(".imgInfo").slide({mainCell:".imgInfo_img ul",effect:"left",titCell:".picture img",titOnClassName:"onbg",prevCell:"#goodsPicPrev",nextCell:"#goodsPicNext",trigger:"click"});
	$("img.lazy").lazyload({
		threshold : 200,
		effect : "fadeIn",
		placeholder : "http://theme.xiaolajiao.com/themes/newxlj/images/placeholder.gif"
	});
}

/*详情页滚动BAR*/
$(function(){

    var desc_top = $(".xlj-prodesc").offset().top;



    $(window).scroll(function(){
        if ($(window).scrollTop() > $(".xlj-prodesc").offset().top + 52){
            $("#goodsSubBar").show().addClass("goods-sub-bar-play");
            var goodLi=$(".goods-desc-menu ul li");
            for(var mi=0;mi<goodLi.length;mi++){
                if($(goodLi[mi]).hasClass('on')){
                    $("#goodsSubMenu ul li").eq(mi).addClass("on").siblings().removeClass("on");
                }
            }


        }else{
            $("#goodsSubBar").hide().removeClass("goods-sub-bar-play");
        }

    });

    $("#goodsSubMenu ul li").on("click",function(){
        $(this).addClass("on").siblings().removeClass("on")
        var i = $(this).index();
        $(".goods-desc-menu ul li").eq(i).click();
        $("html,body").animate({scrollTop:$(".xlj-prodesc").offset().top})
    })
})