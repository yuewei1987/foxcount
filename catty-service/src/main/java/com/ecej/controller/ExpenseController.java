package com.ecej.controller;

import com.alibaba.druid.util.StringUtils;
import com.ecej.uc.dto.PageView;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.ExpensePo;
import com.ecej.uc.service.ExpenseService;
import com.ecej.uc.vo.ExpenseVo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("expense")
public class ExpenseController {
    @Resource
    private ExpenseService ExpenseService;

    @RequestMapping("/add")
    @ResponseBody
    public ResultModel<?> add(@RequestBody ExpensePo po, HttpSession session) {
        ResultModel rm = new ResultModel();
        ExpensePo newpo = ExpenseService.selectById(po);
        if (newpo != null) {
            rm = ExpenseService.updateExpense(po);
        } else {
            rm = ExpenseService.addExpense(po);
        }

        return rm;
    }

    @RequestMapping("/update")
    @ResponseBody
    public ResultModel<?> update(@RequestBody ExpensePo po, HttpSession session) {
        ResultModel rm = new ResultModel();
        if(po.getServicename().toLowerCase().contains(".com")){
            String serviceName =  po.getServicename();
            serviceName =  serviceName.replaceAll(".com","");
            serviceName =  serviceName.replaceAll(".coM","");
            serviceName =  serviceName.replaceAll(".cOM","");
            serviceName =  serviceName.replaceAll(".Com","");
            serviceName =  serviceName.replaceAll(".COm","");
            serviceName =  serviceName.replaceAll(".COM","");
            po.setServicename(serviceName);
        }
        if(!po.getServiceurl().toLowerCase().contains(".com")){
            String serviceUrL =  po.getServiceurl();
            po.setServiceurl(serviceUrL+".com");

        }
        rm = ExpenseService.updateExpense(po);
        return rm;
    }

    @RequestMapping("/updateStatus")
    @ResponseBody
    public ResultModel<?> updateStatus(@RequestBody ExpensePo po, HttpSession session) {
        ResultModel rm = new ResultModel();
        ExpensePo oldpo = ExpenseService.selectById(po);
        oldpo.setStatus("1");
        rm = ExpenseService.updateExpense(oldpo);
        return rm;
    }

    @RequestMapping("/delExpenses")
    @ResponseBody
    public ResultModel<?> delExpenses(@RequestBody ExpensePo po, HttpSession session) {
        ResultModel rm = new ResultModel();
        rm = ExpenseService.delExpense(po);
        return rm;
    }

    @RequestMapping("/updateCata")
    @ResponseBody
    public ResultModel<?> updateCata(@RequestBody ExpensePo po, HttpSession session) {
        ResultModel rm = new ResultModel();
        if(po.getServicename().toLowerCase().contains(".com")){
            String serviceName =  po.getServicename();
            serviceName =  serviceName.replaceAll(".com","");
             serviceName =  serviceName.replaceAll(".coM","");
             serviceName =  serviceName.replaceAll(".cOM","");
             serviceName =  serviceName.replaceAll(".Com","");
             serviceName =  serviceName.replaceAll(".COm","");
             serviceName =  serviceName.replaceAll(".COM","");
             po.setServicename(serviceName);

        }
        if(!po.getServiceurl().toLowerCase().contains(".com")){
            String serviceUrL =  po.getServiceurl();
            po.setServiceurl(serviceUrL+".com");
            po.setMailSubject(serviceUrL);
        }else{
            String serviceName =  po.getServiceurl();
            serviceName =  serviceName.replaceAll(".com","");
            serviceName =  serviceName.replaceAll(".coM","");
            serviceName =  serviceName.replaceAll(".cOM","");
            serviceName =  serviceName.replaceAll(".Com","");
            serviceName =  serviceName.replaceAll(".COm","");
            serviceName =  serviceName.replaceAll(".COM","");
            po.setMailSubject(serviceName);
        }
        rm = ExpenseService.updateExpenseBat(po);
        return rm;
    }
    @RequestMapping("/getList")
    @ResponseBody
    public List<ExpensePo> getList(int eid, HttpSession session) {
        ExpensePo po = new ExpensePo();
        po.setEmailid(eid);
        return ExpenseService.selectList(po);
    }

    @RequestMapping("/getListByPage")
    @ResponseBody
    public Map getListByPage(int pid, int pageNum, String status, int pageSize, HttpSession session) {
        PageView<ExpenseVo> pageView = new PageView<>();
        pageView.setPageNum(pageNum);
        pageView.setLimit(pageSize);
        ExpenseVo vo = new ExpenseVo();
        vo.setPid(String.valueOf(pid));
        if (!StringUtils.isEmpty(status)) {
            vo.setStatus(status);
        }
        int total = ExpenseService.countExpense(vo);
        List list = ExpenseService.selectListAndCount(vo, pageView);
        Map m = new HashMap();
        m.put("list", list);
        m.put("total", total);
        return m;
    }

    @RequestMapping("/getById")
    @ResponseBody
    public ExpensePo getById(@RequestBody ExpensePo po, HttpSession session) {
        String uid = (String) session.getAttribute("globalUserId");
        return ExpenseService.selectById(po);
    }
}
