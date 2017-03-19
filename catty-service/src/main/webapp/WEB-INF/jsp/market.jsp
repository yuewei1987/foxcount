<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<head>
	<!-- Meta Tags -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="format-detection" content="telephone=no">
	<title>Market</title>

	<!-- Bootstrap -->
	<link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="lib/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
	<!-- Main CSS -->
	<link href="css/font.css" rel="stylesheet" />
	<link href="css/screen.css" rel="stylesheet" />

	<!-- jQuery library -->
	<script src="js/jquery-3.1.0.min.js"></script>
	<script src="lib/bootstrap/js/bootstrap.min.js"></script>

	<!-- Main JS -->
	<script src="js/script.js"></script>
	<script>
        function onClik(){
            var jsonuserinfo = $('#form1').serializeObject();
            $.ajax({
                //提交数据的类型 POST GET
                type:"POST",
                //提交的网址
                url:"/v1/marketlisting/addMarketListing",
                contentType: "application/json",
                //提交的数据
                data:JSON.stringify(jsonuserinfo),
                //返回数据的格式
                datatype: "json",
                //成功返回之后调用的函数
                success:function(data){
                    if(data.code==200){
                        $('#modal-add-listing').modal('hide');
                        refresh();
                    }
                }  ,
                //调用出错执行的函数
                error: function(){
                    //请求出错处理
                }
            });
        }  refresh();
        function refresh(){
            $('#marketListing').html("");
            $.ajax({
                //提交数据的类型 POST GET
                type:"GET",
                //提交的网址
                url:"/v1/marketlisting/getList?id=${requestScope.id}",
                contentType: "application/json",
                //返回数据的格式
                datatype: "json",
                //成功返回之后调用的函数
                success:function(data){
                    var list = data.data;
                    for(var i=0;i<list.length;i++){
                        var html ="<a href='product.html' class='listing-item'>"+
                            "<div class='img-title'>"+
                            "<img src='i/starbucks.jpg' alt='img'>"+
                            "</div>"+
                            "<div class='txt-area'>"+
                            "<span class='title'>"+list[i].title+"</span>"+
                        "<div class='txt'>"+list[i].description+"</div>"+
                        "</div>"+
                        "<span class='green-dollar'>"+
                           " $"+list[i].price+
                            "</span>"+
                            "</a>";
                        $('#marketListing').append(html);

                    }
                    html="<div class='show-more'>"+
                        "  <a href='javascript:;' class='show-bar'>Show 10 more...</a>"+
                        "</div>";
                    $('#marketListing').append(html);
                }  ,
                //调用出错执行的函数
                error: function(){
                    //请求出错处理
                }
            });
        }
	</script>
</head>
<body>


<header class="header purple-header green-header">
	<div class="center-container clearfix">
		<div class="left-area">
			<a href="home.html" class="white-point">N</a>
			<span class="inputs">
        <img class="search-icon" src="i/icon-white-search.svg" alt="svg">
        <input type="text" class="project-name-input" />
      </span>
		</div>
		<div class="right-area">
			<div class="drop-toggle user-login">
				<a href="javascript:;" class="user-login-link no-decoration">
					<span class="user-name">Join or login</span>
				</a>
				<div class="popup-panel">
					<div class="top-arrow"></div>
					<div class="popup-content">
						<div class="row-head">
							<div class="popup-header">
								Login
							</div>
						</div>
						<!-- end .row-head -->
						<div class="form">
              <span class="inputs green-input">
                <input type="email" class="email-input" placeholder="Email">
              </span>
							<span class="inputs green-input">
                <input type="text" class="password-input" placeholder="Password">
              </span>
							<a href="javascript:;" class="btn btn-login">Login</a>
							<div class="row-line"><span>or</span></div>
							<div class="friendly-list">
								<a href="javascript:;" class="long-button btn-twitter"></a>
								<a href="javascript:;" class="long-button btn-facebook"></a>
								<a href="javascript:;" class="long-button btn-gmail"></a>
							</div>
							<!-- end .friendly-list -->
						</div>
						<!-- end .form -->
						<div class="bottom-bar">
							Don't have an account?
							<a href="javascript:;" class="green-link register-link">Register</a>
						</div>
					</div>
					<!-- end .popup-content -->
				</div>
				<!-- end popup-panel -->
			</div>
			<!-- end .drop-toggle -->
		</div>
	</div>
	<!-- end .center-box -->
	<div class="center-container header-bottom clearfix">
		<div class="header-bottom-box">
			<a href="javascript:;" class="left-area">
				<img src="upload/${requestScope.market.picurl}" alt="img" class="img-ball">
				<div class="txt-area">
					<span>${requestScope.market.title}</span>
					<p>${requestScope.market.shortdesc}</p>
				</div>
			</a>
			<div class="right-area">
				<a href="javascript:;" class="btn btn-white-border">
					<span class="txt">Follow</span>
					<span class="num">380</span>
				</a>
			</div>
			<!-- end .right-area -->
		</div>
	</div>
</header>
<!-- .header -->
<div class="top-area top-menu">
	<div class="center-container">
		<div class="right-link">
			<a href="#" data-toggle="modal" data-target="#modal-add-listing"><i class="add-icon"></i>Add Listing</a>
			<a href="javascript:;"><i class="i-icon"></i>Marketplace</a>
		</div>
		<!-- end .right-area -->
		<div class="nav-tab">
			<a href="javascript:;" class="links current">Latest</a>
			<a href="javascript:;" class="links">Top Rated</a>
		</div>
		<!-- end .nav-tab -->
	</div>
	<!-- end .contents -->
</div>
<!-- .top-area -->
<div class="section center-container">
	<div class="listing-group market-list" id="marketListing">

	</div>
	<!-- end .market-list -->
</div>
<!-- end .contents -->

<div class="modal modal-default modal-register" id="modal-register" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content user-login clearfix">
			<div class="popup-panel">
				<div class="top-arrow"></div>
				<div class="popup-content">
					<div class="row-head">
						<div class="popup-header">
							Create an account
						</div>
					</div>
					<!-- end .row-head -->
					<div class="form">
              <span class="inputs green-input">
                <input type="email" class="email-input" placeholder="Email">
              </span>
						<span class="inputs green-input">
                <input type="text" class="password-input" placeholder="Password">
              </span>
						<div class="text-bar">
							I have read and agree to the <a href="javascript:;" class="green-txt">Terms of service</a>
							and <a href="javascript:;" class="green-txt">Privacy policy</a>.
						</div>
						<a href="javascript:;" class="btn btn-register">Register</a>
						<div class="row-line"><span>or</span></div>
						<div class="friendly-list">
							<a href="javascript:;" class="long-button btn-twitter"></a>
							<a href="javascript:;" class="long-button btn-facebook"></a>
							<a href="javascript:;" class="long-button btn-gmail"></a>
						</div>
						<!-- end .friendly-list -->
					</div>
					<!-- end .form -->
				</div>
				<!-- end .popup-content -->
			</div>
			<!-- end popup-panel -->
		</div>
		<!-- .modal-content -->
	</div>
	<!-- .modal-dialog -->
</div>
<!-- end .modal-register -->
<form id="form1" enctype="multipart/form-data" action="">
<div class="modal modal-default modal-customer modal-add-listing" id="modal-add-listing" tabindex="-1" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content clearfix">
			<div class="nav-boxs listing-nav-boxs">
				<h4>Add Listing</h4>
				<ul class="nav-list">
					<li class="current"><a href="javascript:;" class="nav-item">Description</a></li>
					<li><a href="javascript:;" class="nav-item">Media</a></li>
					<li><a href="javascript:;" class="nav-item">Settings</a></li>
				</ul>
				<div class="bottom-block">
					<a href="javascript:;" class="block">
						<span>Bitcoin</span>
						<p>Trade unused gift cards for Bitcoin</p>
					</a>
				</div>
				<!-- end .bottom-block -->
			</div>
			<!-- end .nav-boxs -->

				<input type="hidden" name="marketid" value="${requestScope.market.id}">
			<div class="form-boxs listing-form-boxs">
				<div class="tab-content">
					<div class="row">
						<div class="col col-md-9">
							<div class="title">Title</div>
							<div class="inputs green-input">
								<input type="text" name="title">
							</div>
						</div>
						<div class="col col-md-3">
							<div class="title">Price (USD)</div>
							<div class="inputs green-input dollar-inputs bg-white">
								<span class="dollar">$</span>
								<input type="text" name="price">
							</div>
						</div>
					</div>
					<!-- end .row -->
					<div class="row">
						<div class="col col-md-12">
							<div class="title">Description</div>
							<div class="textareas">
								<textarea name="description"></textarea>
							</div>
						</div>
					</div>
					<!-- end .row -->
					<div class="row">
						<div class="col col-md-12">
							<div class="thumbnails-img">
								<img src="i/thumbnails-default.svg" alt="img">
							</div>
							<div class="upload-right-txt">
							<span class="btn-upload">
							  <span class="txt">Add Listing Icon</span>
							  <input type="file" class="upload-image">
							</span>
								<span class="little-txt">Minimum size (50x50)</span>
							</div>
						</div>
					</div>
					<!-- end .row -->
					<div class="row row-btn">
						<div class="col col-md-12">
							<a href="javascript:;" class="btn btn-green" onclick="onClik()">Continue</a>
						</div>
					</div>
					<!-- end .row -->
				</div>
				<!-- end .tab-content -->
				<div class="tab-content hide">
					<div class="row">
						<div class="col col-md-12">
							<div class="thumbnails-img">
								<img src="i/thumbnails-default.svg" alt="img">
							</div>
							<div class="upload-right-txt">
                <span class="btn-upload">
                  <span class="txt">Upload an image</span>
                  <input type="file" class="upload-image">
                </span>
								<span class="little-txt">Minimum size (350x350)</span>
							</div>
						</div>
					</div>
					<!-- end .row -->
					<div class="row row-btn">
						<div class="col col-md-12">
							<a href="javascript:;" class="btn btn-green" onclick="onClik()">Continue</a>
						</div>
					</div>
					<!-- end .row -->
				</div>
				<!-- end .tab-content -->
				<div class="tab-content hide">
					<div class="row">
						<div class="col col-md-12">
							<div class="btn-upload-boxs">
                <span class="btn-upload">
                  <span class="txt">Upload product file</span>
                  <input type="file" class="upload-image">
                </span>
							</div>
							<!-- end .btn-upload-boxs -->
							<div class="thumbnails-img">
								<img src="i/thumbnails-default.svg" alt="img">
							</div>
							<div class="upload-right-txt">
								<a href="javascript:;" class="btn-remove-file">
									<span class="txt">Remove this file</span>
								</a>
							</div>
							<!-- end .upload-right-txt -->
						</div>
					</div>
					<!-- end .row -->
					<div class="row row-btn">
						<div class="col col-md-12">
							<a href="javascript:;" class="btn btn-green" onclick="onClik()">Continue</a>
						</div>
					</div>
					<!-- end .row -->
				</div>
				<!-- end .tab-content -->
			</div>

			<!-- end .form-boxs -->
		</div>
		<!-- .modal-content -->
	</div>
	<!-- .modal-dialog -->
</div>
</form>
</body>
</html>