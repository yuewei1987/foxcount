package com.ecej.uc.service;

import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.EmaillistPo;

import java.util.List;

/**
 * Created by mijp on 2017/1/11.
 */
public interface EmaillistService {

    /**
     * Uc test demo
     * @return
     */
    EmaillistPo selectById(EmaillistPo po);
    List<EmaillistPo> selectList(EmaillistPo po);
    ResultModel<?> addEmaillist(EmaillistPo po);
    ResultModel<?> updateEmaillist(EmaillistPo po);
    ResultModel<?> delEmaillist(EmaillistPo po);
}
