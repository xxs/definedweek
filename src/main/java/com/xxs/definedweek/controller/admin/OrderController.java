package com.xxs.definedweek.controller.admin;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.xxs.definedweek.Message;
import com.xxs.definedweek.Pageable;
import com.xxs.definedweek.entity.Admin;
import com.xxs.definedweek.entity.Member;
import com.xxs.definedweek.entity.Order;
import com.xxs.definedweek.entity.Order.OrderStatus;
import com.xxs.definedweek.entity.Order.PaymentStatus;
import com.xxs.definedweek.entity.OrderItem;
import com.xxs.definedweek.entity.Payment;
import com.xxs.definedweek.entity.Payment.Status;
import com.xxs.definedweek.entity.Payment.Type;
import com.xxs.definedweek.entity.PaymentMethod;
import com.xxs.definedweek.entity.Product;
import com.xxs.definedweek.entity.Sn;
import com.xxs.definedweek.service.AdminService;
import com.xxs.definedweek.service.AreaService;
import com.xxs.definedweek.service.OrderItemService;
import com.xxs.definedweek.service.OrderService;
import com.xxs.definedweek.service.PaymentMethodService;
import com.xxs.definedweek.service.ProductService;
import com.xxs.definedweek.service.SnService;

/**
 * Controller - 订单
 */
@Controller("adminOrderController")
@RequestMapping("/admin/order")
public class OrderController extends BaseController {

	@Resource(name = "adminServiceImpl")
	private AdminService adminService;
	@Resource(name = "areaServiceImpl")
	private AreaService areaService;
	@Resource(name = "productServiceImpl")
	private ProductService productService;
	@Resource(name = "orderServiceImpl")
	private OrderService orderService;
	@Resource(name = "orderItemServiceImpl")
	private OrderItemService orderItemService;
	@Resource(name = "paymentMethodServiceImpl")
	private PaymentMethodService paymentMethodService;
	@Resource(name = "snServiceImpl")
	private SnService snService;

	/**
	 * 检查锁定
	 */
	@RequestMapping(value = "/check_lock", method = RequestMethod.POST)
	public @ResponseBody
	Message checkLock(Long id) {
		Order order = orderService.find(id);
		if (order == null) {
			return Message.warn("admin.common.invalid");
		}
		Admin admin = adminService.getCurrent();
		if (order.isLocked(admin)) {
			if (order.getOperator() != null) {
				return Message.warn("admin.order.adminLocked", order.getOperator().getUsername());
			} else {
				return Message.warn("admin.order.memberLocked");
			}
		} else {
			order.setLockExpire(DateUtils.addSeconds(new Date(), 20));
			order.setOperator(admin);
			orderService.update(order);
			return SUCCESS_MESSAGE;
		}
	}

	/**
	 * 查看
	 */
	@RequestMapping(value = "/view", method = RequestMethod.GET)
	public String view(Long id, ModelMap model) {
		model.addAttribute("methods", Payment.Method.values());
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("order", orderService.find(id));
		return "/admin/order/view";
	}

	/**
	 * 确认
	 */
	@RequestMapping(value = "/confirm", method = RequestMethod.POST)
	public String confirm(Long id, RedirectAttributes redirectAttributes) {
		Order order = orderService.find(id);
		Admin admin = adminService.getCurrent();
		if (order != null && !order.isExpired() && order.getOrderStatus() == OrderStatus.unconfirmed && !order.isLocked(admin)) {
			orderService.confirm(order, admin);
			addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		} else {
			addFlashMessage(redirectAttributes, Message.warn("admin.common.invalid"));
		}
		return "redirect:view.jhtml?id=" + id;
	}

	/**
	 * 完成
	 */
	@RequestMapping(value = "/complete", method = RequestMethod.POST)
	public String complete(Long id, RedirectAttributes redirectAttributes) {
		Order order = orderService.find(id);
		Admin admin = adminService.getCurrent();
		if (order != null && !order.isExpired() && order.getOrderStatus() == OrderStatus.confirmed && !order.isLocked(admin)) {
			orderService.complete(order, admin);
			addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		} else {
			addFlashMessage(redirectAttributes, Message.warn("admin.common.invalid"));
		}
		return "redirect:view.jhtml?id=" + id;
	}

	/**
	 * 取消
	 */
	@RequestMapping(value = "/cancel", method = RequestMethod.POST)
	public String cancel(Long id, RedirectAttributes redirectAttributes) {
		Order order = orderService.find(id);
		Admin admin = adminService.getCurrent();
		if (order != null && !order.isExpired() && order.getOrderStatus() == OrderStatus.unconfirmed && !order.isLocked(admin)) {
			orderService.cancel(order, admin);
			addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		} else {
			addFlashMessage(redirectAttributes, Message.warn("admin.common.invalid"));
		}
		return "redirect:view.jhtml?id=" + id;
	}

	/**
	 * 支付
	 */
	@RequestMapping(value = "/payment", method = RequestMethod.POST)
	public String payment(Long orderId, Long paymentMethodId, Payment payment, RedirectAttributes redirectAttributes) {
		Order order = orderService.find(orderId);
		payment.setOrder(order);
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		payment.setPaymentMethod(paymentMethod != null ? paymentMethod.getName() : null);
		if (!isValid(payment)) {
			return ERROR_VIEW;
		}
		if (order.isExpired() || order.getOrderStatus() != OrderStatus.confirmed) {
			return ERROR_VIEW;
		}
		if (order.getPaymentStatus() != PaymentStatus.unpaid && order.getPaymentStatus() != PaymentStatus.partialPayment) {
			return ERROR_VIEW;
		}
		if (payment.getAmount().compareTo(new BigDecimal(0)) <= 0 || payment.getAmount().compareTo(order.getAmountPayable()) > 0) {
			return ERROR_VIEW;
		}
		Member member = order.getMember();
		if (payment.getMethod() == Payment.Method.deposit && payment.getAmount().compareTo(member.getBalance()) > 0) {
			return ERROR_VIEW;
		}
		Admin admin = adminService.getCurrent();
		if (order.isLocked(admin)) {
			return ERROR_VIEW;
		}
		payment.setSn(snService.generate(Sn.Type.payment));
		payment.setType(Type.payment);
		payment.setStatus(Status.success);
		payment.setFee(new BigDecimal(0));
		payment.setOperator(admin.getUsername());
		payment.setPaymentDate(new Date());
		payment.setPaymentPluginId(null);
		payment.setExpire(null);
		payment.setDeposit(null);
		payment.setMember(null);
		orderService.payment(order, payment, admin);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:view.jhtml?id=" + orderId;
	}

	/**
	 * 编辑
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.GET)
	public String edit(Long id, ModelMap model) {
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("order", orderService.find(id));
		return "/admin/order/edit";
	}

	/**
	 * 订单项添加
	 */
	@RequestMapping(value = "/order_item_add", method = RequestMethod.POST)
	public @ResponseBody
	Map<String, Object> orderItemAdd(String productSn) {
		Map<String, Object> data = new HashMap<String, Object>();
		Product product = productService.findBySn(productSn);
		if (product == null) {
			data.put("message", Message.warn("admin.order.productNotExist"));
			return data;
		}
		if (!product.getIsMarketable()) {
			data.put("message", Message.warn("admin.order.productNotMarketable"));
			return data;
		}
		data.put("sn", product.getSn());
		data.put("fullName", product.getFullName());
		data.put("price", product.getPrice());
		data.put("isGift", product.getIsGift());
		data.put("message", SUCCESS_MESSAGE);
		return data;
	}

	/**
	 * 计算
	 */
	@RequestMapping(value = "/calculate", method = RequestMethod.POST)
	public @ResponseBody
	Map<String, Object> calculate(Order order, Long areaId, Long paymentMethodId, Long shippingMethodId) {
		Map<String, Object> data = new HashMap<String, Object>();
		for (Iterator<OrderItem> iterator = order.getOrderItems().iterator(); iterator.hasNext();) {
			OrderItem orderItem = iterator.next();
			if (orderItem == null || StringUtils.isEmpty(orderItem.getSn())) {
				iterator.remove();
			}
		}
		order.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(order)) {
			data.put("message", Message.warn("admin.common.invalid"));
			return data;
		}
		Order pOrder = orderService.find(order.getId());
		if (pOrder == null) {
			data.put("message", Message.error("admin.common.invalid"));
			return data;
		}
		for (OrderItem orderItem : order.getOrderItems()) {
			if (orderItem.getId() != null) {
				OrderItem pOrderItem = orderItemService.find(orderItem.getId());
				if (pOrderItem == null || !pOrder.equals(pOrderItem.getOrder())) {
					data.put("message", Message.error("admin.common.invalid"));
					return data;
				}
				Product product = pOrderItem.getProduct();
			} else {
				Product product = productService.findBySn(orderItem.getSn());
				if (product == null) {
					data.put("message", Message.error("admin.common.invalid"));
					return data;
				}
			}
		}
		Map<String, Object> orderItems = new HashMap<String, Object>();
		for (OrderItem orderItem : order.getOrderItems()) {
			orderItems.put(orderItem.getSn(), orderItem);
		}
		order.setPromotionDiscount(pOrder.getPromotionDiscount());
		order.setCouponDiscount(pOrder.getCouponDiscount());
		order.setAmountPaid(pOrder.getAmountPaid());
		data.put("price", order.getPrice());
		data.put("amount", order.getAmount());
		data.put("orderItems", orderItems);
		data.put("message", SUCCESS_MESSAGE);
		return data;
	}

	/**
	 * 更新
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String update(Order order, Long areaId, Long paymentMethodId, Long shippingMethodId, RedirectAttributes redirectAttributes) {
		for (Iterator<OrderItem> iterator = order.getOrderItems().iterator(); iterator.hasNext();) {
			OrderItem orderItem = iterator.next();
			if (orderItem == null || StringUtils.isEmpty(orderItem.getSn())) {
				iterator.remove();
			}
		}
		order.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(order)) {
			return ERROR_VIEW;
		}
		Order pOrder = orderService.find(order.getId());
		if (pOrder == null) {
			return ERROR_VIEW;
		}
		if (pOrder.isExpired() || pOrder.getOrderStatus() != OrderStatus.unconfirmed) {
			return ERROR_VIEW;
		}
		Admin admin = adminService.getCurrent();
		if (pOrder.isLocked(admin)) {
			return ERROR_VIEW;
		}
		if (!order.getIsInvoice()) {
			order.setInvoiceTitle(null);
			order.setTax(new BigDecimal(0));
		}
		for (OrderItem orderItem : order.getOrderItems()) {
			if (orderItem.getId() != null) {
				OrderItem pOrderItem = orderItemService.find(orderItem.getId());
				if (pOrderItem == null || !pOrder.equals(pOrderItem.getOrder())) {
					return ERROR_VIEW;
				}
				Product product = pOrderItem.getProduct();
				BeanUtils.copyProperties(pOrderItem, orderItem, new String[] { "price", "quantity" });
				if (pOrderItem.getIsGift()) {
					orderItem.setPrice(new BigDecimal(0));
				}
			} else {
				Product product = productService.findBySn(orderItem.getSn());
				if (product == null) {
					return ERROR_VIEW;
				}
				orderItem.setName(product.getName());
				orderItem.setFullName(product.getFullName());
				if (product.getIsGift()) {
					orderItem.setPrice(new BigDecimal(0));
				}
				orderItem.setThumbnail(product.getThumbnail());
				orderItem.setIsGift(product.getIsGift());
				orderItem.setProduct(product);
				orderItem.setOrder(pOrder);
			}
		}
		order.setSn(pOrder.getSn());
		order.setOrderStatus(pOrder.getOrderStatus());
		order.setPaymentStatus(pOrder.getPaymentStatus());
		order.setPromotionDiscount(pOrder.getPromotionDiscount());
		order.setCouponDiscount(pOrder.getCouponDiscount());
		order.setAmountPaid(pOrder.getAmountPaid());
		order.setPromotion(pOrder.getPromotion());
		order.setExpire(pOrder.getExpire());
		order.setLockExpire(null);
		order.setOperator(null);
		order.setMember(pOrder.getMember());
		order.setCouponCode(pOrder.getCouponCode());
		order.setCoupons(pOrder.getCoupons());
		order.setOrderLogs(pOrder.getOrderLogs());
		order.setDeposits(pOrder.getDeposits());
		order.setPayments(pOrder.getPayments());

		orderService.update(order, admin);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list.jhtml";
	}

	/**
	 * 列表
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(OrderStatus orderStatus, PaymentStatus paymentStatus, Boolean hasExpired, Pageable pageable, ModelMap model) {
		model.addAttribute("orderStatus", orderStatus);
		model.addAttribute("paymentStatus", paymentStatus);
		model.addAttribute("hasExpired", hasExpired);
		model.addAttribute("page", orderService.findPage(orderStatus, paymentStatus, hasExpired, pageable));
		return "/admin/order/list";
	}

	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public @ResponseBody
	Message delete(Long[] ids) {
		if (ids != null) {
			Admin admin = adminService.getCurrent();
			for (Long id : ids) {
				Order order = orderService.find(id);
				if (order != null && order.isLocked(admin)) {
					return Message.error("admin.order.deleteLockedNotAllowed", order.getSn());
				}
			}
			orderService.delete(ids);
		}
		return SUCCESS_MESSAGE;
	}

}