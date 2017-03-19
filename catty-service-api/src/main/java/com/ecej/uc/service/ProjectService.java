package com.ecej.uc.service;

import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.ProjectPo;

import java.util.List;

/**
 * Created by mijp on 2017/1/11.
 */
public interface ProjectService {

    /**
     * Uc test demo
     * @return
     */
    ProjectPo selectById(ProjectPo po);
    List<ProjectPo> selectList(ProjectPo po);
    ResultModel<?> addProject(ProjectPo po);
    ResultModel<?> updateProject(ProjectPo po);
    ResultModel<?> delProject(ProjectPo po);
}
