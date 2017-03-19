package com.ecej.controller;

import com.ecej.google.GooglePojo;
import com.ecej.google.GsonUtility;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.EmaillistPo;
import com.ecej.uc.service.EmaillistService;
import com.ecej.uc.service.UserService;
import com.google.gson.Gson;
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
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;

@Controller
@RequestMapping("/google/")
public class GoogleCallBackController {
	@Resource
    private EmaillistService emailService;
    @Value("${catty.google.client_id}")
	private String clientid;
	@Value("${catty.google.client_secret}")
	private String client_secret;
	@Value("${catty.google.redirect_uris2}")
	private String redirect_uris2;
	@RequestMapping("/oauth2callback")
	public ModelAndView oauth2callback(String code,String state, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException {
		try{
			String urlParameters = "code=" +
					code +
					"&client_id=" + clientid+
					"&client_secret=" + client_secret +
					"&redirect_uri=" + redirect_uris2 +
                    "&grant_type=authorization_code" +
                    "&access_type=offline";
            URL url = new URL("https://www.googleapis.com/oauth2/v4/token");
            URLConnection conn = url.openConnection();
            conn.setDoOutput(true);
            OutputStreamWriter writer = new OutputStreamWriter(
                    conn.getOutputStream());
			writer.write(urlParameters);
			writer.flush();
			String line1 = "";
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream()));
			String line;
			while ((line = reader.readLine()) != null)
			{
				line1 = line1 + line;
			}
			String s = GsonUtility.getJsonElementString("access_token", line1);
            String refrshToken = GsonUtility.getJsonElementString("refresh_token", line1);
            System.out.println("refresh_token" + refrshToken);
            url = new URL(
                    "https://www.googleapis.com/oauth2/v1/userinfo?access_token=" +
                            s);
            conn = url.openConnection();
			line1 = "";
			reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream()));
			while ((line = reader.readLine()) != null) {
				line1 = line1 + line;
			}
			System.out.println(line1);
			GooglePojo data = (GooglePojo)new Gson().fromJson(line1, GooglePojo.class);
			EmaillistPo ep = new EmaillistPo();
			String uid = (String)session.getAttribute("globalUserId");
			ep.setUid(Integer.parseInt(uid));
			int pid =0;
			if(state !=null){
				pid = Integer.parseInt(state);
			}
			ep.setPid(pid);
			ep.setEmailaddress(data.getEmail());
            EmaillistPo up = emailService.selectById(ep);
            if (up != null) {
                up.setEmailaddress(data.getEmail());
                up.setAccesstoken(s);
                up.setRefreshtoken(refrshToken);
                emailService.updateEmaillist(up);
            } else {
                ep.setRefreshtoken(refrshToken);
                ep.setAccesstoken(s);
                ep.setGid(data.getId());
                emailService.addEmaillist(ep);
            }
            writer.close();
			reader.close();
			request.setAttribute("auth", data);
			ModelMap model = new ModelMap();
            return new ModelAndView("redirect:/close", model);
        }
		catch (MalformedURLException e)
		{
			e.printStackTrace();
		}
		catch (ProtocolException e)
		{
			e.printStackTrace();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		ModelMap model = new ModelMap();
        return new ModelAndView("redirect:/close", model);
    }

}
