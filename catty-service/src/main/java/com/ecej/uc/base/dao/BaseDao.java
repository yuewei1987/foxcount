//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.ecej.uc.base.dao;

import com.ecej.uc.base.po.QueryResult;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

public class BaseDao extends SqlSessionDaoSupport implements IBaseDao {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    protected static final String POSTFIX_COUNT = ".count";
    protected static final String POSTFIX_SELECTONE = ".selectOne";
    protected static final String POSTFIX_INSERT = ".insert";
    protected static final String POSTFIX_INSERTLIST = ".insertList";
    protected static final String POSTFIX_UPDATE = ".update";
    protected static final String POSTFIX_UPDATE_BY_ENTITY = ".updateByEntity";
    protected static final String POSTFIX_DELETE = ".delete";
    protected static final String POSTFIX_SELECTLIST = ".selectList";
    protected static final String POSTFIX_SELECTLISTORDERBY = ".selectListOrderBy";

    public BaseDao() {
    }

    public <T> Integer count(Object entity) {
        String className = entity.getClass().getName();
        return (Integer)this.getSqlSession().selectOne(className + ".count", entity);
    }

    public <T> Integer count(String statementPostfix, Object object) {
        return (Integer)this.getSqlSession().selectOne(statementPostfix, object);
    }

    public <T> T selectOne(String statement) {
        return this.getSqlSession().selectOne(statement);
    }

    public <T> T selectOne(Object entity) {
        String className = entity.getClass().getName();
        return this.getSqlSession().selectOne(className + ".selectOne", entity);
    }

    public <T> T selectOne(String statementPostfix, Object object) {
        return this.getSqlSession().selectOne(statementPostfix, object);
    }

    public <T> int insert(String statement, Object obj) {
        return this.getSqlSession().insert(statement, obj);
    }

    public <T> int insert(T entity) {
        String className = entity.getClass().getName();
        return this.getSqlSession().insert(className + ".insert", entity);
    }

    public <T> int insert(List<T> list) {
        if(list.size() == 0) {
            return list.size();
        } else {
            String className = list.get(0).getClass().getName();
            return this.getSqlSession().insert(className + ".insertList", list);
        }
    }

    public <T> int update(String statement) {
        return this.getSqlSession().update(statement);
    }

    public <T> int update(Object entity) {
        String className = entity.getClass().getName();
        return this.getSqlSession().update(className + ".update", entity);
    }

    /** @deprecated */
    @Deprecated
    public <T> int update(Object setParameter, Object whereParameter) {
        if(setParameter == null && whereParameter == null) {
            this.logger.warn("updateByEntity param setParameter  or whereParameter is null ");
            return 0;
        } else {
            String className = setParameter.getClass().getName();
            HashMap parameter = new HashMap();
            parameter.put("s", setParameter);
            parameter.put("w", whereParameter);
            return this.update((String)(className + ".updateByEntity"), parameter);
        }
    }

    public <T> int update(String statementPostfix, Object entity) {
        return this.getSqlSession().update(statementPostfix, entity);
    }

    public <T> int delete(Object entity) {
        if(entity == null) {
            this.logger.warn("can not delete data , entity is null !!!");
            return 0;
        } else {
            String className = entity.getClass().getName();
            return this.getSqlSession().delete(className + ".delete", entity);
        }
    }

    public <T> int delete(String statementPostfix, Object entity) {
        return this.getSqlSession().delete(statementPostfix, entity);
    }

    public <T> List<T> selectList(String statement) {
        return this.getSqlSession().selectList(statement);
    }

    public <T> List<T> selectList(Object entity) {
        String statementPostfix = entity.getClass().getName() + ".selectList";
        return this.selectList(statementPostfix, entity, (String)null);
    }

    public <T> List<T> selectList(T entity, String orderBy) {
        String statementPostfix = entity.getClass().getName() + ".selectList";
        return this.selectList(statementPostfix, entity, orderBy);
    }

    public <T> List<T> selectList(String statementPostfix, Object entity) {
        return this.selectList(statementPostfix, entity, (String)null);
    }

    public <T> List<T> selectList(String statementPostfix, Object entity, String orderBy) {
        if(!StringUtils.isEmpty(orderBy)) {
            PageHelper.orderBy(orderBy);
        }

        return this.getSqlSession().selectList(statementPostfix, entity);
    }

    public <T> List<T> selectList(Object entity, int pageNum, int pageSize) {
        String statementPostfix = entity.getClass().getName() + ".selectList";
        return this.selectList(statementPostfix, entity, pageNum, pageSize, (String)null);
    }

    public <T> List<T> selectList(Object entity, int pageNum, int pageSize, String orderBy) {
        String statementPostfix = entity.getClass().getName() + ".selectList";
        return this.selectList(statementPostfix, entity, pageNum, pageSize, orderBy);
    }

    public <T> List<T> selectList(String statementPostfix, Object entity, int pageNum, int pageSize) {
        return this.selectList(statementPostfix, entity, pageNum, pageSize, (String)null);
    }

    public <T> List<T> selectList(String statementPostfix, Object entity, int pageNum, int pageSize, String orderBy) {
        PageHelper.startPage(pageNum, pageSize, false);
        if(!StringUtils.isEmpty(orderBy)) {
            PageHelper.orderBy(orderBy);
        }

        List list = this.getSqlSession().selectList(statementPostfix, entity);
        return list;
    }

    public <T> QueryResult<T> selectListAndCount(String statementPostfix, Object entity, int pageNum, int pageSize, String orderBy) {
        Page page = PageHelper.startPage(pageNum, pageSize);
        if(!StringUtils.isEmpty(orderBy)) {
            PageHelper.orderBy(orderBy);
        }

        List list = this.getSqlSession().selectList(statementPostfix, entity);
        QueryResult result = new QueryResult(list, page.getTotal());
        return result;
    }

    public <T> QueryResult<T> selectListAndCount(String statementPostfix, Object entity, int pageNum, int pageSize, String orderBy, String statementCount) {
        List list = this.getSqlSession().selectList(statementPostfix, entity);
        long count = ((Long)this.selectOne(statementCount)).longValue();
        QueryResult result = new QueryResult(list, count);
        return result;
    }

    private <T> Map<String, Object> bean2Map(T entity) throws Exception {
        BeanInfo beanInfo = Introspector.getBeanInfo(entity.getClass());
        PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
        HashMap map = new HashMap();

        for(int i = 0; i < propertyDescriptors.length; ++i) {
            PropertyDescriptor descriptor = propertyDescriptors[i];
            String propertyName = descriptor.getName();
            Object value = descriptor.getReadMethod().invoke(entity, new Object[0]);
            map.put(propertyName, value);
        }

        return map;
    }
}
