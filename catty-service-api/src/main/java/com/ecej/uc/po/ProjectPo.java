
package com.ecej.uc.po;

public class ProjectPo {
	private static final long serialVersionUID = 1L;
	//alias
	public static final String TABLE_ALIAS = "Project";
	

	//columns START
    /**
     * pid       db_column: pid   
     */ 	
	private Integer pid;
    /**
     * uid       db_column: uid   
     */ 	
	private Integer uid;
    /**
     * projectname       db_column: projectname   
     */ 	
	private String projectname;
    /**
     * currency       db_column: currency   
     */ 	
	private String currency;
	//columns END


	
	
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
	
	
	public String getProjectname() {
		return this.projectname;
	}
	
	public void setProjectname(String value) {
		this.projectname = value;
	}
	
	
	public String getCurrency() {
		return this.currency;
	}
	
	public void setCurrency(String value) {
		this.currency = value;
	}
	

	

}

