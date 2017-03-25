<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<%
	HttpSession Session = request.getSession();
	String globalUserId = (String) Session.getAttribute("globalUserId");
	String globalUserAccount = (String) Session.getAttribute("globalUserAccount");
%>
<!DOCTYPE html>

<html lang="en">
<head>
	<!-- Meta Tags -->
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="format-detection" content="telephone=no">
	<title>FoxCount</title>
	<link rel="icon" href="i/fox-logo.png">
	<!-- Bootstrap -->
	<link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="lib/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
	<link rel="stylesheet" href="node_modules/element-ui/lib/theme-default/index.css">
	<!-- Main CSS -->
	<link href="css/font.css" rel="stylesheet" />
	<link href="css/screen.css" rel="stylesheet" />
</head>
<body>
<!-- .header -->
<div id="app">
	<div class="top-area">
		<div href="javascript:;" class="left-area left-area-project">
			<div class="blue-block">
			</div>
			<!-- end .color-point-block -->
			<a href="javascript:;" id="projecttitlespan" class="link link-projects">
				Projects
			</a>
			<a href="javascript:;" class="link link-logout">
				Logout
			</a>
		</div>
		<!-- end .left-area -->
		<div class="two-btn">
			<el-button type="primary" class="link-add-expenses" v-on:click="addExpensesOpen">Expenses</el-button>
			<el-button class="grey-link link-view-expenses">View Expenses</el-button>
		</div>
		<!-- end .right-area -->
	</div>
	<!-- .top-area -->
	<div class="contents" style="display:none">
		<div class="three-grid clearfix">
			<div class="item">
				<h4 class="price">$ {{totalPrice | comma}} USD</h4>
				<span class="grey-txt">Total</span>
			</div>
			<div class="date-picker">
				<el-date-picker
						v-model="valueDataPicker"
						type="daterange"
						align="right"
						placeholder="Pick a range"
						:picker-options="pickerOptions2">
				</el-date-picker>
			</div>
		</div>
		<!-- end .three-grid -->
		<div class="icons-list clearfix">
			<ul>
				<li v-for="row in addTempExpensesData">
					<div class="img-boxs link-view-expenses" v-on:click="addExpensesClose">
						<el-tooltip class="item" effect="dark" :content="row.price | comma2" placement="top">
							<div class="img-wrapper">
								<el-badge v-if="row.number >1" v-bind:value=row.number class="item">
									<img v-bind:src=row.serviceurl alt="pic" class="img"/>
								</el-badge>
								<img v-if="row.number <=1" v-bind:src=row.serviceurl alt="pic" class="img"/>
							</div>
						</el-tooltip>
						<!-- end el-tooltip -->
					</div>

				</li>
			</ul>
		</div>

	</div>
	<!-- end .contents -->

	<div class="aside projects hide">
		<div class="heading">
			<h3 class="description">Projects</h3>
			<a class="btn-icon-close" href="javascript:;"></a>
		</div>
		<!-- end .heading -->
		<div class="table-data no-nav">
			<el-table
					:data="tableData"
					style="width: 100%">
				<el-table-column
						label="Date"
						width="448">
					<template scope="scope">
						<div class="list-item clearfix"  @click="changeMain(scope.row.projectid,scope.row.title,scope.row.currency)">
							<div class="color-point-block"
								>
								<div class="color-point">A</div>
								<div class="txt-area" >
									<span class="title">{{scope.row.title}}</span>
								</div>
								<!-- end .txt-area -->
							</div>
							<!-- end .color-point-block -->
							<div class="right-edit">
								<el-button icon="edit"
										   @click="editProject(scope.row.projectid,scope.row.title,scope.row.currency)"></el-button>
							</div>
							<!-- end .right-edit -->
						</div>
						<!-- end .list-item -->
					</template>
				</el-table-column>
			</el-table>
		</div>
		<!-- end .table-data -->
		<div class="bottom-bar">
			<el-button type="primary" data-toggle="modal" data-target="#modal-new-project">New Project</el-button>
		</div>
	</div>
	<!-- end .projects -->

	<aside class="aside expenses hide">
		<div class="heading">
			<h3 class="description">
				<el-select id="addmailselect" v-model="gmailvalue" @change="mailchange"
						   placeholder="Select Email">
					<el-option
							v-for="item in options"
							:label="item.label"
							:value="item.value">
						<span class="icon-g" v-show="item.icon"></span>
						<span>{{ item.label }}</span>
					</el-option>
				</el-select>
			</h3>
			<div class="customer-inputs">
				<el-input
						placeholder="Search"
						icon="search"
						v-model="inputSearch">
				</el-input>
			</div>
			<a class="btn-icon-close" href="javascript:;" v-on:click="addExpensesClose"></a>
		</div>
		<!-- end .heading -->
		<div class="nav-bar clearfix">
			<div class="nav-boxs">
				<a href="javascript:;" class="nav-item new-nav-item active">Expenses</a>
				<a href="javascript:;" class="nav-item added-nav-item">Added</a>
			</div>
		</div>
		<!-- end .nav-bar -->
		<div class="expenses-info-content">
			<div class="news-expenses">
				<div class="table-data">
					<div class="gray-cover"></div>
					<el-table
							:data="newExpensesData" style="width: 100%">
						<el-table-column
								width="531">
							<template scope="scope">
								<div class="list-item list-item-info clearfix">
									<div class="left-area">
										<div class="img-boxs">
											<img v-bind:src=scope.row.serviceurl alt="pic" class="img"/>
										</div>
										<div class="txt-area">
											<span class="title">{{scope.row.title}}</span>
											<span class="little-grey-txt date">{{scope.row.date | time}}</span>
											<span class="green-txt price">$ {{scope.row.price| comma}} USD</span>
											<p class="txt describe"
											   style="width:250px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
												{{scope.row.describe}}</p>
										</div>
										<!-- end .txt-area -->
									</div>
									<!-- end .left-area -->
									<div class="right-edit">
										<el-dropdown size="small" split-button>
											<span data-toggle="modal" @click="updateStatus(scope.row.eid)">Add</span>
											<el-dropdown-menu slot="dropdown">
												<el-dropdown-item @click.native="addNewExpense(scope.row)">
													View/Edit
												</el-dropdown-item>
												<el-dropdown-item
														@click.native="delExpense(scope.row)">Delete
												</el-dropdown-item>
											</el-dropdown-menu>
										</el-dropdown>
									</div>
									<!-- end .right-edit -->
								</div>
								<!-- end .list-item -->
							</template>
						</el-table-column>
					</el-table>

				</div>
				<!-- end .table-data -->
				<div class="bottom-bar">
					<div class="right-area" v-show="percentageValue>0 && percentageValue!=100">
						<el-progress :percentage="percentageValue"></el-progress>
					</div>
					<div class="right-area2" v-show="percentageValue==0 || percentageValue==100">
						<el-button size="small" class="btn-more" v-on:click="loadMoreRow">more</el-button>
					</div>

					<el-pagination
							small
							v-bind:page-size=newExpensesDataPageSize
							@current-change="handleCurrentChange"
							layout="prev, pager, next"
							v-bind:total=newTempExpensesData.length>
					</el-pagination>
				</div>
				<!-- end .bottom-bar -->
			</div>
			<!-- end .news-expenses -->
			<div class="added-expenses hide">
				<div class="table-data">
					<div class="gray-cover"></div>
					<el-table
							:data="addExpensesData"
							style="width: 100%">
						<el-table-column
								width="531">
							<template scope="scope">
								<div class="list-item list-item-info link-edit-webflow clearfix" @click="editActiveInvoice2(scope.row.title,scope.row.serviceurl)">
									<div class="left-area click-area">
										<div class="img-boxs">
											<img v-bind:src=scope.row.serviceurl alt="pic" class="img"/>
										</div>
										<div class="txt-area">
											<span class="title">{{scope.row.title}}</span>
											<span class="grey-txt number">{{scope.row.number}} Invoices</span>
										</div>
										<!-- end .txt-area -->
									</div>
									<!-- end .left-area -->
									<div class="right-edit">
										<el-button-group>
											<el-button icon="edit" class="open-modal-edit-added-expenses"
													   @click="editActiveInvoice(scope.row.title,scope.row.serviceurl)"></el-button>
											<el-button icon="delete" class="open-modal-delete-expenses"
													   @click="delCata(scope.row)"></el-button>
										</el-button-group>
									</div>
									<!-- end .right-edit -->
								</div>
								<!-- end .list-item -->
							</template>
						</el-table-column>
					</el-table>
				</div>
				<!-- end .table-data -->
				<div class="bottom-bar">
					<div class="right-area" v-show="percentageValue>0  && percentageValue!=100">
						<el-progress :percentage="percentageValue"></el-progress>
					</div>
					<el-pagination
							v-bind:page-size=addExpensesDataPageSize
							@current-change="handleCurrentAddChange"
							layout="prev, pager, next"
							v-bind:total=addTempExpensesData.length>>
					</el-pagination>
					<!-- <a href="javascript:;" class="btn btn-red">Gmail</a> -->
				</div>
				<!-- end .bottom-bar -->
			</div>
			<!-- end .news-expenses -->
		</div>
	</aside>
	<!-- end .expenses -->

	<aside class="aside view-expense hide">
		<div class="heading">
			<h3 class="description">View expenses</h3>
			<div class="customer-inputs">
				<el-input
						placeholder="Search"
						icon="search"
						v-model="inputSearch">
				</el-input>
			</div>
			<a class="btn-icon-close" href="javascript:;"></a>
		</div>
		<!-- end .heading -->
		<div class="table-data no-nav">
			<el-table
					:data="addExpensesData"
					style="width: 100%">
				<el-table-column
						width="448">
					<template scope="scope">
						<div class="list-item link-view-webflow clearfix" @click="filterView(scope.row)">
							<div class="left-area">
								<div class="img-boxs">
									<img v-bind:src=scope.row.serviceurl alt="pic" class="img"/>
								</div>
								<div class="txt-area">
									<span class="title">{{scope.row.title}}</span>
									<span class="grey-txt date">{{scope.row.number}} Invoices</span>
								</div>
								<!-- end .txt-area -->
							</div>
							<!-- end .color-point-block -->
							<div class="green-txt right-area right-txt">
								$ {{scope.row.price| comma}} USD
							</div>
							<!-- end .right-edit -->
						</div>
						<!-- end .list-item -->
					</template>
				</el-table-column>
			</el-table>
		</div>
		<!-- end .table-data -->
		<div class="bottom-bar">
			<el-pagination
					v-bind:page-size=addExpensesDataPageSize
					@current-change="handleCurrentAddChange"
					layout="prev, pager, next"
					v-bind:total=addTempExpensesData.length>
			</el-pagination>
		</div>
		<!-- end .bottom-bar -->
	</aside>
	<!-- end .view-expense -->

	<aside class="aside sub-list expense-detail hide" v-loading="loading">
		<div class="list-item white-color clearfix">
			<div class="left-area">
				<div class="img-boxs">
					<img v-bind:src=currentAdd.serviceurl alt="pic" class="img"/>
				</div>
				<div class="txt-area">
					<span class="title">{{currentAdd.servicename}}</span>
					<span class="grey-txt">{{currentAdd.servicetype}}</span>
				</div>
				<!-- end .txt-area -->
			</div>
			<!-- end .left-area -->
			<div class="right-area">
				<a class="btn-icon-close" href="javascript:;"></a>
			</div>
			<!-- end .right-edit -->
		</div>
		<!-- end .list-item -->
		<div class="grey-bar">
			All Invoices
		</div>
		<div class="table-data sub-data">
			<el-table
					:data="invoicesData"
					style="width: 100%">
				<el-table-column
						width="348">
					<template scope="scope">
						<div class="list-item list-item-info clearfix click-area"  @click="viewExpenseOpen(scope.row)">
							<div class="left-area">
								<div class="img-boxs">
									<img v-bind:src=scope.row.serviceurl alt="pic" class="img"/>
								</div>
								<div class="txt-area">
									<span class="title">{{scope.row.title}}</span>
									<span class="little-grey-txt">{{scope.row.date | time}}</span>
									<span class="green-txt">$ {{scope.row.price| comma}} USD</span>
									<p class="txt">{{scope.row.describe}}</p>
								</div>
								<!-- end .txt-area -->
							</div>
							<!-- end .left-area -->
						</div>
						<!-- end .list-item -->
					</template>
				</el-table-column>
			</el-table>
		</div>
		<!-- end .table-data -->
		<div class="bottom-bar">
			<el-pagination
					v-bind:page-size=invoicesDataPageSize
					@current-change="handleCurrentInvoiceChange"
					layout="prev, pager, next"
					v-bind:total=filteredInvoices.length>
			</el-pagination>
			<!-- <a href="javascript:;" class="btn btn-red">Gmail</a> -->
		</div>
		<!-- end .bottom-bar -->
	</aside>
	<!-- end .sub-list -->


	<aside class="aside sub-list edit-aside hide">
		<div class="list-item white-color clearfix title-list-item">
			<div class="left-area">
				<div class="img-boxs">
					<img v-bind:src=currentAdd.serviceurl alt="pic" class="img"/>
				</div>
				<div class="txt-area">
					<span class="title">{{currentAdd.servicename}}</span>
					<span class="grey-txt">{{currentAdd.servicetype}}</span>
				</div>
				<!-- end .txt-area -->
			</div>
			<!-- end .left-area -->
			<div class="right-area">
				<a class="btn-icon-close" href="javascript:;"></a>
			</div>
			<!-- end .right-edit -->
		</div>
		<!-- end .list-item -->
		<div class="grey-bar">
			All Invoices
		</div>
		<div class="table-data sub-data">
			<el-table
					:data="invoicesData"
					style="width: 100%">
				<el-table-column
						width="348">
					<template scope="scope">
						<div class="list-item list-item-info clearfix">
							<div class="left-area">
								<div class="img-boxs">
									<img v-bind:src=scope.row.serviceurl alt="pic" class="img"/>
								</div>
								<div class="right-edit">
									<el-button-group>
										<el-button icon="edit" data-toggle="modal"
												   @click="editInvoiceDetail(scope.row)"></el-button>
										<el-button icon="delete"
												   @click="delExpense(scope.row)"></el-button>
									</el-button-group>
								</div>
								<!-- end .right-edit -->
								<div class="txt-area">
									<span class="title">{{scope.row.title}}</span>
									<span class="little-grey-txt date">{{scope.row.date | time}}</span>
									<span class="green-txt price">$ {{scope.row.price| comma}}USD</span>
									<p class="txt describe">{{scope.row.describe}}</p>
								</div>
								<!-- end .txt-area -->
							</div>
							<!-- end .left-area -->
						</div>
						<!-- end .list-item -->
					</template>
				</el-table-column>
			</el-table>
		</div>
		<!-- end .table-data -->
		<div class="bottom-bar">
			<el-pagination
					v-bind:page-size=invoicesDataPageSize
					@current-change="handleCurrentInvoiceChange"
					layout="prev, pager, next"
					v-bind:total=filteredInvoices.length>
			</el-pagination>
			<!-- <a href="javascript:;" class="btn btn-red">Gmail</a> -->
		</div>
		<!-- end .bottom-bar -->
	</aside>
	<!-- end .edit-aside -->


	<div class="modal modal-default modal-account" id="modal-account" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<a href="#" class="btn-icon-close default-close" data-dismiss="modal" aria-label="Close"></a>
				<div class="left-area">
					<a class="left-title current" href="javascript:;">Account</a>
					<a class="left-title" href="javascript:;">Emails</a>
				</div>
				<!-- end .left-area -->
				<div class="right-area">
					<div class="right-content ">
						<div class="row">
							<el-button class="btn-logout">Logout</el-button>
							<div class="color-point-block">
								<div class="color-point grey">FL</div>
							</div>
							<div class="email-address">
								<span class="first">First Last</span>
								<span class="email">email@gmail.com</span>
							</div>
						</div>
						<!-- end .row -->
						<div class="row setting-row">
							<span class="grey-txt">Notification</span>
						</div>
						<div class="row receive-row">
							<span class="left-txt">Weekly Report</span>
							<div class="switch switch-small default-switch"  tabindex="0">
								<el-switch
										v-model="valueSwitch"
										on-text=""
										off-text="">
								</el-switch>
							</div>
							<!-- <a href="javascript:;" class="btn-checkboxs check-off"></a> -->
						</div>
						<!-- end .row -->
						<el-button type="primary" class="btn-save">Save settings</el-button>
					</div>
					<!-- end .right-content -->
					<div class="right-content right-second-content hide">
						<div class="row setting-row">
							<span class="grey-txt">Imported emails</span>
						</div>
						<div class="row receive-row email-row">
							<span class="left-txt">email@gmail.com</span>
							<a href="javascript:;" class="btn-delete el-icon-delete"></a>
						</div>
						<!-- end .row -->
						<div class="row receive-row email-row">
							<span class="left-txt">email@gmail.com</span>
							<a href="javascript:;" class="btn-delete el-icon-delete"></a>
						</div>
						<!-- end .row -->
						<div class="row receive-row email-row">
							<span class="left-txt">email@gmail.com</span>
							<a href="javascript:;" class="btn-delete el-icon-delete"></a>
						</div>
						<!-- end .row -->
						<el-button type="primary" class="btn-save">Save settings</el-button>
					</div>
				</div>
				<!-- end .right-area -->
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->

	<div class="modal modal-default modal-new-project" id="modal-new-project" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<div class="heading">
					<h4 class="title">New Project</h4>
					<a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
				</div>
				<!-- end .headding -->
				<div class="form main-group">
					<div class="row">
						<span class="text">Project name</span>
						<span class="el-inputs">
              <el-input class="project-name-input" v-model="inputProjectName"></el-input>
            </span>
					</div>
					<!-- end .row -->
					<div class="row">
						<span class="text">Currency</span>
						<el-select v-model="currencyvalue" placeholder="USD">
							<el-option
									v-for="item in currencyOptions"
									:label="item.label"
									:value="item.value">
							</el-option>
						</el-select>
						<!-- end el-select -->
					</div>
					<!-- end .row -->
					<div class="btn-boxs">
						<el-button type="primary" class="btn-create-project" @click="saveProject">Create</el-button>
					</div>
					<!-- end .btn-boxs -->
				</div>
				<!-- end .form -->
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->

	<div class="modal modal-default modal-edit-project" v-show="show" id="modal-edit-project" tabindex="-1"
		 role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<div class="heading">
					<h4 class="title">Edit Project</h4>
					<a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
				</div>
				<!-- end .headding -->
				<div class="form main-group">
					<div class="row">
						<span class="text">Project name</span>
						<span class="el-inputs">
              <el-input class="project-name-input" v-model="inputProjectName"></el-input>
            </span>
					</div>
					<!-- end .row -->
					<div class="row">
						<span class="text">Currency</span>
						<el-select v-model="currencyvalue" placeholder="USD">
							<el-option
									v-for="item in currencyOptions"
									:label="item.label"
									:value="item.value">
							</el-option>
						</el-select>
					</div>
					<!-- end .row -->
					<div class="btn-boxs">
						<el-button type="primary" class="btn-submit-project" @click="editSaveProject">Save</el-button>
					</div>
					<!-- end .btn-boxs -->
				</div>
				<!-- end .form -->
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->

	<div class="modal modal-default modal-info-bounced" id="modal-info-bounced" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<div class="heading">
					<h4 class="title">{{mail_subject}}</h4>
					<span class="btn-bg-txt">{{target}}</span>
					<a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
				</div>
				<!-- end .headding -->
				<div class="content-boxs">
					<p class="txt">
					<div style="overflow-y:scroll;  height:300px;">
						<h5 v-html="mail_content"></h5>
					</div>
					</p>
				</div>
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->

	<div class="modal modal-default modal-add-expenses" id="modal-add-expenses" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<div class="heading">
					<h4 class="title">{{mail_subject}}</h4>
					<span class="btn-bg-txt">{{target}}</span>
					<a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
				</div>
				<!-- end .headding -->
				<div class="content-boxs">
					<p class="txt">
					<div style="overflow-y:scroll;  height:300px;">
						<h5 v-html="mail_content"></h5>
					</div>
					</p>
					<div class="update-form">
						<el-row :gutter="15">
							<el-col :span="10">
								<div class="grid-content">
									<span class="text">Service</span>
									<el-input v-model="inputEid" style="display:none"></el-input>
									<el-input class="project-name-input" v-model="inputService"
											  placeholder="webflow.com"></el-input>
								</div>
							</el-col>
							<el-col :span="10">
								<div class="grid-content">
									<span class="text">Cost (USD)</span>
									<el-input class="project-name-input" v-model="inputCost"
											  placeholder="9.9"></el-input>
								</div>
							</el-col>
							<el-col :span="4">
								<div class="grid-content">
									<el-button type="primary" @click="updateExpense">Update</el-button>
								</div>
							</el-col>
						</el-row>
					</div>
				</div>
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->

	<div class="modal modal-default modal-edit-added-expenses" id="modal-edit-added-expenses" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<div class="heading">
					<h4 class="title">Edit</h4>
					<a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
				</div>
				<!-- end .headding -->
				<div class="form main-group">
					<div class="row">
						<span class="text">Service</span>
						<span class="el-inputs">
				<el-input v-model="inputServiceName" style="display:none"></el-input>
              <el-input v-model="inputService" class="service-name-input"></el-input>
            </span>
					</div>
					<!-- end .row -->
					<div class="btn-boxs">
						<el-button type="primary" class="btn-update-expense" @click="updateServiceName">Update
						</el-button>
					</div>
					<!-- end .btn-boxs -->
				</div>
				<!-- end .form -->
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->

	<div class="modal modal-default modal-edit-expenses" id="modal-edit-expenses" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<div class="heading">
					<h4 class="title">Edit</h4>
					<a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
				</div>
				<!-- end .headding -->
				<div class="form main-group">
					<div class="row">
						<span class="text">Service</span>
						<span class="el-inputs">
			  <el-input v-model="inputEid" style="display:none"></el-input>
              <el-input v-model="inputService" class="service-name-input"></el-input>
            </span>
					</div>
					<!-- end .row -->
					<div class="row">
						<span class="text">Cost(USD)</span>
						<span class="el-inputs">
              <el-input v-model="inputCost" class="cost-input"></el-input>
            </span>
					</div>
					<!-- end .row -->
					<div class="btn-boxs">
						<el-button type="primary" class="btn-update-expense" @click="updateExpense">Update</el-button>
					</div>
					<!-- end .btn-boxs -->
				</div>
				<!-- end .form -->
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->

	<div class="modal modal-default modal-delete-expenses" id="modal-delete-expenses" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content clearfix">
				<div class="heading">
					<h4 class="title">Delete</h4>
					<a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
				</div>
				<!-- end .headding -->
				<div class="form main-group">
					<div class="row">
						<span class="text">Are you sure you want to delete this expense?</span>
					</div>
					<!-- end .row -->
					<div class="btn-boxs">
						<el-button type="primary" data-dismiss="modal" @click="delInvoice()">Delete it</el-button>
						<el-button  data-dismiss="modal" aria-label="Close">Cancel</el-button>
					</div>
					<!-- end .btn-boxs -->
				</div>
				<!-- end .form -->
			</div>
			<!-- .modal-content -->
		</div>
		<!-- .modal-dialog -->
	</div>
	<!-- end .modal -->
</div>
</body>
<!-- jQuery library -->
<script src="js/jquery-3.1.0.min.js"></script>
<script src="lib/bootstrap/js/bootstrap.min.js"></script>
<script src="//unpkg.com/vue"></script>
<script src="//unpkg.com/element-ui"></script>
<script src="//unpkg.com/element-ui/lib/umd/locale/en.js"></script>
<script src="https://cdn.ravenjs.com/3.12.1/vue/raven.min.js"
		crossorigin="anonymous"></script>
<script>Raven.config('https://3e029b6fd3c740069c1792eebcaf628d@sentry.io/148957').install();</script>
<!-- Main JS -->

<script src="js/script.js"></script>
<script>
    ELEMENT.locale(ELEMENT.lang.en)
    var maxh = $(window).height();
    $("el-table__body").height("100");
    //    window.onresize = function(){
    //        if(document.documentElement.clientHeight<700){
    //            $('.el-table__body-wrapper').css("height",document.documentElement.clientHeight);
    //		}else{
    //            $('.el-table__body-wrapper').css("height","650px");
    //		}
    //
    //    }
</script>
</html>