package com.ecej.controller;

import com.ecej.uc.dto.ResultModel;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Date;

@Controller
@RequestMapping("/v1/upload")
public class UploadController {
	@RequestMapping(value="/upload", method= RequestMethod.POST)
	public @ResponseBody ResultModel<String> handleFileUpload(@RequestParam("file") MultipartFile file,HttpServletRequest request){
		ResultModel<String> rm =new ResultModel<String>();
		if (!file.isEmpty()) {
			try {
				String realPath = request.getSession().getServletContext().getRealPath("/upload");
				byte[] bytes = file.getBytes();
				String fileName = file.getOriginalFilename();
				String suffix="";
				String fName="";
				if(fileName.indexOf(".")>=0){

					int  indexdot =  fileName.indexOf(".");
					suffix =  fileName.substring(indexdot);

					fName = fileName.substring(0,fileName.lastIndexOf("."));
					Date now = new Date();
					fName = fName + "_"  +now.getTime();
					fName =  fName  + suffix;
				}
				File newfile =new File(realPath,fName);
				BufferedOutputStream stream =
						new BufferedOutputStream(new FileOutputStream(newfile));
				stream.write(bytes);
				stream.close();
				rm.setCode(200);
				rm.setMessage("You successfully uploaded " + fileName+ " into " + fName);
				rm.setData(fName);
				return rm;
			} catch (Exception e) {
				rm.setCode(500);
				rm.setMessage("You failed to upload " + file.getOriginalFilename() + " => " + e.getMessage());
				return rm;
			}
		} else {
			return rm;
		}
	}
}
