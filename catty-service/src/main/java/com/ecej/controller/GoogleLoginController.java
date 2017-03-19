package com.ecej.controller;

import com.ecej.google.GooglePojo;
import com.ecej.google.GsonUtility;
import com.ecej.uc.dto.ResultModel;
import com.ecej.uc.po.EmaillistPo;
import com.ecej.uc.po.ProjectPo;
import com.ecej.uc.po.UserPo;
import com.ecej.uc.service.EmaillistService;
import com.ecej.uc.service.ProjectService;
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
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/google/login/")
public class GoogleLoginController {
	@Resource
	private UserService userService;
    @Resource
    private EmaillistService emaillistService;
	@Resource
    private ProjectService projectService;
    @Value("${catty.google.client_id}")
	private String clientid;
	@Value("${catty.google.client_secret}")
	private String client_secret;
	@Value("${catty.google.redirect_uris}")
	private String redirect_uris;
	@RequestMapping("/oauth2callback")
	public ModelAndView oauth2callback(String code, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException {
		try{
			String urlParameters = "code=" +
					code +
					"&client_id=" + clientid+
					"&client_secret=" + client_secret +
					"&redirect_uri=" + redirect_uris +
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
			UserPo up = new UserPo();
			up.setEmail(data.getEmail());
			if(userService.selectById(up) != null){
				up = userService.selectById(up);
				//update all the user's gmail 's token.
//                ep.setEmailaddress(data.getEmail());
				EmaillistPo ep = new EmaillistPo();
				List<EmaillistPo> ep1 = new ArrayList<EmaillistPo>();
				ep.setUid(up.getUid());
				ep1 = emaillistService.selectList(ep);
				for (int k = 0; k < ep1.size(); k++) {
					EmaillistPo epTemp = ep1.get(k);
					if (epTemp.getRefreshtoken() != null) {
						String urlParameters2 =
								"&client_id=" + clientid +
										"&client_secret=" + client_secret +
										"&refresh_token=" + epTemp.getRefreshtoken() +
										"&grant_type=refresh_token";
						URL url2 = new URL("https://www.googleapis.com/oauth2/v4/token");
						URLConnection conn2 = url2.openConnection();
						conn2.setDoOutput(true);
						OutputStreamWriter writer2 = new OutputStreamWriter(
								conn2.getOutputStream());
						writer2.write(urlParameters2);
						writer2.flush();
						String line2 = "";
						BufferedReader reader2 = new BufferedReader(new InputStreamReader(
								conn2.getInputStream()));
						String line22;
						while ((line22 = reader2.readLine()) != null) {
							line2 = line2 + line22;
						}
						String newtoken = GsonUtility.getJsonElementString("access_token", line2);
						epTemp.setAccesstoken(newtoken);
						emaillistService.updateEmaillist(epTemp);
					}

				}

            }else{
				ResultModel<?> rm = userService.addUser(up);
			}
			ProjectPo pp = new ProjectPo();
			pp.setUid(up.getUid());
			List<ProjectPo> newpp = projectService.selectList(pp);
			if(newpp.size()==0){
				pp.setCurrency("1");
				pp.setProjectname("Project 1");
				projectService.addProject(pp);
			}
			session.setAttribute("globalUserId", String.valueOf(up.getUid()));
			session.setAttribute("globalUserAccount", String.valueOf(up.getEmail()));
			writer.close();
			reader.close();
			request.setAttribute("auth", data);
//			request.getRequestDispatcher("/home").forward(request, response);
			ModelMap model = new ModelMap();
			return new ModelAndView("redirect:/home", model);
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
		return new ModelAndView("redirect:/index", model);
	}

}
