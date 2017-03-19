package com.ecej.uc.dto;

/**
 * Description: 调用返回数据
 * Created by mijp on 2017/1/12.
 */
public class ResultModel <T> {

    /** 业务code */
    private int code;

    /** 返回message */
    private String message;

    /** 返回数据： 需要返回的DTO */
    private T data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
