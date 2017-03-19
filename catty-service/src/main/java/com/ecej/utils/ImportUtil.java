package com.ecej.utils;

import com.alibaba.druid.support.logging.Log;
import com.alibaba.druid.support.logging.LogFactory;
import com.ecej.uc.po.EmaillistPo;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.Callable;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Description:
 * Author: CharlesSong
 * Date  : 2015/6/4
 */
public class ImportUtil {

    private static Log log = LogFactory.getLog(ImportUtil.class);
    private static final String regEx_script = "<script[^>]*?>[\\s\\S]*?<\\/script>"; // 定义script的正则表达式
    private static final String regEx_style = "<style[^>]*?>[\\s\\S]*?<\\/style>"; // 定义style的正则表达式
    private static final String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式
    private static final String regEx_space = "\\s*|\t|\r|\n";//定义空格回车换行符

    public static Map decodeMailHtml(String mailcontent) throws UnsupportedEncodingException {
        mailcontent = mailcontent.replaceAll("-", "+").replaceAll("_", "/");
        String tempContent = mailcontent;
        mailcontent = atob(mailcontent);
        mailcontent = escape(mailcontent);
        mailcontent = java.net.URLDecoder.decode(mailcontent, "UTF-8");
//        FileOutputStream fop = null;
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
//        File file = new File("D:/test/"+sdf.format(new Date())+".html");
//        try {
//            fop = new FileOutputStream(file);
//            // if file doesnt exists, then create it
//            if (!file.exists()) {
//                file.createNewFile();
//            }
//            // get the content in bytes
//            byte[] bytes = (tempContent+mailcontent).getBytes();
//            String str = new String(bytes, "UTF-8");
//            byte[] contentInBytes = str.getBytes();
//            fop.write(contentInBytes);
//            fop.flush();
//            fop.close();
//        } catch (FileNotFoundException e) {
//            e.printStackTrace();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }


        mailcontent = delHTMLTag(mailcontent);

        mailcontent = mailcontent.replaceAll(",", "");
//        String pattern = "/(<([^>]+)>)/ig";\;
        String regEx_script = "<script[^>]*?>[\\s\\S]*?<\\/script>"; // 定义script的正则表达式
        String regEx_style = "<style[^>]*?>[\\s\\S]*?<\\/style>"; // 定义style的正则表达式
        String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式

        String pattern = "[+-]?\\d+\\.?\\d*";
        String num = "ddd$2321399.81#!#!#!@#1asdasd123123wqewqe1231221dd-123213$-123";
        Pattern r = Pattern.compile(pattern, Pattern.CASE_INSENSITIVE);
        Matcher m = r.matcher(mailcontent);

        float max = 0;
        while (m.find()) {
//            System.out.println(m.group(0));
            int matchindex = m.start(0);
//            System.out.println("matchindex:"+matchindex);
            if (matchindex > 0) {
                if (mailcontent.substring(matchindex - 1, matchindex).contains("$") || mailcontent.substring(matchindex - 2, matchindex).contains("$")) {
                    Float tempPrice = Float.parseFloat(m.group(0));
                    if (tempPrice > max) {
                        max = tempPrice;
                    }
                }
            }
        }
        boolean flag = false;
        if (mailcontent.contains("invoice")) flag = true;
        if (mailcontent.contains("order")) flag = true;
        if (mailcontent.contains("receipt")) flag = true;
        if (mailcontent.contains("payment")) flag = true;
        if (mailcontent.contains("transaction")) flag = true;
        if (flag && max > 0) {
            System.out.println("this is payment email");
            System.out.println("MaxcOST:" + max);
        } else {
            flag = false;
        }
        Map m1 = new HashMap();
        m1.put("flag", flag);
        m1.put("cost", max);
        return m1;
    }

    /**
     * @param htmlStr
     * @return 删除Html标签
     */
    public static String delHTMLTag(String htmlStr) {
        Pattern p_script = Pattern.compile(regEx_script, Pattern.CASE_INSENSITIVE);
        Matcher m_script = p_script.matcher(htmlStr);
        htmlStr = m_script.replaceAll(""); // 过滤script标签

        Pattern p_style = Pattern.compile(regEx_style, Pattern.CASE_INSENSITIVE);
        Matcher m_style = p_style.matcher(htmlStr);
        htmlStr = m_style.replaceAll(""); // 过滤style标签

        Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
        Matcher m_html = p_html.matcher(htmlStr);
        htmlStr = m_html.replaceAll(""); // 过滤html标签

        Pattern p_space = Pattern.compile(regEx_space, Pattern.CASE_INSENSITIVE);
        Matcher m_space = p_space.matcher(htmlStr);
        htmlStr = m_space.replaceAll(""); // 过滤空格回车标签
        return htmlStr.trim(); // 返回文本字符串
    }

    public static String escape(String src) {
        int i;
        char j;
        StringBuffer tmp = new StringBuffer();
        tmp.ensureCapacity(src.length() * 6);

        for (i = 0; i < src.length(); i++) {

            j = src.charAt(i);

            if (Character.isDigit(j) || Character.isLowerCase(j)
                    || Character.isUpperCase(j))
                tmp.append(j);
            else if (j < 256) {
                tmp.append("%");
                if (j < 16)
                    tmp.append("0");
                tmp.append(Integer.toString(j, 16));
            } else {
                tmp.append("%u");
                tmp.append(Integer.toString(j, 16));
            }
        }
        return tmp.toString();
    }

    /**
     * // atob method
     * // 逆转encode的思路即可
     *
     * @param inStr
     * @return
     */
    public static String atob(String inStr) {
        String base64hash = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        if (inStr == null) return null;
        //s = s.replace(/\s|=/g, '');
        inStr = inStr.replaceAll("\\s|=", "");
        StringBuilder result = new StringBuilder();
        int cur;
        int prev = -1;
//        Integer prev=null;
        int mod;
        int i = 0;
        while (i < inStr.length()) {
            cur = base64hash.indexOf(inStr.charAt(i));
            mod = i % 4;
            switch (mod) {
                case 0:
                    break;
                case 1:
                    result.append(String.valueOf((char) (prev << 2 | cur >> 4)));
                    break;
                case 2:
                    result.append(String.valueOf((char) ((prev & 0x0f) << 4 | cur >> 2)));
                    break;
                case 3:
                    result.append(String.valueOf((char) ((prev & 3) << 6 | cur)));
                    break;
            }
            prev = cur;
            i++;
        }
        return result.toString();
    }


}