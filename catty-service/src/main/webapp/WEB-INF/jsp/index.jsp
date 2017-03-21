<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1,user-scalable=no,maximum-scale=1" />
	<meta charset="UTF-8">
	<title>Hello</title>
	<style>
		.button, button, input[type=button], input[type=reset], input[type=submit] {
			display: inline-block;
			height: 38px;
			padding: 0 30px;
			color: #555;
			text-align: center;
			font-size: 11px;
			font-weight: 600;
			line-height: 38px;
			letter-spacing: .1rem;
			text-transform: uppercase;
			text-decoration: none;
			white-space: nowrap;
			background-color: transparent;
			border-radius: 4px;
			border: 1px solid #bbb;
			cursor: pointer;
			box-sizing: border-box;
		}

		.button-pomegranate {
			color: #fff;
			background-color: #c0392b;
			border-color: #c0392b;
		}

		.button-pomegranate:hover {
			color: #fff;
			background-color: #d14233;3
			border-color: #d14233;
		}

		.fa {
			display: inline-block;
			font: normal normal normal 14px/1 FontAwesome;
			font-size: inherit;
			text-rendering: auto;
			-webkit-font-smoothing: antialiased;
			-moz-osx-font-smoothing: grayscale;
		}

		.fa-google:before {
			content: "\f1a0";
		}
	</style>
</head>
<body>
<div style="position:absolute;left:40%;top:10%;transform:translate(-50% -50%);">
<a href="https://accounts.google.com/o/oauth2/v2/auth?
scope=https://www.googleapis.com/auth/userinfo.email%20https://www.googleapis.com/auth/userinfo.profile
&redirect_uri=https://fast-hamlet-34558.herokuapp.com/google/login/oauth2callback
&response_type=code
&client_id=319757543751-bj4lvlrthqal00u80r3dqfqm0i61f5g1.apps.googleusercontent.com"
   class="button button-pomegranate"><i class="fa fa-google"></i> Login By Google</a>
</div>
</body>
</html>