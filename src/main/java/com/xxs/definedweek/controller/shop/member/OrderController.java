package com.xxs.definedweek.controller.shop.member;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xxs.definedweek.Message;
import com.xxs.definedweek.Pageable;
import com.xxs.definedweek.controller.shop.BaseController;
import com.xxs.definedweek.entity.Cart;
import com.xxs.definedweek.entity.Coupon;
import com.xxs.definedweek.entity.CouponCode;
import com.xxs.definedweek.entity.Member;
import com.xxs.definedweek.entity.Order;
import com.xxs.definedweek.entity.Order.OrderStatus;
import com.xxs.definedweek.entity.Order.PaymentStatus;
import com.xxs.definedweek.entity.PaymentMethod;
import com.xxs.definedweek.plugin.PaymentPlugin;
import com.xxs.definedweek.service.AreaService;
import com.xxs.definedweek.service.CartService;
import com.xxs.definedweek.service.CouponCodeService;
import com.xxs.definedweek.service.MemberService;
import com.xxs.definedweek.service.OrderService;
import com.xxs.definedweek.service.PaymentMethodService;
import com.xxs.definedweek.service.PluginService;

/**
 * Controller - 会员中心 - 订单
 */
@Controller("shopMemberOrderController")
@RequestMapping("/member/order")
public class OrderController extends BaseController {

	/** 每页记录数 */
	private static final int PAGE_SIZE = 10;

	@Resource(name = "memberServiceImpl")
	private MemberService memberService;
	@Resource(name = "areaServiceImpl")
	private AreaService areaService;
	@Resource(name = "cartServiceImpl")
	private CartService cartService;
	@Resource(name = "paymentMethodServiceImpl")
	private PaymentMethodService paymentMethodService;
	@Resource(name = "couponCodeServiceImpl")
	private CouponCodeService couponCodeService;
	@Resource(name = "orderServiceImpl")
	private OrderService orderService;
	@Resource(name = "pluginServiceImpl")
	private PluginService pluginService;

	/**
	 * 订单锁定
	 */
	@RequestMapping(value = "/lock", method = RequestMethod.POST)
	public @ResponseBody
	boolean lock(String sn) {
		Order order = orderService.findBySn(sn);
		if (order != null && memberService.getCurrent().equals(order.getMember()) && !order.isExpired() && !order.isLocked(null) && order.getPaymentMethod() != null && order.getPaymentMethod().getMethod() == PaymentMethod.Method.online && (order.getPaymentStatus() == PaymentStatus.unpaid || order.getPaymentStatus() == PaymentStatus.partialPayment)) {
			order.setLockExpire(DateUtils.addSeconds(new Date(), 20));
			order.setOperator(null);
			orderService.update(order);
			return true;
		}
		return false;
	}

	/**
	 * 检查支付
	 */
	@RequestMapping(value = "/check_payment", method = RequestMethod.POST)
	public @ResponseBody
	boolean checkPayment(String sn) {
		Order order = orderService.findBySn(sn);
		if (order != null && memberService.getCurrent().equals(order.getMember()) && order.getPaymentStatus() == PaymentStatus.paid) {
			return true;
		}
		return false;
	}

	/**
	 * 优惠券信息
	 */
	@RequestMapping(value = "/coupon_info", method = RequestMethod.POST)
	public @ResponseBody
	Map<String, Object> couponInfo(String code) {
		Map<String, Object> data = new HashMap<String, Object>();
		Cart cart = cartService.getCurrent();
		if (cart == null || cart.isEmpty()) {
			data.put("message", Message.warn("shop.order.cartNotEmpty"));
			return data;
		}
		if (!cart.isCouponAllowed()) {
			data.put("message", Message.warn("shop.order.couponNotAllowed"));
			return data;
		}
		CouponCode couponCode = couponCodeService.findByCode(code);
		if (couponCode != null && couponCode.getCoupon() != null) {
			Coupon coupon = couponCode.getCoupon();
			if (!coupon.getIsEnabled()) {
				data.put("message", Message.warn("shop.order.couponDisabled"));
				return data;
			}
			if (!coupon.hasBegun()) {
				data.put("message", Message.warn("shop.order.couponNotBegin"));
				return data;
			}
			if (coupon.hasExpired()) {
				data.put("message", Message.warn("shop.order.couponHasExpired"));
				return data;
			}
			if (!cart.isValid(coupon)) {
				data.put("message", Message.warn("shop.order.couponInvalid"));
				return data;
			}
			if (couponCode.getIsUsed()) {
				data.put("message", Message.warn("shop.order.couponCodeUsed"));
				return data;
			}
			data.put("message", SUCCESS_MESSAGE);
			data.put("couponName", coupon.getName());
			return data;
		} else {
			data.put("message", Message.warn("shop.order.couponCodeNotExist"));
			return data;
		}
	}

	/**
	 * 信息
	 */
	@RequestMapping(value = "/info", method = RequestMethod.GET)
	public String info(ModelMap model) {
		Cart cart = cartService.getCurrent();
		if (cart == null || cart.isEmpty()) {
			return "redirect:/cart/list.jhtml";
		}
		if (!isValid(cart)) {
			return ERROR_VIEW;
		}
		Order order = orderService.build(cart, null, null, false, null, false, null);
		model.addAttribute("order", order);
		model.addAttribute("cartToken", cart.getToken());
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		return "/shop/member/order/info";
	}

	/**
	 * 计算
	 */
	@RequestMapping(value = "/calculate", method = RequestMethod.POST)
	public @ResponseBody
	Map<String, Object> calculate(Long paymentMethodId, Long shippingMethodId, String code, @RequestParam(defaultValue = "false") Boolean isInvoice, String invoiceTitle, @RequestParam(defaultValue = "false") Boolean useBalance, String memo) {
		Map<String, Object> data = new HashMap<String, Object>();
		Cart cart = cartService.getCurrent();
		if (cart == null || cart.isEmpty()) {
			data.put("message", Message.error("shop.order.cartNotEmpty"));
			return data;
		}
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		CouponCode couponCode = couponCodeService.findByCode(code);
		Order order = orderService.build(cart, paymentMethod, couponCode, isInvoice, invoiceTitle, useBalance, memo);

		data.put("message", SUCCESS_MESSAGE);
		data.put("price", order.getPrice());
		data.put("promotionDiscount", order.getPromotionDiscount());
		data.put("couponDiscount", order.getCouponDiscount());
		data.put("tax", order.getTax());
		data.put("amountPayable", order.getAmountPayable());
		return data;
	}

	/**
	 * 创建
	 */
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public @ResponseBody
	Message create(String cartToken, Long receiverId, Long paymentMethodId, Long shippingMethodId, String code, @RequestParam(defaultValue = "false") Boolean isInvoice, String invoiceTitle, @RequestParam(defaultValue = "false") Boolean useBalance, String memo) {
		Cart cart = cartService.getCurrent();
		if (cart == null || cart.isEmpty()) {
			return Message.warn("shop.order.cartNotEmpty");
		}
		if (!StringUtils.equals(cart.getToken(), cartToken)) {
			return Message.warn("shop.order.cartHasChanged");
		}
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		if (paymentMethod == null) {
			return Message.error("shop.order.paymentMethodNotExsit");
		}
		CouponCode couponCode = couponCodeService.findByCode(code);
		Order order = orderService.create(cart, paymentMethod, couponCode, isInvoice, invoiceTitle, useBalance, memo, null);
		return Message.success(order.getSn());
	}

	/**
	 * 支付
	 */
	@RequestMapping(value = "/payment", method = RequestMethod.GET)
	public String payment(String sn, ModelMap model) {
		Order order = orderService.findBySn(sn);
		if (order == null || !memberService.getCurrent().equals(order.getMember()) || order.isExpired() || order.getPaymentMethod() == null) {
			return ERROR_VIEW;
		}
		if (order.getPaymentMethod().getMethod() == PaymentMethod.Method.online) {
			List<PaymentPlugin> paymentPlugins = pluginService.getPaymentPlugins(true);
			if (!paymentPlugins.isEmpty()) {
				PaymentPlugin defaultPaymentPlugin = paymentPlugins.get(0);
				if (order.getPaymentStatus() == PaymentStatus.unpaid || order.getPaymentStatus() == PaymentStatus.partialPayment) {
					model.addAttribute("fee", defaultPaymentPlugin.calculateFee(order.getAmountPayable()));
					model.addAttribute("amount", defaultPaymentPlugin.calculateAmount(order.getAmountPayable()));
				}
				model.addAttribute("defaultPaymentPlugin", defaultPaymentPlugin);
				model.addAttribute("paymentPlugins", paymentPlugins);
			}
		}
		model.addAttribute("order", order);
		return "/shop/member/order/payment";
	}

	/**
	 * 计算支付金额
	 */
	@RequestMapping(value = "/calculate_amount", method = RequestMethod.POST)
	public @ResponseBody
	Map<String, Object> calculateAmount(String paymentPluginId, String sn) {
		Map<String, Object> data = new HashMap<String, Object>();
		Order order = orderService.findBySn(sn);
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		if (order == null || !memberService.getCurrent().equals(order.getMember()) || order.isExpired() || order.isLocked(null) || order.getPaymentMethod() == null || order.getPaymentMethod().getMethod() == PaymentMethod.Method.offline || paymentPlugin == null || !paymentPlugin.getIsEnabled()) {
			data.put("message", ERROR_MESSAGE);
			return data;
		}
		data.put("message", SUCCESS_MESSAGE);
		data.put("fee", paymentPlugin.calculateFee(order.getAmountPayable()));
		data.put("amount", paymentPlugin.calculateAmount(order.getAmountPayable()));
		return data;
	}

	/**
	 * 列表
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(Integer pageNumber, ModelMap model) {
		Member member = memberService.getCurrent();
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", orderService.findPage(member, pageable));
		return "shop/member/order/list";
	}

	/**
	 * 查看
	 */
	@RequestMapping(value = "/view", method = RequestMethod.GET)
	public String view(String sn, ModelMap model) {
		Order order = orderService.findBySn(sn);
		if (order == null) {
			return ERROR_VIEW;
		}
		Member member = memberService.getCurrent();
		if (!member.getOrders().contains(order)) {
			return ERROR_VIEW;
		}
		model.addAttribute("order", order);
		return "shop/member/order/view";
	}

	/**
	 * 取消
	 */
	@RequestMapping(value = "/cancel", method = RequestMethod.POST)
	public @ResponseBody
	Message cancel(String sn) {
		Order order = orderService.findBySn(sn);
		if (order != null && memberService.getCurrent().equals(order.getMember()) && !order.isExpired() && order.getOrderStatus() == OrderStatus.unconfirmed && order.getPaymentStatus() == PaymentStatus.unpaid) {
			if (order.isLocked(null)) {
				return Message.warn("shop.member.order.locked");
			}
			orderService.cancel(order, null);
			return SUCCESS_MESSAGE;
		}
		return ERROR_MESSAGE;
	}
}