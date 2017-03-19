//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.ecej.uc.base.dao;

import com.ecej.uc.base.po.QueryResult;

import java.util.List;

public interface IBaseDao {
    <T> Integer count(Object var1);

    <T> Integer count(String var1, Object var2);

    <T> T selectOne(String var1);

    <T> T selectOne(Object var1);

    <T> T selectOne(String var1, Object var2);

    <T> int insert(String var1, Object var2);

    <T> int insert(T var1);

    <T> int insert(List<T> var1);

    <T> int update(String var1);

    <T> int update(Object var1);

    <T> int update(Object var1, Object var2);

    <T> int update(String var1, Object var2);

    <T> int delete(Object var1);

    <T> int delete(String var1, Object var2);

    <T> List<T> selectList(String var1);

    <T> List<T> selectList(Object var1);

    <T> List<T> selectList(String var1, Object var2);

    <T> List<T> selectList(T var1, String var2);

    <T> List<T> selectList(String var1, Object var2, String var3);

    <T> List<T> selectList(Object var1, int var2, int var3);

    <T> List<T> selectList(String var1, Object var2, int var3, int var4);

    <T> List<T> selectList(Object var1, int var2, int var3, String var4);

    <T> List<T> selectList(String var1, Object var2, int var3, int var4, String var5);

    <T> QueryResult<T> selectListAndCount(String var1, Object var2, int var3, int var4, String var5);

    <T> QueryResult<T> selectListAndCount(String var1, Object var2, int var3, int var4, String var5, String var6);
}
