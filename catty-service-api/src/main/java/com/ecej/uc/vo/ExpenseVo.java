
package com.ecej.uc.vo;

public class ExpenseVo {
    private static final long serialVersionUID = 1L;
    //alias
    public static final String TABLE_ALIAS = "Expense";


    //columns START
    /**
     * eid       db_column: eid
     */
    private Integer eid;
    /**
     * emailid       db_column: emailid
     */
    private Integer emailid;
    /**
     * servicename       db_column: servicename
     */
    private String servicename;
    /**
     * serviceurl       db_column: serviceurl
     */
    private String serviceurl;
    /**
     * cost       db_column: cost
     */
    private java.math.BigDecimal cost;
    /**
     * invoiceDate       db_column: invoice_date
     */
    private java.util.Date invoiceDate;

    public String getMailId() {
        return mailId;
    }

    public void setMailId(String mailId) {
        this.mailId = mailId;
    }

    /**
     * mailId       db_column: mail_id
     */
    private String mailId;
    /**
     * mailContent       db_column: mail_content
     */
    private String mailContent;
    /**
     * mailSubject       db_column: mail_subject
     */
    private String mailSubject;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    private String status;

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }


    private String target;

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    private String pid;
    private String uid;
    //columns END


    public Integer getEid() {
        return this.eid;
    }

    public void setEid(Integer value) {
        this.eid = value;
    }


    public Integer getEmailid() {
        return this.emailid;
    }

    public void setEmailid(Integer value) {
        this.emailid = value;
    }


    public String getServicename() {
        return this.servicename;
    }

    public void setServicename(String value) {
        this.servicename = value;
    }


    public String getServiceurl() {
        return this.serviceurl;
    }

    public void setServiceurl(String value) {
        this.serviceurl = value;
    }


    public java.math.BigDecimal getCost() {
        return this.cost;
    }

    public void setCost(java.math.BigDecimal value) {
        this.cost = value;
    }


    public java.util.Date getInvoiceDate() {
        return this.invoiceDate;
    }

    public void setInvoiceDate(java.util.Date value) {
        this.invoiceDate = value;
    }


    public String getMailContent() {
        return this.mailContent;
    }

    public void setMailContent(String value) {
        this.mailContent = value;
    }


    public String getMailSubject() {
        return this.mailSubject;
    }

    public void setMailSubject(String value) {
        this.mailSubject = value;
    }


}

