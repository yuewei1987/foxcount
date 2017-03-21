<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta Tags -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="format-detection" content="telephone=no">
	<title>ShowPage</title>

	<!-- Bootstrap -->
	<link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="lib/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
	<link rel="stylesheet" href="node_modules/element-ui/lib/theme-default/index.css">
	<!-- Main CSS -->
	<link href="css/font.css" rel="stylesheet" />
	<link href="css/screen.css" rel="stylesheet" />
</head>
<body>
<div class="grey-bgimg" id="app">
	<div class="nav-header">
		<a href="home.html" class="nav-bar">
			<img src="i/fox-logo.png" alt="logo">
			<h4 class="title">Countfox</h4>
		</a>
	</div>
	<div class="main-side">
		<div class="txt-area">
			<h1 class="title">Instant Expenses</h1>
			<p>
				<span class="block">Quickly track expenses</span>
				<span class="block">for all of your projects </span>
				<span class="block">using email.</span>
			</p>
			<el-button type="primary" class="sign-button" onclick="toHref()"><i class="icon-g"></i>Sign in with Google</el-button>
			<ul class="link-list">
				<li><a href="javascript:;">About</a></li>
				<li><a href="javascript:;">Terms of Service</a></li>
				<li><a href="javascript:;">Privacy Policy</a></li>
			</ul>
		</div>
		<div class="home-show-pic">
			<img src="i/home-show.png" alt="img">
		</div>
		<!-- end .home-show-pic -->
	</div>
	<!-- end .main-side -->
</div>

</body>
<!-- jQuery library -->
<script src="js/jquery-3.1.0.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script src="node_modules/vue/dist/vue.js"></script>
<script src="node_modules/element-ui/lib/index.js"></script>
<script>
    function toHref(){
        window.location.href="https://accounts.google.com/o/oauth2/v2/auth?"+
            "scope=https://www.googleapis.com/auth/userinfo.email%20https://www.googleapis.com/auth/userinfo.profile"+
            "&redirect_uri=https://fast-hamlet-34558.herokuapp.com/google/login/oauth2callback"+
            "&response_type=code"+
            "&client_id=319757543751-bj4lvlrthqal00u80r3dqfqm0i61f5g1.apps.googleusercontent.com";
    }
</script>
<!-- Main JS -->
<script src="js/script.js"></script>
</html>