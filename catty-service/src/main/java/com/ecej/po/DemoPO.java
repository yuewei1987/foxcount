package com.ecej.po;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

public class DemoPO {

	// W在需要校验的字段上指定约束条件
	@NotNull
	private String name;
	@Min(3)
	private int age;
	@NotNull
	private String classess;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getClassess() {
		return classess;
	}

	public void setClassess(String classess) {
		this.classess = classess;
	}

}
