package com.ecej.uc.dto;

import java.util.List;

/**
 * 分页工具类
 *
 * @param <T>
 * @author wangpuzhe
 */
public class PageView<T> {

    private List<T> rows; //返回加载到的数据

    private int total;   //总记录数

    private int offset = 0; //查询开始数

    private int pageNum = 1; //第几页

    private int limit = 0; //当前偏移量

    private String sort; //排序名称

    private String order; //排序类型

    public int getOffset() {
        return offset;
    }

    public void setOffset(int offset) {
        this.offset = offset;
    }

    public int getLimit() {
        return limit;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

    public String getSort() {
        return sort == null ? "" : sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public List<T> getRows() {
        return rows;
    }

    public PageView<T> setRows(List<T> rows) {
        this.rows = rows;
        return this;
    }

    public int getTotal() {
        return total;
    }

    public PageView<T> setTotal(int total) {
        this.total = total;
        return this;
    }

    public int getPageNum() {
        return (this.getOffset() / this.getLimit()) + 1;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }


}
