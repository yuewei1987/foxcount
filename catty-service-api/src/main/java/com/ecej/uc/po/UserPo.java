
package com.ecej.uc.po;

public class UserPo {
	private static final long serialVersionUID = 1L;
	//alias
	public static final String TABLE_ALIAS = "User";
	

	//columns START
    /**
     * uid       db_column: uid   
     */ 	
	private Integer uid;
    /**
     * email       db_column: email   
     */ 	
	private String email;
	//columns END


	
	
	public Integer getUid() {
		return this.uid;
	}
	
	public void setUid(Integer value) {
		this.uid = value;
	}
	
	
	public String getEmail() {
		return this.email;
	}
	
	public void setEmail(String value) {
		this.email = value;
	}
	

	

}

