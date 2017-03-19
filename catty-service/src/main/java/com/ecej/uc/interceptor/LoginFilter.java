package com.ecej.uc.interceptor;

import com.alibaba.fastjson.JSONObject;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

public class LoginFilter extends HttpServlet implements Filter {
    private FilterConfig filterConfig;

    public void destroy() {
        this.filterConfig = null;
    }

    public void doFilter(ServletRequest sRequest, ServletResponse sResponse,
                         FilterChain filterChain) throws IOException, ServletException {
        HttpServletResponse resp = (HttpServletResponse) sResponse;
        HttpServletRequest req = (HttpServletRequest) sRequest;
        String requestURL = req.getRequestURL().toString();
        String requestName = requestURL.substring(requestURL.lastIndexOf("/") + 1);

        //拦截地址中login.html及以.js和.css结尾的请求地址
        if (requestName.startsWith("index") ||
                requestName.startsWith("oauth2callback") ||
                requestName.startsWith("importemail") ||
                requestName.matches(".*\\.js$") ||
                requestName.matches(".*\\.css$") ||
                requestName.matches(".*\\.gif$") ||
                requestName.matches(".*\\.jpg$") ||
                requestName.matches(".*\\.png$") ||
                requestName.matches(".*\\.eot$") ||
                requestName.matches(".*\\.svg$") ||
                requestName.matches(".*\\.woff$") ||
                requestName.matches(".*\\.ttf$")
                ) {
            //跳到下一步请求
            //System.out.println("放行：" + requestName);
            filterChain.doFilter(sRequest, sResponse);
            return;
        }

        //System.out.println("不放行：" + requestName);

        HttpSession session = req.getSession(true);
        String operatorId = (String) session.getAttribute("globalUserId");
        if (operatorId == null || "".equals(operatorId)) {
            session.invalidate();
            if (req.getHeader("x-requested-with") != null
                    && req.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")) {
                resp.addHeader("sessionstatus", "timeout");
                Map<String, Object> result = new HashMap<String, Object>();
                result.put("success", false);
                result.put("timeout", true);
                result.put("redirectUri", req.getContextPath() + "/index");
                PrintWriter out = resp.getWriter();
                out.print(JSONObject.toJSON(result));
                out.flush();
                out.close();
            } else {
                resp.sendRedirect(req.getContextPath() + "/index");
            }
        } else {
            filterChain.doFilter(sRequest, sResponse);
        }
    }

    public void init(FilterConfig arg0) throws ServletException {
        this.filterConfig = arg0;
    }
}