//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.ecej.uc.config;

import com.alibaba.druid.pool.DruidDataSource;
import com.github.pagehelper.PageHelper;
import java.sql.SQLException;
import java.util.Properties;
import javax.annotation.Resource;
import javax.sql.DataSource;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ApplicationContextException;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

@Configuration
@EnableConfigurationProperties({DruidDbProperties.class})
@Import({DruidMonitConfig.class})
public abstract class AbstractDruidDBConfig {
    private Logger logger = LoggerFactory.getLogger(AbstractDruidDBConfig.class);
    @Resource
    private DruidDbProperties druidDbProperties;

    public AbstractDruidDBConfig() {
    }

    public DruidDataSource createDataSource(String url, String username, String password) {
        return this.createDataSource(url, username, password, this.druidDbProperties);
    }

    private DruidDataSource createDataSource(String url, String username, String password, DruidDbProperties druidDbProperties) {
        if(StringUtils.isEmpty(url)) {
            System.out.println("Your database connection pool configuration is incorrect! Please check your Spring profile");
            throw new ApplicationContextException("Database connection pool is not configured correctly");
        } else {
            DruidDataSource datasource = new DruidDataSource();
            datasource.setUrl(url);
            datasource.setUsername(username);
            datasource.setPassword(password);
            datasource.setDriverClassName(druidDbProperties.getDriverClassName());
            datasource.setInitialSize(druidDbProperties.getInitialSize());
            datasource.setMinIdle(druidDbProperties.getMinIdle());
            datasource.setMaxActive(druidDbProperties.getMaxActive());
            datasource.setMaxWait((long)druidDbProperties.getMaxWait());
            datasource.setTimeBetweenEvictionRunsMillis((long)druidDbProperties.getTimeBetweenEvictionRunsMillis());
            datasource.setMinEvictableIdleTimeMillis((long)druidDbProperties.getMinEvictableIdleTimeMillis());
            datasource.setValidationQuery(druidDbProperties.getValidationQuery());
            datasource.setTestWhileIdle(druidDbProperties.isTestWhileIdle());
            datasource.setTestOnBorrow(druidDbProperties.isTestOnBorrow());
            datasource.setTestOnReturn(druidDbProperties.isTestOnReturn());

            try {
                datasource.setFilters(druidDbProperties.getFilters());
            } catch (SQLException var7) {
                this.logger.error("druid configuration initialization filter", var7);
            }

            datasource.setConnectionProperties(druidDbProperties.getConnectionProperties());
            return datasource;
        }
    }

    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        return this.createSqlSessionFactory(dataSource, "classpath:mybatis/**/*.xml");
    }

    public SqlSessionFactory sqlSessionFactory(DataSource dataSource, String mapperLocations) throws Exception {
        return this.createSqlSessionFactory(dataSource, mapperLocations);
    }

    private SqlSessionFactory createSqlSessionFactory(DataSource dataSource, String mapperLocations) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        PageHelper pageHelper = new PageHelper();
        Properties props = new Properties();
        props.setProperty("dialect", "mysql");
        props.setProperty("reasonable", "true");
        props.setProperty("supportMethodsArguments", "true");
        props.setProperty("returnPageInfo", "check");
        props.setProperty("params", "count=countSql");
        pageHelper.setProperties(props);
        sqlSessionFactoryBean.setPlugins(new Interceptor[]{pageHelper});
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sqlSessionFactoryBean.setMapperLocations(resolver.getResources(mapperLocations));
        return sqlSessionFactoryBean.getObject();
    }
}
