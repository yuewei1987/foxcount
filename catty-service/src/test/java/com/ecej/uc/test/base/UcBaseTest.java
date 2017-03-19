package com.ecej.uc.test.base;

import com.ecej.Application;
import org.junit.After;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 * Created by mijp on 2017/1/11.
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
public class UcBaseTest {

    @Before
    public void before() {
        System.out.println("测试开始>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    }

    @After
    public void after() {
        System.out.println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<测试完成");
    }
}
