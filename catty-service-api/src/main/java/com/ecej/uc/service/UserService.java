package com.ecej.uc.service;

import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.UserPo;

import java.util.List;

/**
 * Created by mijp on 2017/1/11.
 */
public interface UserService {

    /**
     * Uc test demo
     * @return
     */
    UserPo selectById(UserPo po);
    List<UserPo> selectList(UserPo po);
    ResultModel<?> addUser(UserPo po);
    ResultModel<?> updateUser(UserPo po);
    ResultModel<?> delUser(UserPo po);
}
