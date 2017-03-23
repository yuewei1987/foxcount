package com.ecej.controller;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ecej.google.GooglePojo;
import com.ecej.google.GsonUtility;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.EmaillistPo;
import com.ecej.uc.po.ExpensePo;
import com.ecej.uc.service.EmaillistService;
import com.ecej.uc.service.ExpenseService;
import com.ecej.utils.HttpClientTreadUtil;
import com.ecej.utils.HttpClientUtil;
import com.ecej.utils.ImportUtil;
import com.google.gson.Gson;
import org.apache.ibatis.ognl.IntHashMap;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.math.BigDecimal;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/google/import/")
public class ImportMailController {
    @Resource
    private EmaillistService emailService;
    @Resource
    private ExpenseService expenseService;
    private String qparam = "(qty%20%24)%20OR%20(invoice%20%24)%20OR%20(transaction%20%24)%20OR%20(transfer%20%24)%20OR%20(payment%20%24)%20-label%3Apromotions";

    @RequestMapping("/importemail")
    @ResponseBody
    public ResultModel importemail(String pid, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException {
        long startTime = System.currentTimeMillis();
        ResultModel rm = new ResultModel();
        String[] sresult = null;
        String uid = (String) session.getAttribute("globalUserId");
        EmaillistPo po = new EmaillistPo();
        po.setUid(Integer.parseInt(uid));
//        po.setUid(3);
        po.setPid(Integer.parseInt(pid));
        List<EmaillistPo> list = emailService.selectList(po);
        List<Map<String, Object>> reqList = new ArrayList<Map<String, Object>>();
//        for (EmaillistPo keypo : list) {
//            Map<String, Object> m = new HashMap<String, Object>();
//            m.put("url", "https://www.googleapis.com/gmail/v1/users/me/messages?access_token=" + keypo.getAccesstoken());
//            m.put("emailId", String.valueOf(keypo.getEid()));
//            reqList.add(m);
//        }
        List<Map<String, Object>> reqList2 = new ArrayList<Map<String, Object>>();
        boolean pageflag = false;
        for (EmaillistPo keypo : list) {
            Map<String, Object> m = new HashMap<String, Object>();
            m.put("url", "https://www.googleapis.com/gmail/v1/users/me/messages?access_token=" + keypo.getAccesstoken());
            m.put("emailId", String.valueOf(keypo.getEid()));
            String resultE = "";
            if (keypo.getPagetoken() != null && !"".equals(keypo.getPagetoken())) {
                pageflag = true;
                resultE = HttpClientUtil.sendGetRequest("https://www.googleapis.com/gmail/v1/users/me/messages?access_token="
                        + keypo.getAccesstoken() + "&pageToken=" + keypo.getPagetoken() + "&q=" + qparam, "UTF-8");

            } else {
                resultE = HttpClientUtil.sendGetRequest("https://www.googleapis.com/gmail/v1/users/me/messages?access_token="
                        + keypo.getAccesstoken() + "&q=" + qparam, "UTF-8");
            }
            if (resultE != null && !"".equals(resultE)) {
                JSONObject obj = JSON.parseObject(resultE);
                if (obj.getJSONObject("error") != null) {
                    continue;
                }
//                        if(!pageflag){
                if (obj.getString("nextPageToken") != null) {
                    resultE = HttpClientUtil.sendGetRequest("https://www.googleapis.com/gmail/v1/users/me/messages?access_token="
                            + keypo.getAccesstoken() + "&pageToken=" + obj.getString("nextPageToken") + "&q=" + qparam, "UTF-8");
                    keypo.setPagetoken(obj.getString("nextPageToken"));
                } else {
                    resultE = "";
                    keypo.setPagetoken("");
                }
                emailService.updateEmaillist(keypo);
//                    }else{
//                        resultE="";
//                    }

                JSONArray jsonArray = obj.getJSONArray("messages");

                for (int j = 0; j < jsonArray.size(); j++) {
                    Map<String, Object> m3 = new HashMap<String, Object>();
                    if (jsonArray.getJSONObject(j).get("id") != null && jsonArray.getJSONObject(j).get("threadId") != null) {
                        m3.put("url", "https://www.googleapis.com/gmail/v1/users/me/messages/" + (String) jsonArray.getJSONObject(j).get("id") + "?access_token=" + keypo.getAccesstoken());
                        m3.put("emailId", String.valueOf(keypo.getEid()));
                        reqList2.add(m3);
                    }
                }

            }

        }
//        String[] s = HttpClientTreadUtil.threadGet(reqList);
//        List<Map<String, Object>> reqList2 = new ArrayList<Map<String, Object>>();
//        for (int i = 0; i < s.length; i++) {
//            System.out.println(s[i]);
//            String[] s1 = s[i].split("@@@@");
//            String s2 = s1[0];
//            String s3 = s1[1];
//            JSONObject obj = JSON.parseObject(s2);
//            if (obj.getJSONObject("error") == null) {
//                if(obj.getString("nextPageToken") != null){
//                    System.out.println("nextPageToken"+obj.getString("nextPageToken"));
//                    Map<String, Object> m = new HashMap<String, Object>();
//                    m.put("url", "https://www.googleapis.com/gmail/v1/users/me/messages?access_token=" + s3+"&pageToken="+obj.getString("nextPageToken"));
//                    m.put("emailId", s2);
//                    reqList = new ArrayList<Map<String, Object>>();
//                    reqList.add(m);
//                    String[] pageResult = HttpClientTreadUtil.threadGet(reqList);
//                }
//                JSONArray jsonArray = obj.getJSONArray("messages");
//
//                for (int j = 0; j < jsonArray.size(); j++) {
//                    System.out.println("qwdwqewq   "+jsonArray.getJSONObject(j).get("id"));
//                    Map<String, Object> m = new HashMap<String, Object>();
//                    if (jsonArray.getJSONObject(j).get("id") != null && jsonArray.getJSONObject(j).get("threadId") != null) {
//                        m.put("url", "https://www.googleapis.com/gmail/v1/users/me/messages/" + (String) jsonArray.getJSONObject(j).get("id") + "?access_token=" + s3);
//                        m.put("emailId", s1[2]);
//                        reqList2.add(m);
//                    }
//                    System.out.println((String) jsonArray.getJSONObject(j).get("id") + (String) jsonArray.getJSONObject(j).get("threadId"));
//                }
//            }
//        }


        if (reqList2.size() > 0) {
            sresult = HttpClientTreadUtil.threadGet(reqList2);
        }
        if (sresult != null) {
            for (int k = 0; k < sresult.length; k++) {
                String[] finalStr = sresult[k].split("@@@@");
                String responseStr = finalStr[0];
                String EmailId = finalStr[2];
                JSONObject obj = JSON.parseObject(responseStr);
                String invoice_date = "";
                String target = "";
                String mail_content = "";
                String mail_subject = "";
                String mail_id = (String) obj.get("id");
                String header;
                JSONObject headerobj = JSON.parseObject(obj.getString("payload"));
                JSONArray headersarr = headerobj.getJSONArray("headers");
                for (int ii = 0; ii < headersarr.size(); ii++) {
                    if (headersarr.getJSONObject(ii).get("name") != null) {
                        String name = (String) headersarr.getJSONObject(ii).get("name");
                        if (name.equals("Subject")) {
                            if (headersarr.getJSONObject(ii).get("value") != null) {
                                mail_subject = (String) headersarr.getJSONObject(ii).get("value");
                            }
                        }
                        if (name.equals("Date")) {
                            if (headersarr.getJSONObject(ii).get("value") != null) {
                                invoice_date = (String) headersarr.getJSONObject(ii).get("value");
                            }
                        }
                        if (name.equals("From")) {
                            if (headersarr.getJSONObject(ii).get("value") != null) {
                                target = (String) headersarr.getJSONObject(ii).get("value");
                            }
                        }
                    }
                }
                JSONArray partsarr = headerobj.getJSONArray("parts");
                if (partsarr != null) {
                    for (int jj = 0; jj < partsarr.size(); jj++) {
                        if (partsarr.getJSONObject(jj).get("mimeType") != null) {
                            String htmltype = (String) partsarr.getJSONObject(jj).get("mimeType");
                            if (htmltype.equals("text/html")) {
                                JSONObject partobj1 = JSON.parseObject(partsarr.getJSONObject(jj).getString("body"));

                                String mailcontent = partobj1.getString("data");
                                try {
                                    mail_content = mailcontent;
                                    Map resultm = ImportUtil.decodeMailHtml(mailcontent);
                                    if (resultm.get("flag").toString().equals("true")) {
                                        if (Float.parseFloat(resultm.get("cost").toString()) != 0) {
                                            String[] sp = target.split("<");
                                            String sp0 = "";
                                            String sp1 = "";
                                            if (sp.length <= 1) {
                                                if (!target.contains("<")) {
                                                    sp0 = target;
                                                    sp1 = target;
                                                }
                                            } else {
                                                sp0 = sp[0];
                                                sp1 = sp[1];
                                            }
                                            if (!target.contains("<")) {
                                                sp0 = target;
                                                sp1 = target;
                                            }
                                            String[] sp11 = sp1.split("@");
                                            String sp111 = sp11[1];
                                            if (sp111.substring(1, 2).equals("."))
                                                sp111 = sp111.substring(2);
                                            String sp1111 = sp111.replace(">", "");
                                            ExpensePo ep = new ExpensePo();
                                            BigDecimal bd = new BigDecimal(resultm.get("cost").toString());
                                            ep.setCost(bd);
                                            ep.setMailContent(mail_content);
                                            ep.setServiceurl(sp1111);
                                            ep.setServicename(sp[0]);
                                            SimpleDateFormat sdf = new SimpleDateFormat(" yyyy-MM-dd HH:mm:ss ");
                                            Date d = new Date();
                                            if (StringUtils.isEmpty(invoice_date)) {
                                                ep.setInvoiceDate(d);
                                            } else {
                                                d = new Date(invoice_date);
                                                ep.setInvoiceDate(d);
                                            }
                                            ep.setEmailid(Integer.parseInt(EmailId));
                                            ep.setMailContent(mail_content);
                                            ep.setMailId(mail_id);
                                            ep.setMailSubject(mail_subject);
                                            ep.setTarget(target);
                                            if (expenseService.selectById(ep) == null) {
                                                ep.setStatus("0");
                                                expenseService.addExpense(ep);
                                            }

                                        }

                                    }
                                } catch (UnsupportedEncodingException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                    }
                }

            }
        }

        long endTime = System.currentTimeMillis();
        float excTime = (float) (endTime - startTime) / 1000;
        System.out.println("import " + reqList2.size() + " Email use Time：" + excTime + " s");
        rm.setCode(200);
        rm.setData("import " + reqList2.size() + " Email use Time：" + excTime + " s");
        return rm;
    }

    @RequestMapping("/importemailv2")
    @ResponseBody
    public ResultModel importemailv2(String pid, String eid, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException {
        long startTime = System.currentTimeMillis();
        ResultModel rm = new ResultModel();
        String[] sresult = null;
        String uid = (String) session.getAttribute("globalUserId");
        EmaillistPo po = new EmaillistPo();
        po.setUid(Integer.parseInt(uid));
        po.setPid(Integer.parseInt(pid));
        po.setEid(Integer.parseInt(eid));
        List<EmaillistPo> list = emailService.selectList(po);
        List<Map<String, Object>> reqList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> reqList2 = new ArrayList<Map<String, Object>>();
        boolean pageflag = false;
        for (EmaillistPo keypo : list) {
            Map<String, Object> m = new HashMap<String, Object>();
            m.put("url", "https://www.googleapis.com/gmail/v1/users/me/messages?access_token=" + keypo.getAccesstoken());
            m.put("emailId", String.valueOf(keypo.getEid()));
            String resultE = "";
            if (keypo.getPagetoken() != null && !"".equals(keypo.getPagetoken())) {
                pageflag = true;
                resultE = HttpClientUtil.sendGetRequest("https://www.googleapis.com/gmail/v1/users/me/messages?access_token="
                        + keypo.getAccesstoken() + "&pageToken=" + keypo.getPagetoken() + "&q=" + qparam, "UTF-8");

            } else {
                resultE = HttpClientUtil.sendGetRequest("https://www.googleapis.com/gmail/v1/users/me/messages?access_token="
                        + keypo.getAccesstoken() + "&q=" + qparam, "UTF-8");
            }
            if (resultE != null && !"".equals(resultE)) {
                JSONObject obj = JSON.parseObject(resultE);
                if (obj.getJSONObject("error") != null) {
                    continue;
                }
//                        if(!pageflag){
                if (obj.getString("nextPageToken") != null) {
                    resultE = HttpClientUtil.sendGetRequest("https://www.googleapis.com/gmail/v1/users/me/messages?access_token="
                            + keypo.getAccesstoken() + "&pageToken=" + obj.getString("nextPageToken") + "&q=" + qparam, "UTF-8");
                    keypo.setPagetoken(obj.getString("nextPageToken"));
                } else {
                    resultE = "";
                    keypo.setPagetoken("");
                }
                emailService.updateEmaillist(keypo);
//                    }else{
//                        resultE="";
//                    }

                JSONArray jsonArray = obj.getJSONArray("messages");

                for (int j = 0; j < jsonArray.size(); j++) {
                    Map<String, Object> m3 = new HashMap<String, Object>();
                    if (jsonArray.getJSONObject(j).get("id") != null && jsonArray.getJSONObject(j).get("threadId") != null) {
                        m3.put("url", "https://www.googleapis.com/gmail/v1/users/me/messages/" + (String) jsonArray.getJSONObject(j).get("id") + "?access_token=" + keypo.getAccesstoken());
                        m3.put("emailId", String.valueOf(keypo.getEid()));
                        reqList2.add(m3);
                    }
                }

            }

        }
        if (reqList2.size() > 0) {
            sresult = HttpClientTreadUtil.threadGet(reqList2);
        }
        if (sresult != null) {
            for (int k = 0; k < sresult.length; k++) {
                String[] finalStr = sresult[k].split("@@@@");
                String responseStr = finalStr[0];
                String EmailId = finalStr[2];
                JSONObject obj = JSON.parseObject(responseStr);
                String invoice_date = "";
                String target = "";
                String mail_content = "";
                String mail_subject = "";
                String mail_id = (String) obj.get("id");
                String header;
                JSONObject headerobj = JSON.parseObject(obj.getString("payload"));
                JSONArray headersarr = headerobj.getJSONArray("headers");
                for (int ii = 0; ii < headersarr.size(); ii++) {
                    if (headersarr.getJSONObject(ii).get("name") != null) {
                        String name = (String) headersarr.getJSONObject(ii).get("name");
                        if (name.equals("Subject")) {
                            if (headersarr.getJSONObject(ii).get("value") != null) {
                                mail_subject = (String) headersarr.getJSONObject(ii).get("value");
                            }
                        }
                        if (name.equals("Date")) {
                            if (headersarr.getJSONObject(ii).get("value") != null) {
                                invoice_date = (String) headersarr.getJSONObject(ii).get("value");
                            }
                        }
                        if (name.equals("From")) {
                            if (headersarr.getJSONObject(ii).get("value") != null) {
                                target = (String) headersarr.getJSONObject(ii).get("value");
                            }
                        }
                    }
                }
                JSONArray partsarr = headerobj.getJSONArray("parts");
                if (partsarr != null) {
                    for (int jj = 0; jj < partsarr.size(); jj++) {
                        if (partsarr.getJSONObject(jj).get("mimeType") != null) {
                            String htmltype = (String) partsarr.getJSONObject(jj).get("mimeType");
                            if (htmltype.equals("text/html")) {
                                JSONObject partobj1 = JSON.parseObject(partsarr.getJSONObject(jj).getString("body"));

                                String mailcontent = partobj1.getString("data");
                                try {
                                    mail_content = mailcontent;
                                    Map resultm = ImportUtil.decodeMailHtml(mailcontent);
                                    if (resultm.get("flag").toString().equals("true")) {
                                        if (Float.parseFloat(resultm.get("cost").toString()) != 0) {
                                            String[] sp = target.split("<");
                                            String sp0 = "";
                                            String sp1 = "";
                                            if (sp.length <= 1) {
                                                if (!target.contains("<")) {
                                                    sp0 = target;
                                                    sp1 = target;
                                                }
                                            } else {
                                                sp0 = sp[0];
                                                sp1 = sp[1];
                                            }
                                            if (!target.contains("<")) {
                                                sp0 = target;
                                                sp1 = target;
                                            }
                                            String[] sp11 = sp1.split("@");
                                            String sp111 = sp11[1];
                                            if (sp111.substring(1, 2).equals("."))
                                                sp111 = sp111.substring(2);
                                            String sp1111 = sp111.replace(">", "");
                                            ExpensePo ep = new ExpensePo();
                                            BigDecimal bd = new BigDecimal(resultm.get("cost").toString());
                                            ep.setCost(bd);
                                            ep.setMailContent(mail_content);
                                            ep.setServiceurl(sp1111);
                                            ep.setServicename(sp[0]);
                                            SimpleDateFormat sdf = new SimpleDateFormat(" yyyy-MM-dd HH:mm:ss ");
                                            Date d = new Date();
                                            if (StringUtils.isEmpty(invoice_date)) {
                                                ep.setInvoiceDate(d);
                                            } else {
                                                d = new Date(invoice_date);
                                                ep.setInvoiceDate(d);
                                            }
                                            ep.setEmailid(Integer.parseInt(EmailId));
                                            ep.setMailContent(mail_content);
                                            ep.setMailId(mail_id);
                                            ep.setMailSubject(mail_subject);
                                            ep.setTarget(target);
                                            if (expenseService.selectById(ep) == null) {
                                                ep.setStatus("0");
                                                expenseService.addExpense(ep);
                                            }

                                        }

                                    }
                                } catch (UnsupportedEncodingException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                    }
                }

            }
        }

        long endTime = System.currentTimeMillis();
        float excTime = (float) (endTime - startTime) / 1000;
        System.out.println("import " + reqList2.size() + " Email use Time：" + excTime + " s");
        rm.setCode(200);
        rm.setData("import " + reqList2.size() + " Email use Time：" + excTime + " s");
        return rm;
    }
}
