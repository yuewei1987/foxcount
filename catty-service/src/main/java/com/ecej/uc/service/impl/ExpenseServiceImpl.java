package com.ecej.uc.service.impl;

import com.ecej.uc.base.BaseUtils;
import com.ecej.uc.base.dao.UcBaseDao;
import com.ecej.uc.dto.PageView;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.ExpensePo;
import com.ecej.uc.service.ExpenseService;
import com.ecej.uc.vo.ExpenseVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by mijp on 2017/1/11.
 */
@Service("ExpenseService")
public class ExpenseServiceImpl implements ExpenseService {

    @Autowired
    private UcBaseDao ucBaseDao;

    @Transactional
    public ExpensePo selectById(ExpensePo po) {
        return ucBaseDao.selectOne(BaseUtils.makeClazzPath(ExpensePo.class, "selectOne"), po);
    }

    @Transactional
    public List<ExpensePo> selectList(ExpensePo po) {
        return ucBaseDao.selectList(BaseUtils.makeClazzPath(ExpensePo.class, "selectList"), po);
    }

    @Transactional
    public List<ExpenseVo> selectListAndCount(ExpenseVo po, PageView<ExpenseVo> pageView) {
        return ucBaseDao.selectList(BaseUtils.makeClazzPath(ExpenseVo.class, "selectList"), po, pageView.getPageNum(), pageView.getLimit(), pageView.getSort());
    }

    @Transactional
    public int countExpense(ExpenseVo po) {
        return ucBaseDao.count(po);
    }

    @Transactional
    public ResultModel<?> addExpense(ExpensePo po) {
        ResultModel rm = new ResultModel();
        try {

            int count = ucBaseDao.insert(po);
            if (count != 0) {
                rm.setCode(200);
                rm.setMessage("success");
                rm.setData(po);
            }
        } catch (Exception e) {
            e.printStackTrace();
            rm.setCode(500);
            rm.setMessage("faile");
            rm.setData(po);
        }
        return rm;
    }

    @Transactional
    public ResultModel<?> updateExpense(ExpensePo po) {
        ResultModel rm = new ResultModel();
        try {
            int count = ucBaseDao.update(po);
            if (count != 0) {
                rm.setCode(200);
                rm.setMessage("success");
                rm.setData(po);
            }
        } catch (Exception e) {
            e.printStackTrace();
            rm.setCode(500);
            rm.setMessage("faile");
            rm.setData(po);
        }
        return rm;
    }

    @Transactional
    public ResultModel<?> updateExpenseBat(ExpensePo po) {
        ResultModel rm = new ResultModel();
        try {
            int count = ucBaseDao.update("updateByName", po);
            if (count != 0) {
                rm.setCode(200);
                rm.setMessage("success");
                rm.setData(po);
            }
        } catch (Exception e) {
            e.printStackTrace();
            rm.setCode(500);
            rm.setMessage("faile");
            rm.setData(po);
        }
        return rm;
    }

    @Transactional
    public ResultModel<?> delExpense(ExpensePo po) {
        ResultModel rm = new ResultModel();
        try {
            int count = ucBaseDao.delete(po);
            if (count != 0) {
                rm.setCode(200);
                rm.setMessage("success");
                rm.setData(po);
            }
        } catch (Exception e) {
            e.printStackTrace();
            rm.setCode(500);
            rm.setMessage("faile");
            rm.setData(po);
        }
        return rm;
    }
}
