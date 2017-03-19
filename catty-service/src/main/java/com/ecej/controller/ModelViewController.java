package com.ecej.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;

@Controller
public class ModelViewController {
	@RequestMapping("/home")
	public ModelAndView getHomeView(){
		ModelMap model = new ModelMap();
		return new ModelAndView("home", model);
	}
	@RequestMapping("/index")
	public ModelAndView getIndexView(){
		ModelMap model = new ModelMap();
		return new ModelAndView("index", model);
	}

    @RequestMapping("/close")
    public ModelAndView getCloseView() {
        ModelMap model = new ModelMap();
        return new ModelAndView("close", model);
    }

    @RequestMapping("/test")
	public ModelAndView geTestView(){
		ModelMap model = new ModelMap();
		return new ModelAndView("Test", model);
	}
}
