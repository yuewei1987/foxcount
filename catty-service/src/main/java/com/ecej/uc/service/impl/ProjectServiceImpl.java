package com.ecej.uc.service.impl;

import com.ecej.uc.base.BaseUtils;
import com.ecej.uc.base.dao.UcBaseDao;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.ProjectPo;
import com.ecej.uc.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by mijp on 2017/1/11.
 */
@Service("projectService")
public class ProjectServiceImpl implements ProjectService {

    @Autowired
    private UcBaseDao ucBaseDao;

    @Transactional
    public ProjectPo selectById(ProjectPo po) {
        return ucBaseDao.selectOne(BaseUtils.makeClazzPath(ProjectPo.class, "selectOne"), po);
    }
    @Transactional
    public List<ProjectPo> selectList(ProjectPo po) {
        return ucBaseDao.selectList(BaseUtils.makeClazzPath(ProjectPo.class, "selectList"), po);
    }
    @Transactional
    public ResultModel<?> addProject(ProjectPo po) {
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
    public ResultModel<?> updateProject(ProjectPo po) {
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
    public ResultModel<?> delProject(ProjectPo po) {
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
