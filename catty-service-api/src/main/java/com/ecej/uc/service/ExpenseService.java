package com.ecej.uc.service;

import com.ecej.uc.dto.PageView;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.ExpensePo;
import com.ecej.uc.vo.ExpenseVo;

import java.util.List;

/**
 * Created by mijp on 2017/1/11.
 */
public interface ExpenseService {

    /**
     * Uc test demo
     *
     * @return
     */
    ExpensePo selectById(ExpensePo po);

    ResultModel<?> updateExpenseBat(ExpensePo po);
    List<ExpensePo> selectList(ExpensePo po);

    ResultModel<?> addExpense(ExpensePo po);

    ResultModel<?> updateExpense(ExpensePo po);

    ResultModel<?> delExpense(ExpensePo po);

    List<ExpenseVo> selectListAndCount(ExpenseVo po, PageView<ExpenseVo> pageView);

    int countExpense(ExpenseVo po);
}
