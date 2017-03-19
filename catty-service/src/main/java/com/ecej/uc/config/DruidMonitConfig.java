//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.ecej.uc.config;

import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import javax.annotation.Resource;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;

@Configuration
@EnableConfigurationProperties({DruidDbProperties.class})
public class DruidMonitConfig {
    @Resource
    private DruidDbProperties druidDbProperties;

    public DruidMonitConfig() {
    }

    @Bean
    public ServletRegistrationBean druidServlet() {
        ServletRegistrationBean reg = new ServletRegistrationBean();
        reg.setServlet(new StatViewServlet());
        reg.addUrlMappings(new String[]{"/druid/*"});
        if(!StringUtils.isEmpty(this.druidDbProperties.getAllow())) {
            reg.addInitParameter("allow", this.druidDbProperties.getAllow());
        }

        if(!StringUtils.isEmpty(this.druidDbProperties.getDeny())) {
            reg.addInitParameter("deny", this.druidDbProperties.getDeny());
        }

        reg.addInitParameter("loginUsername", this.druidDbProperties.getUsername());
        reg.addInitParameter("loginPassword", this.druidDbProperties.getPassword());
        return reg;
    }

    @Bean
    public FilterRegistrationBean filterRegistrationBean() {
        FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean();
        filterRegistrationBean.setFilter(new WebStatFilter());
        filterRegistrationBean.addUrlPatterns(new String[]{"/*"});
        filterRegistrationBean.addInitParameter("exclusions", "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");
        return filterRegistrationBean;
    }
}
