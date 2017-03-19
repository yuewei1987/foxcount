package com.ecej.uc.service.impl;

import com.ecej.uc.base.BaseUtils;
import com.ecej.uc.base.dao.UcBaseDao;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.EmaillistPo;
import com.ecej.uc.service.EmaillistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by mijp on 2017/1/11.
 */
@Service("EmaillistService")
public class EmailListServiceImpl implements EmaillistService {

    @Autowired
    private UcBaseDao ucBaseDao;

    @Transactional
    public EmaillistPo selectById(EmaillistPo po) {
        return ucBaseDao.selectOne(BaseUtils.makeClazzPath(EmaillistPo.class, "selectOne"), po);
    }
    @Transactional
    public List<EmaillistPo> selectList(EmaillistPo po) {
        return ucBaseDao.selectList(BaseUtils.makeClazzPath(EmaillistPo.class, "selectList"), po);
    }
    @Transactional
    public ResultModel<?> addEmaillist(EmaillistPo po) {
        ResultModel rm =new ResultModel();
        try{
            int count = ucBaseDao.insert(po);
            if(count != 0){
                rm.setCode(200);
                rm.setMessage("success");
                rm.setData(po);
            }
        }catch(Exception e){
            e.printStackTrace();
            rm.setCode(500);
            rm.setMessage("faile");
            rm.setData(po);
        }
        return rm;
    }
    @Transactional
    public ResultModel<?> updateEmaillist(EmaillistPo po) {
        ResultModel rm =new ResultModel();
        try{
            int count = ucBaseDao.update(po);
            if(count != 0){
                rm.setCode(200);
                rm.setMessage("success");
                rm.setData(po);
            }
        }catch(Exception e){
            e.printStackTrace();
            rm.setCode(500);
            rm.setMessage("faile");
            rm.setData(po);
        }
        return rm;
    }
    @Transactional
    public ResultModel<?> delEmaillist(EmaillistPo po) {
        ResultModel rm =new ResultModel();
        try{
            int count = ucBaseDao.delete(po);
            if(count != 0){
                rm.setCode(200);
                rm.setMessage("success");
                rm.setData(po);
            }
        }catch(Exception e){
            e.printStackTrace();
            rm.setCode(500);
            rm.setMessage("faile");
            rm.setData(po);
        }
        return rm;
    }
}
