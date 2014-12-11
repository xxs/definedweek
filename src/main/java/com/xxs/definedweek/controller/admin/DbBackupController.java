package com.xxs.definedweek.controller.admin;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.xxs.definedweek.Message;
import com.xxs.definedweek.Pageable;
import com.xxs.definedweek.util.dbbackup.DbBackupExcutor;
import com.xxs.definedweek.util.dbbackup.PathResolver;
import com.xxs.definedweek.util.dbbackup.WebFile;

/**
 * Controller - 数据库备份
 */

@Controller("adminDbBackupController")
@RequestMapping("/admin/db_backup")
public class DbBackupController extends BaseController {
	
	@Autowired
	private PathResolver pathResolver;
	@Autowired
	private DbBackupExcutor excutor;
	
	private static final Logger logger = LoggerFactory
			.getLogger(DbBackupController.class);
	public static final String BACKUP_PATH = "/WEB-INF/db_backup";

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String list(HttpServletRequest request,Pageable pageable, ModelMap model) {
		String realPath = pathResolver.getPath(BACKUP_PATH);
		File parent = new File(realPath);
		WebFile parentWebFile = new WebFile(parent, parent.getAbsolutePath(),
				request.getContextPath());
		List<WebFile> list = parentWebFile.listFiles();
		model.addAttribute("list", list);
		return "/admin/db_backup/list";
	}

	@RequestMapping("/backup")
	public String backup(HttpServletRequest request, RedirectAttributes redirectAttributes) {
		File dir = new File(pathResolver.getPath(BACKUP_PATH));
		excutor.backup(dir, false);
		logger.info("database backup");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list.jhtml";
	}

	@RequestMapping("/restore")
	public String restore(String id, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		File file = new File(pathResolver.getPath(BACKUP_PATH), id);
		excutor.restore(file);
		logger.info("database restore");
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:list.jhtml";
	}

	@RequestMapping("download.do")
	public String download(String id, HttpServletRequest request,
			org.springframework.ui.Model modelMap) {
		return null;
	}

	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public @ResponseBody
	Message delete(String[] ids, Integer querySlotId,
			RedirectAttributes ra) {
		for (String id : ids) {
			File file = new File(pathResolver.getPath(BACKUP_PATH), id);
			FileUtils.deleteQuietly(file);
		}
		return SUCCESS_MESSAGE;
	}

}
