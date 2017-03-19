//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.ecej.uc.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.PropertyResourceConfigurer;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

public class PropertyConfigUtils extends PropertyResourceConfigurer {
    private Logger log = LoggerFactory.getLogger(PropertyConfigUtils.class);
    private PathMatchingResourcePatternResolver resourceLoader = new PathMatchingResourcePatternResolver();
    private static Map<String, String> ctxPropertiesMap;

    public PropertyConfigUtils() {
    }

    protected void processProperties(ConfigurableListableBeanFactory beanFactory, Properties props) throws BeansException {
        this.log.debug("PropertyConfigure execute ........");
        InputStream in = null;
        Properties properties = new Properties();

        try {
            Resource[] key = this.resourceLoader.getResources("classpath:/**/*.properties");
            Resource[] var9 = key;
            int value = key.length;

            for(int keyStr = 0; keyStr < value; ++keyStr) {
                Resource resource = var9[keyStr];
                in = resource.getInputStream();
                properties.load(in);
            }
        } catch (IOException var10) {
            this.log.error("load properties error!!!");
        }

        ctxPropertiesMap = new HashMap();
        Iterator var12 = properties.entrySet().iterator();

        while(var12.hasNext()) {
            Entry var11 = (Entry)var12.next();
            String var13 = (String)var11.getKey();
            String var14 = (String)var11.getValue();
            ctxPropertiesMap.put(var13, var14);
            this.log.debug("PropertyConfigure load K[{}] V[{}]", var13, var14);
        }

        this.log.info("PropertyConfigure load finish,size:{}", Integer.valueOf(ctxPropertiesMap.size()));
    }

    public static String getProperty(String name) {
        return (String)ctxPropertiesMap.get(name);
    }

    public static String getProperty(String name, String value) {
        String v = (String)ctxPropertiesMap.get(name);
        return StringUtils.isEmpty(v)?value:(String)ctxPropertiesMap.get(name);
    }
}
