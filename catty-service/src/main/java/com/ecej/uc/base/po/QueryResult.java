//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.ecej.uc.base.po;

import java.io.Serializable;
import java.util.List;

public class QueryResult<T> implements Serializable {
    private static final long serialVersionUID = 461900815434592315L;
    private List<T> list;
    private long total;

    public QueryResult() {
    }

    public QueryResult(List<T> list, long total) {
        this.list = list;
        this.total = total;
    }

    public List<T> getlist() {
        return this.list;
    }

    public void setlist(List<T> list) {
        this.list = list;
    }

    public long getTotal() {
        return this.total;
    }

    public void setTotal(long total) {
        this.total = total;
    }
}
