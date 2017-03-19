package com.ecej.controller;

import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.ProjectPo;
import com.ecej.uc.service.ProjectService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("project")
public class ProjectController {
	@Resource
	private ProjectService projectService;
	@RequestMapping("/add")
	@ResponseBody
	public ResultModel<?> add(@RequestBody ProjectPo po,HttpSession session){
		ResultModel rm = new ResultModel();
		String uid = (String)session.getAttribute("globalUserId");
		po.setUid(Integer.parseInt(uid));
		rm = projectService.addProject(po);
		return rm;
	}
	@RequestMapping("/update")
	@ResponseBody
	public ResultModel<?>  update(@RequestBody ProjectPo po,HttpSession session){
		ResultModel rm = new ResultModel();
		String uid = (String)session.getAttribute("globalUserId");
		po.setUid(Integer.parseInt(uid));
		rm = projectService.updateProject(po);
		return rm;
	}
	@RequestMapping("/getList")
	@ResponseBody
	public List<ProjectPo> getList(HttpSession session){
		ProjectPo po = new ProjectPo();
		String uid = (String)session.getAttribute("globalUserId");
		po.setUid(Integer.parseInt(uid));
		return projectService.selectList(po);
	}
	@RequestMapping("/getById")
	@ResponseBody
	public ProjectPo getById(@RequestBody ProjectPo po,HttpSession session){
		String uid = (String)session.getAttribute("globalUserId");
		po.setUid(Integer.parseInt(uid));
		return projectService.selectById(po);
	}
}
