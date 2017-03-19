package com.ecej.uc.config;

import java.sql.SQLException;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.alibaba.druid.pool.DruidDataSource;

/**
 * 核心配置，配置数据源 事物 sqlsession
 * 
 * @author QIANG
 *
 */
@Configuration
@EnableTransactionManagement
public class DBConfiguration extends AbstractDruidDBConfig {

	@Value("${spring.datasource.url}")
	private String url;

	@Value("${spring.datasource.username}")
	private String username;

	@Value("${spring.datasource.password}")
	private String password;

	// 注册dataSource
	@Bean(name = "datasource", initMethod = "init", destroyMethod = "close")
	public DruidDataSource dataSource() {
		return super.createDataSource(url, username, password);
	}

	@Bean(name = "ucSqlSessionFactory")
	public SqlSessionFactory sqlSessionFactory() throws Exception {
		return super.sqlSessionFactory(dataSource());
	}

	@Bean
	public PlatformTransactionManager transactionManager() throws SQLException {
		return new DataSourceTransactionManager(dataSource());
	}
}

