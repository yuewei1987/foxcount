
package com.ecej.uc.po;

public class EmaillistPo {
	private static final long serialVersionUID = 1L;
	//alias
	public static final String TABLE_ALIAS = "Emaillist";
	

	//columns START
    /**
     * eid       db_column: eid   
     */ 	
	private Integer eid;
    /**
     * pid       db_column: pid   
     */ 	
	private Integer pid;
    /**
     * uid       db_column: uid   
     */ 	
	private Integer uid;
    /**
     * emailaddress       db_column: emailaddress   
     */ 	
	private String emailaddress;
    /**
     * accesstoken       db_column: accesstoken   
     */ 	
	private String accesstoken;
    /**
     * gid       db_column: gid   
     */ 	
	private String gid;

    public String getRefreshtoken() {
        return refreshtoken;
    }

    public void setRefreshtoken(String refreshtoken) {
        this.refreshtoken = refreshtoken;
    }

    private String refreshtoken;

    public String getPagetoken() {
        return pagetoken;
    }

    public void setPagetoken(String pagetoken) {
        this.pagetoken = pagetoken;
    }

    private String pagetoken;
    //columns END


	
	
	public Integer getEid() {
		return this.eid;
	}
	
	public void setEid(Integer value) {
		this.eid = value;
	}
	
	
	public Integer getPid() {
		return this.pid;
	}
	
	public void setPid(Integer value) {
		this.pid = value;
	}
	
	
	public Integer getUid() {
		return this.uid;
	}
	
	public void setUid(Integer value) {
		this.uid = value;
	}
	
	
	public String getEmailaddress() {
		return this.emailaddress;
	}
	
	public void setEmailaddress(String value) {
		this.emailaddress = value;
	}
	
	
	public String getAccesstoken() {
		return this.accesstoken;
	}
	
	public void setAccesstoken(String value) {
		this.accesstoken = value;
	}
	
	
	public String getGid() {
		return this.gid;
	}
	
	public void setGid(String value) {
		this.gid = value;
	}
	

	

}

