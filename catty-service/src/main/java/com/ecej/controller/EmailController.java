package com.ecej.controller;

import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.EmaillistPo;
import com.ecej.uc.po.ExpensePo;
import com.ecej.uc.service.EmaillistService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("Emaillist")
public class EmailController {
	@Resource
	private EmaillistService emaillistService;
	@RequestMapping("/add")
	@ResponseBody
	public ResultModel<?> add(@RequestBody EmaillistPo po,HttpSession session){
		ResultModel rm = new ResultModel();
		String uid = (String)session.getAttribute("globalUserId");
		po.setUid(Integer.parseInt(uid));
		rm = emaillistService.addEmaillist(po);
		return rm;
	}
	@RequestMapping("/update")
	@ResponseBody
	public ResultModel<?>  update(@RequestBody EmaillistPo po,HttpSession session){
		ResultModel rm = new ResultModel();
		String uid = (String)session.getAttribute("globalUserId");
		po.setUid(Integer.parseInt(uid));
		rm = emaillistService.updateEmaillist(po);
		return rm;
	}
	@RequestMapping("/getList")
	@ResponseBody
    public List<EmaillistPo> getList(int pid, HttpSession session) {
        EmaillistPo po = new EmaillistPo();
        po.setPid(pid);
        String uid = (String) session.getAttribute("globalUserId");
        po.setUid(Integer.parseInt(uid));
		return emaillistService.selectList(po);
	}
	@RequestMapping("/getById")
	@ResponseBody
	public EmaillistPo getById(@RequestBody EmaillistPo po,HttpSession session){
		String uid = (String)session.getAttribute("globalUserId");
		po.setUid(Integer.parseInt(uid));
		return emaillistService.selectById(po);
	}

    @RequestMapping("/delEmaillist")
    @ResponseBody
    public ResultModel<?> delExpenses(@RequestBody EmaillistPo po, HttpSession session) {
        ResultModel rm = new ResultModel();
        rm = emaillistService.delEmaillist(po);
        return rm;
    }
}
