<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<%
    HttpSession Session = request.getSession();
    String globalUserId = (String) Session.getAttribute("globalUserId");
    String globalUserAccount = (String) Session.getAttribute("globalUserAccount");
%>
<!DOCTYPE html>
<html>
<head>
    <!-- Meta Tags -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="format-detection" content="telephone=no">
    <title>Home</title>

    <!-- Bootstrap -->
    <link href="lib/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="lib/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
    <link rel="stylesheet" href="node_modules/element-ui/lib/theme-default/index.css">
    <!-- Main CSS -->
    <link href="css/font.css" rel="stylesheet"/>
    <link href="css/screen.css" rel="stylesheet"/>
</head>
<body>
<header class="header">
    <a href="javascript:;" class="logo logo-track">tracko</a>
    <nav class="right-nav">
        <a href="javascript:;" class="link-projects">
            <span class="btn-project current">Dashboard</span>
        </a>
        <a href="javascript:;" class="link-projects">
            <span class="btn-project">Projects</span>
        </a>
        <a href="#" class="account-link" data-toggle="modal" data-target="#modal-account">
            Account
        </a>
    </nav>
</header>
<!-- .header -->
<div id="app" v-loading="appLoading" element-loading-text="Loading Project Data now...">

    <div class="top-area">
        <a href="javascript:;" class="left-area left-area-project" v-on:click="addExpensesClose">
            <div class="color-point-block">
                <div class="color-point">A</div>
                <div class="txt-area">
                    <span class="title" id="projecttitlespan"></span>
                </div>
                <!-- end .txt-area -->
            </div>
            <!-- end .color-point-block -->
        </a>
        <div href="javascript:;" class="left-area left-area-project">
            <div class="blue-block">
            </div>
            <!-- end .color-point-block -->
            <a href="javascript:;" class="link link-projects">
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
                <h4 class="price">$ {{totalPrice}} USD</h4>
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
                <li v-for="row in addExpensesData">
                    <div class="img-boxs link-view-expenses" v-on:click="addExpensesClose">
                        <el-tooltip class="item" effect="dark" v-bind:content="row.price.toString()" placement="top">
                            <div class="img-wrapper">
                                <img v-bind:src=row.serviceurl alt="pic" class="img"/>
                                <sup v-if="row.number >1" class="el-badge__content is-fixed">{{row.number}}</sup>
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
                        <div class="list-item clearfix">
                            <div class="color-point-block"
                                 @click="changeMain(scope.row.projectid,scope.row.title,scope.row.currency)">
                                <div class="color-point">A</div>
                                <div class="txt-area">
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
                <el-select v-model="value" placeholder="Select Email">
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
            <div class="nav-bar-right clearfix">
                <el-select id="addmailselect" v-model="gmailvalue" @change="mailchange"
                           placeholder="Decembemail@gmail.com">
                    <el-option
                            v-for="item in options"
                            :label="item.label"
                            :value="item.value">
                        <span class="icon-g" v-show="item.icon"></span>
                        <span>{{ item.label }}</span>
                    </el-option>
                </el-select>
                <el-button type="primary" class="btn-import" @click="importEmail">Import</el-button>
                <el-button type="primary" class="btn-import" @click="importEmail">LoadMore</el-button>
            </div>
            <!-- end .nav-bar-right -->
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
                    <el-table v-loading.body="loading"
                              :data="newExpensesData"
                              style="width: 100%">
                        <el-table-column
                                width="531">
                            <template scope="scope">
                                <div class="list-item list-item-info clearfix">
                                    <el-checkbox v-model="scope.row.checked" class="check-box"></el-checkbox>
                                    <div class="left-area">
                                        <div class="img-boxs">
                                            <img v-bind:src=scope.row.serviceurl alt="pic" class="img"/>
                                        </div>
                                        <div class="txt-area">
                                            <span class="title">{{scope.row.title}}</span>
                                            <span class="little-grey-txt date">{{scope.row.date | time}}</span>
                                            <span class="green-txt price">$ {{scope.row.price}} USD</span>
                                            <p class="txt describe"
                                               style="width:250px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                                {{scope.row.describe}}</p>
                                        </div>
                                        <!-- end .txt-area -->
                                    </div>
                                    <!-- end .left-area -->
                                    <div class="right-edit">
                                        <el-button-group>
                                            <el-button type="primary" icon="plus"
                                                       @click="updateStatus(scope.row.eid)"></el-button>
                                            <el-button icon="message"></el-button>
                                            <el-button icon="edit" data-toggle="modal"
                                                       @click="updateNewExpense(scope.row)"></el-button>
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
                    <div class="right-area">
                        <el-button-group>
                            <el-button type="primary" icon="plus" @click="batchUpdateStatus"></el-button>
                            <el-button icon="delete" data-toggle="modal"
                                       data-target="#modal-delete-expenses"></el-button>
                        </el-button-group>
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
                    <el-table v-loading.body="loading"
                              :data="addExpensesData"
                              style="width: 100%">
                        <el-table-column
                                width="531">
                            <template scope="scope">
                                <div class="list-item list-item-info link-edit-webflow clearfix">
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
                    <div class="right-area">
                        <el-button-group>
                            <el-button type="primary" icon="plus"></el-button>
                            <el-button icon="delete" data-toggle="modal"
                                       data-target="#modal-delete-expenses"></el-button>
                        </el-button-group>
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
                                $ {{scope.row.price}} USD
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
        <div class="list-item clearfix">
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
                <a href="javascript:;" class="icon-i el-icon-information"></a>
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
                    :data="filteredInvoices"
                    style="width: 100%">
                <el-table-column
                        width="348">
                    <template scope="scope">
                        <div class="list-item list-item-info clearfix click-area" data-toggle="modal"
                             data-target="#modal-info-bounced">
                            <div class="left-area">
                                <div class="img-boxs">
                                    <img v-bind:src=scope.row.serviceurl alt="pic" class="img"/>
                                </div>
                                <div class="txt-area">
                                    <span class="title">{{scope.row.title}}</span>
                                    <span class="little-grey-txt">{{scope.row.date | time}}</span>
                                    <span class="green-txt">$ {{scope.row.price}} USD</span>
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
                    v-bind:total=tempinvoicesData.length>
            </el-pagination>
            <!-- <a href="javascript:;" class="btn btn-red">Gmail</a> -->
        </div>
        <!-- end .bottom-bar -->
    </aside>
    <!-- end .sub-list -->


    <aside class="aside sub-list edit-aside hide">
        <div class="list-item clearfix title-list-item">
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
                <i class="icon-i el-icon-information"></i>
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
                    :data="filteredInvoices"
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
                                        <el-button icon="delete" data-toggle="modal"
                                                   data-target="#modal-delete-expenses"
                                                   @click="delExpense(scope.row)"></el-button>
                                    </el-button-group>
                                </div>
                                <!-- end .right-edit -->
                                <div class="txt-area">
                                    <span class="title">{{scope.row.title}}</span>
                                    <span class="little-grey-txt date">{{scope.row.date | time}}</span>
                                    <span class="green-txt price">$ {{scope.row.price}}USD</span>
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
                    <a class="left-title" href="javascript:;">Account</a>
                </div>
                <!-- end .left-area -->
                <div class="right-area">
                    <div class="right-content">
                        <div class="row">
                            <el-button class="btn-logout" @click="logout">Logout</el-button>
                            <div class="color-point-block">
                                <div class="color-point blue">A</div>
                            </div>
                            <span class="email-address"><%=globalUserAccount %></span>
                        </div>
                        <!-- end .row -->
                        <div class="row setting-row">
                            <span class="grey-txt">Settings</span>
                        </div>
                        <div class="row receive-row">
                            <span class="left-txt">Receive newsletters</span>
                            <div class="switch switch-small default-switch" tabindex="0">
                                <el-switch
                                        v-model="valueSwitch"
                                        on-text=""
                                        off-text="">
                                </el-switch>
                            </div>
                            <!-- <a href="javascript:;" class="btn-checkboxs check-off"></a> -->
                        </div>
                        <!-- end .row -->
                        <div class="long-line"></div>
                        <div class="row setting-row">
                            <span class="grey-txt">Imported emails</span>
                        </div>

                        <div v-for="row in filteredEmails" class="row receive-row email-row">
                            <span class="left-txt">{{row.label}}</span>
                            <a href="javascript:" @click="delEmail(row)" class="btn-delete el-icon-delete"></a>
                        </div>

                        <!-- end .row -->
                        <div class="long-line"></div>
                        <el-button type="primary" class="btn-save">Save settings</el-button>
                    </div>
                    <!-- end .right-content -->
                </div>
                <!-- end .right-area -->
            </div>
            <!-- .modal-content -->
        </div>
        <!-- .modal-dialog -->
    </div>
    <!-- end .modal -->

    <%--<el-form :model="numberValidateForm" ref="numberValidateForm" label-width="100px" class="demo-ruleForm">--%>
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
    <%--</el-form>--%>

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
                        <el-button type="primary" class="btn-submit-project" @click="editSaveProject">Submit</el-button>
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
                    <h4 class="title">Best Applicant Update: One page web app UI design</h4>
                    <span class="btn-bg-txt">donotreply@upwork.com</span>
                    <a href="#" class="btn-icon-close" data-dismiss="modal" aria-label="Close"></a>
                </div>
                <!-- end .headding -->
                <div class="content-boxs">
                    <p class="txt">
                        Action required - please login to your account and provide your Certificate Signing Request!
                    </p>
                    <p class="txt">Remind me again in: 4 days 7 days 30 days</p>
                </div>
            </div>
            <!-- .modal-content -->
        </div>
        <!-- .modal-dialog -->
    </div>
    <!-- end .modal -->

    <div class="modal modal-default modal-edit-added-expenses" id="modal-edit-added-expenses" tabindex="-1"
         role="dialog">
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
                        <el-button data-dismiss="modal" aria-label="Close">Cancel</el-button>
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
<script src="node_modules/vue/dist/vue.js"></script>
<script src="node_modules/element-ui/lib/index.js"></script>

<!-- Main JS -->
<script>
    $(document).ready(function () {
        InitPage();
    })
    function InitPage() {
        //click Checkbox options
        $(".btn-checkboxs").click(function () {
            if ($(this).hasClass("check-off")) {
                $(this).addClass("check-on").removeClass("check-off")
            }
            else {
                $(this).addClass("check-off").removeClass("check-on")
            }
        });

        //click dropdown options
        $(".dropdown-default .dropdown-menu li a").click(function () {
            $(this).parents(".dropdown-default").find(".selected-option").html($(this).html());
            $(this).parents(".dropdown-default").removeClass("field-error");
        });

        //click "Create" button in modal window of Create Project
        //click "Submit" button in modal window of Edit Project
        $("#modal-new-project .btn-create-project,\
     #modal-edit-project .btn-submit-project").click(function () {
            var modal_window = $(this).parents(".modal-default");
            var pass = true;

            if (modal_window.find(".project-name-input").find("input").val() === "") {
                pass = false;
                modal_window.find(".project-name-input").addClass("field-error");
            }
            else {
                modal_window.find(".project-name-input").removeClass("field-error");
            }

            if (pass) {
                $(this).html("Please wait...");
            }
        })

        //click "Update" button in 2 modal window of Edit Service
        $("#modal-edit-expenses .btn-update-expense,\
     #modal-edit-added-expenses .btn-update-expense").click(function () {
            var modal_window = $(this).parents(".modal-default");
            var pass = true;

            if (modal_window.find(".service-name-input").find("input").val() === "") {
                pass = false;
                modal_window.find(".service-name-input").addClass("field-error");
            }
            else {
                modal_window.find(".service-name-input").removeClass("field-error");
            }

            if (modal_window.find(".cost-input").length > 0) {
                if (modal_window.find(".cost-input").find("input").val() === "") {
                    pass = false;
                    modal_window.find(".cost-input").addClass("field-error");
                }
                else {
                    modal_window.find(".cost-input").removeClass("field-error");
                }
            }

            if (pass) {
                $(this).html("Please wait...");
            }
        })

        //open modal window
        $("#modal-new-project,\
     #modal-edit-project,\
     #modal-edit-expenses,\
     #modal-edit-added-expenses").on('shown.bs.modal', function (e) {
            $(this).find("input").val("");
            $(this).find("input").parent().removeClass("field-error");
            $(this).find(".btn-create-project").html("Create");
            $(this).find(".btn-submit-project").html("Submit");
            $(this).find(".btn-update-expense").html("Update");
        })

        //focus in input boxes in Create Project/Edit Project modal window
        $(".modal-default input[type='text']").focus(function () {
            $(this).removeClass("field-error");
        })

        //click to show Projects List sidebar
        $(".link-projects,.left-area-project").click(function () {
            $(".aside").addClass("hide");

            $(".aside.projects").removeClass("hide");
        })

        //click to show View expenses sidebar
        $(".link-view-expenses").click(function () {
            $(".aside").addClass("hide");

            $(".aside.view-expense").removeClass("hide");
        })

        //click to show Add and edit expenses sidebar
        $(".link-add-expenses").click(function () {

        })

        //click News tab in Add and edit expenses sidebar
        $(".aside.expenses .new-nav-item").click(function () {
            $(".aside.expenses .new-nav-item").addClass("active");
            $(".aside.expenses .added-nav-item").removeClass("active");

            $(".aside.expenses .news-expenses").removeClass("hide");
            $(".aside.expenses .added-expenses").addClass("hide");
        })

        //click Added tab in Add and edit expenses sidebar
        $(".aside.expenses .added-nav-item").click(function () {
            $(".aside.expenses .new-nav-item").removeClass("active");
            $(".aside.expenses .added-nav-item").addClass("active");

            $(".aside.expenses .news-expenses").addClass("hide");
            $(".aside.expenses .added-expenses").removeClass("hide");
        })

        //click items in Added tab in Add and edit expenses sidebar
        $(".link-edit-webflow").click(function () {
            $(".aside.edit-aside").removeClass("hide");
        })

        //click Edit icon of Add and edit expenses sidebar
        $(".open-modal-edit-added-expenses").click(function (event) {
            $("#modal-edit-added-expenses").modal('show');
        })

        //click Delete icon of Add and edit expenses sidebar
        $(".open-modal-delete-expenses").click(function (event) {
            event.stopPropagation();
            $('#modal-delete-expenses').modal('show');
        })

        //click items in View expenses sidebar
        $(".link-view-webflow").click(function () {
            $(".aside.expense-detail").removeClass("hide");
        })

        //click X icon in right sidebar
        $(".aside .btn-icon-close").click(function () {
            $(this).parents(".aside").addClass("hide");
        })

        //when open Edit Service modal window,cover the right sidebar
        $('#modal-edit-expenses').on('shown.bs.modal', function (e) {
            $(".edit-aside").css("z-index", "1000");
            $("#modal-edit-added-expenses").modal("hide");
        })

        //when close Edit Service modal window,reset the z-index of right sidebar
        $('#modal-edit-expenses').on('hidden.bs.modal', function (e) {
            $(".edit-aside").css("z-index", "10000");
        })
    }
    //check URL format
    function checkURL(str_url) {
        var strRegex = "^((https|http|ftp|rtsp|mms)?://)"
            + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp's user@
            + "(([0-9]{1,3}.){3}[0-9]{1,3}" // IP format URL- 199.194.52.184
            + "|" // allow IP and DOMAIN
            + "([0-9a-z_!~*'()-]+.)*" // DOMAIN- www.
            + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]." // Secondart DOMAIN
            + "[a-z]{2,6})" // first level domain- .com or .museum
            + "(:[0-9]{1,4})?" // port- :80
            + "((/?)|" // a slash isn't required if there is no file name
            + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";

        var re = new RegExp(strRegex);
        //re.test()

        if (re.test(str_url)) {
            return (true);
        } else {
            return (false);
        }
    }


    //element-ui script code
    var Main = {
        data() {
            return {
                valueDataPicker: "",
                inputSearch: "",
                inputAddSearch: "",
                valueSwitch: true,
                appLoading: true,
                inputProjectId: 0,
                inputProjectName: "",
                currentProjectId: 0,
                inputEid: 0,
                delCatagory: "",
                delEid: 0,
                inputService: "",
                inputServiceName: "",
                inputCost: 0,
                show: false,
                loading: false,
                options: [{
                    value: 0.5,
                    label: ' ',
                    icon: false,
                    token: ''
                }, {
                    value: 0,
                    label: 'Add Gmail',
                    icon: true,
                    token: ''
                }],
                currencyOptions: [{
                    value: '1',
                    label: 'USD'
                }, {
                    value: '2',
                    label: 'CAD'
                }, {
                    value: '3',
                    label: 'Third Choice'
                }],
                currentAdd: {
                    servicename: "",
                    serviceurl: ""
                },
                currencyvalue: 1,
                gmailvalue: '',
                pickerOptions2: {
                    shortcuts: [{
                        text: 'Last week',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: 'Last month',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
                            picker.$emit('pick', [start, end]);
                        }
                    }, {
                        text: 'Last 3 months',
                        onClick(picker) {
                            const end = new Date();
                            const start = new Date();
                            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
                            picker.$emit('pick', [start, end]);
                        }
                    }]
                },
                valueSwitch: true,
                valueDatePicker: '',
                tableData: [],
                totalPrice: 0,
                newExpensesData: [],
                newTempExpensesData: [],
                newTempSearchExpensesData: [],
                newExpensesDataPageSize: 8,
                newExpensesDataPageNum: 1,
                addExpensesData: [],
                addTempExpensesData: [],
                addTempSearchExpensesData: [],
                addExpensesDataPageSize: 10,
                addExpensesDataPageNum: 1,
                invoicesData: [],
                tempinvoicesData: [],
                invoicesDataPageSize: 8,
                invoicesDataPageNum: 1,
                viewExpensesData: [],
                tempviewExpensesData: [],
                viewExpensesPageSize: 8,
                viewExpensesPageNum: 1
            };
        }, ready: {}, computed: {
            filteredInvoices: function () {
                var self = this
                var servicename = self.currentAdd.servicename;
                return self.tempinvoicesData.filter(function (invoicesData) {
                    return (invoicesData.title == servicename)
                })
                vm.changeInvoicePage();
            },
            filteredEmails: function () {
                var self = this
                return self.options.filter(function (option) {
                    return (option.value >= 1)
                })
            }
        },
        // methods of pages
        methods: {
            delEmail: function (row) {
                var saveData = {};
                saveData = {
                    "emailaddress": row.title
                };
                $.ajax({
                    url: "/Emaillist/delEmaillist",
                    type: "post",
                    async: true,
                    contentType: "application/json",
                    //提交的数据
                    data: JSON.stringify(saveData),
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {
                        vm.loadExpenses();
                    },
                    error: function (e) {
                    }
                });
            },
            logout: function () {
                window.location.href = 'index';
            },
            hideAppLoading: function () {
                vm.$data.appLoading = false;
            },
            handleCurrentChange: function (val) {
                vm.$data.newExpensesDataPageNum = val;
                vm.changePage();
            }, handleCurrentAddChange: function (val) {
                vm.$data.addExpensesDataPageNum = val;
                vm.changeAddPage();
            }, handleCurrentInvoiceChange: function (val) {
                vm.$data.invoicesDataPageNum = val;
                vm.changeInvoicePage();
            }, handleCurrentViewChange: function (val) {
                vm.$data.viewExpensesPageNum = val;
                vm.changeViewExpensesPage();
            },
            changePage: function () {
                console.dir(vm.$data.newTempExpensesData);
                var page = vm.$data.newExpensesDataPageNum;
                var pagesize = vm.$data.newExpensesDataPageSize;
                var addExpensesData1 = vm.$data.newTempExpensesData;
                var newAddExpensesData = [];
                for (var i = 0; i < pagesize; i++) {
                    if (typeof(addExpensesData1[(page - 1) * pagesize + i]) == "undefined") {
                        break;
                    }

                    newAddExpensesData.push(addExpensesData1[(page - 1) * pagesize + i]);
                }
                vm.$data.newExpensesData = newAddExpensesData;
            },
            changeAddPage: function () {

                var page = vm.$data.addExpensesDataPageNum;
                var pagesize = vm.$data.addExpensesDataPageSize;
                var addExpensesData2 = vm.$data.addTempExpensesData;
                var newAddExpensesData = [];
                for (var i = 0; i < pagesize; i++) {
                    if (typeof(addExpensesData2[(page - 1) * pagesize + i]) == "undefined") {
                        break;
                    }

                    newAddExpensesData.push(addExpensesData2[(page - 1) * pagesize + i]);
                }
                vm.$data.addExpensesData = newAddExpensesData;
            }, changeInvoicePage: function () {

                var page = vm.$data.invoicesDataPageNum;
                var pagesize = vm.$data.invoicesDataPageSize;
                var addExpensesData3 = vm.$data.tempinvoicesData;
                var newAddExpensesData = [];
                for (var i = 0; i < pagesize; i++) {
                    if (typeof(addExpensesData3[(page - 1) * pagesize + i]) == "undefined") {
                        break;
                    }

                    newAddExpensesData.push(addExpensesData3[(page - 1) * pagesize + i]);
                }
                vm.$data.invoicesData = newAddExpensesData;
            }, changeViewExpensesPage: function () {

                var page = vm.$data.viewExpensesPageNum;
                var pagesize = vm.$data.viewExpensesPageSize;
                var addExpensesData4 = vm.$data.tempviewExpensesData;
                var newAddExpensesData = [];
                for (var i = 0; i < pagesize; i++) {
                    if (typeof(addExpensesData4[(page - 1) * pagesize + i]) == "undefined") {
                        break;
                    }

                    newAddExpensesData.push(addExpensesData4[(page - 1) * pagesize + i]);
                }
                vm.$data.viewExpensesData = newAddExpensesData;
            },
            editInvoiceDetail: function (obj) {
                $('#modal-edit-expenses').modal();
                vm.$data.inputService = obj.title + ".com";
                vm.$data.inputEid = obj.eid;
                vm.$data.inputCost = obj.price;
                setTimeout(function () {
                    vm.$forceUpdate();
                }, 1000)
                vm.$forceUpdate();
            }, delCata: function (obj) {
                vm.$data.delCatagory = obj.title;
            }, delExpense: function (obj) {
                vm.$data.delEid = obj.eid;

            }, delInvoice: function () {
                var saveData = {};
                if (vm.$data.delEid == "") {
                    saveData = {
                        "servicename": vm.$data.delCatagory
                    };
                } else {
                    saveData = {
                        "eid": vm.$data.delEid
                    };
                }
                $.ajax({
                    url: "/expense/delExpenses",
                    type: "post",

                    async: true,
                    contentType: "application/json",
                    //提交的数据
                    data: JSON.stringify(saveData),
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {
                        vm.$data.delEid = "";
                        vm.$data.delCatagory = "";
                        vm.loadExpenses();
                    },
                    error: function (e) {
                    }
                });

            },
            filterView: function (scope) {
                vm.$data.currentAdd = {
                    servicename: scope.title,
                    servicetype: scope.serviceurl.slice(26),
                    serviceurl: scope.serviceurl
                };
            },
            editActiveInvoice: function (servicename, serviceurl) {
                vm.$data.currentAdd = {
                    servicename: servicename,
                    servicetype: serviceurl.slice(26),
                    serviceurl: serviceurl
                };
                $("#modal-edit-added-expenses").modal('show');
                vm.$data.inputServiceName = servicename;
                vm.$data.inputService = serviceurl.slice(26);
                vm.$forceUpdate();
            }, updateServiceName: function () {
                vm.$data.loading = true;
                var saveData = {
                    "servicename": vm.$data.inputServiceName,
                    "serviceurl": vm.$data.inputService
                };
                $.ajax({
                    url: "/expense/updateCata",
                    type: "post",
                    contentType: "application/json",
                    //提交的数据
                    data: JSON.stringify(saveData),
                    async: true,
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {
                        $('#modal-edit-added-expenses').modal('hide');
                        vm.loadExpenses();
                        vm.$data.loading = false;
                    },
                    error: function (e) {
                    }
                });
            }, updateNewExpense: function (obj) {
                $('#modal-edit-expenses').modal();
                vm.$data.inputService = obj.title;
                vm.$data.inputEid = obj.eid;
                vm.$data.inputCost = obj.price;


                setTimeout(function () {

                    vm.$forceUpdate();
                }, 1000)
                vm.$forceUpdate();
            }, updateExpense: function () {
                vm.$data.loading = true;
                var saveData = {
                    "eid": vm.$data.inputEid,
                    "servicename": vm.$data.inputService,
                    "cost": vm.$data.inputCost
                };
                $.ajax({
                    url: "/expense/update",
                    type: "post",
                    contentType: "application/json",
                    //提交的数据
                    async: true,
                    data: JSON.stringify(saveData),
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {
                        $('#modal-edit-expenses').modal('hide');
                        vm.loadExpenses();
                        vm.$data.loading = false;
                    },
                    error: function (e) {
                        console.log("project save error.." + e);
                    }
                });
            },
            //validate the Login Form
            addExpensesOpen: function (event) {
                $(".aside").addClass("hide");

                $(".aside.expenses").removeClass("hide");

                $(".aside.expenses .new-nav-item").addClass("active");
                $(".aside.expenses .added-nav-item").removeClass("active");

                $(".aside.expenses .news-expenses").removeClass("hide");
                $(".aside.expenses .added-expenses").addClass("hide");

//                this.loading = true;

//                setTimeout(() => {
//                    this.loading = false;
//            }, 3000);
            }, loadEmail: function () {

                var options = [{
                    value: '0.5',
                    label: ' ',
                    icon: false,
                    token: ''
                }, {
                    value: '0',
                    label: 'Add Gmail',
                    icon: true,
                    token: ''
                }];
                var json = "";
                $.ajax({
                    url: "/Emaillist/getList?pid=" + vm.$data.currentProjectId,
                    type: "get",
                    contentType: "application/json",
                    async: true,
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {
                        for (var i = 0; i < data.length; i++) {
                            if (i == 0) {
                                $('#projecttitlespan').html(data[i].projectname);
                                vm.$data.currentProjectId = data[i].pid;
                            }
                            var obj = {
                                value: data[i].eid,
                                label: data[i].emailaddress,
                                icon: false,
                                token: data[i].accesstoken
                            }
                            options.push(obj);

                        }
                        vm.$data.options = options;
                        vm.loadExpenses();
                    },
                    error: function (e) {
                        console.log("project load error.." + e);
                    }
                });

            }, loadProject: function () {
                vm.$data.appLoading = true;
                $.ajax({
                    url: "/project/getList",
                    type: "get",
                    contentType: "application/json",
                    //提交的数据
                    data: null,
                    async: true,
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {

                        this.tableData = [];
                        vm.$data.tableData = [];
                        if (data.length == 0) {
                            $('.contents').css('display', 'none');
                            $('.top-area').css('display', 'none');

                        }
                        for (var i = 0; i < data.length; i++) {
                            if (i == 0) {
                                $('#projecttitlespan').html(data[i].projectname);
                                vm.$data.currentProjectId = data[i].pid;
                                $('.contents').css('display', 'block');
                                $('.top-area').css('display', 'block');
                                vm.loadEmail();
                            }
                            var obj = {projectid: data[i].pid, title: data[i].projectname, currency: data[i].currency};
                            vm.$data.tableData.push(obj);
                        }
                        vm.$data.appLoading = false;
                    },
                    error: function (e) {
                        vm.$message.error("project load error..");
                    }
                });
            }, importEmail: function () {
                vm.$data.appLoading = true;
                $.ajax({
                    url: "/google/import/importemail?pid=" + vm.$data.currentProjectId,
                    type: "get",
                    contentType: "application/json",
                    async: true,
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {
                        vm.$message({
                            message: 'success!' + data.data,
                            type: 'success'
                        });
                        vm.loadExpenses();
                        vm.hideAppLoading();
                    },
                    error: function (e) {
                        vm.$message.error("project load error..");
                    }
                });

            }, batchUpdateStatus: function () {
                vm.$data.loading = true;
                var batchUpdate = [];
                for (var j = 0; j < vm.$data.newExpensesData.length; j++) {
                    batchUpdate.push(vm.$data.newExpensesData[j]);
                }
                for (var i = 0; i < batchUpdate.length; i++) {
                    if (batchUpdate[i].checked == true) {
                        vm.$data.loading = true;
                        vm.updateStatus(batchUpdate[i].eid)
                        vm.$data.loading = false;
                    }
                }
            }, updateStatus: function (eid) {
                vm.$data.loading = true;
                var saveData = {
                    "eid": eid
                };

                // let it fast!
//                        vm.loadExpenses();
                var invoicesDataT = {};
                for (var newnum = 0; newnum < vm.$data.newExpensesData.length; newnum++) {
                    if (vm.$data.newExpensesData[newnum].eid == eid) {
                        invoicesDataT = vm.$data.newExpensesData[newnum];
                        vm.$data.newExpensesData.splice(newnum, 1);
                        break;
                    }
                }
                for (var newnum = 0; newnum < vm.$data.newTempExpensesData.length; newnum++) {
                    if (vm.$data.newTempExpensesData[newnum].eid == eid) {
                        vm.$data.newTempExpensesData.splice(newnum, 1);
                        break;
                    }
                }
                var addexpense = vm.$data.addExpensesData;
                var flag = false;
                for (var ad = 0; ad < addexpense.length; ad++) {
                    if (addexpense[ad].title == invoicesDataT.title) {
                        var num = addexpense[ad].number + 1;
                        addexpense[ad].number = num;

                        if (typeof(invoicesDataT.price != undefined)) {
                            addexpense[ad].price = parseFloat(addexpense[ad].price) + parseFloat(invoicesDataT.price);
                            addexpense[ad].price = addexpense[ad].price.toFixed(2);
                            vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(invoicesDataT.price);
                        }
                        flag = true;
                        break;
                    }
                }

                if (flag == false) {
                    var addobj = {
                        title: invoicesDataT.title,
                        serviceurl: invoicesDataT.serviceurl,
                        price: '' + invoicesDataT.price,
                        number: 1
                    };
                    if (typeof(invoicesDataT.price != undefined)) {
                        vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(invoicesDataT.price);
                    }
                    vm.$data.addExpensesData.push(addobj);
                }
                if (vm.$data.addExpensesData.length == 0) {
                    var addobj = {
                        title: invoicesDataT.title,
                        serviceurl: invoicesDataT.serviceurl,
                        price: invoicesDataT.price,
                        number: 1
                    };
                    if (typeof(invoicesDataT.price != undefined)) {
                        vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(invoicesDataT.price);
                    }
                    vm.$data.addExpensesData.push(addobj);
                }
                var totalPriceInt = parseFloat(vm.$data.totalPrice).toFixed(2);
                vm.$data.totalPrice = totalPriceInt;
                vm.$nextTick(function () {
                    InitPage();
                    vm.$message({
                        message: 'Add Expense success!',
                        type: 'success'
                    });
                });
                vm.initChangePage2();
                vm.$data.invoicesData.push(invoicesDataT);
                vm.$data.viewExpensesData.push(invoicesDataT);
                vm.$data.loading = false;
                $.ajax({
                    url: "/expense/updateStatus",
                    type: "post",
                    contentType: "application/json",
                    //提交的数据
                    data: JSON.stringify(saveData),
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {

                    },
                    error: function (e) {
                        vm.$message.error("Add Expense error..");
                    }
                });
            }, loadExpenses: function () {
                vm.$data.appLoading = true;
                vm.$data.newExpensesData = [];
                vm.$data.invoicesData = [];
                vm.$data.addExpensesData = [];
                vm.$data.totalPrice = 0;
                vm.$data.viewExpensesData = [];
                var emaillist = vm.$data.options;
                $(emaillist).each(function (i, val) {
                    if (val.value >= 1) {
                        $.ajax({
                            url: "/expense/getList?eid=" + val.value,
                            type: "get",
                            contentType: "application/json",
                            async: false,
                            //返回数据的格式
                            datatype: "json",
                            success: function (data) {
                                for (var i = 0; i < data.length; i++) {
                                    if (data[i].status == "0") {
                                        var newExpensesData = {
                                            eid: data[i].eid,
                                            emailid: data[i].emailid,
                                            title: data[i].servicename,
                                            serviceurl: "https://logo.clearbit.com/" + data[i].serviceurl,
                                            checked: false,
                                            date: data[i].invoiceDate,
                                            price: data[i].cost,
                                            describe: data[i].mailSubject
                                        };
                                        vm.$data.newExpensesData.push(newExpensesData);
                                    }
                                    else {
                                        var addexpense = vm.$data.addExpensesData;
                                        var flag = false;
                                        for (var ad = 0; ad < addexpense.length; ad++) {
                                            if (addexpense[ad].title == data[i].servicename) {
                                                var num = addexpense[ad].number + 1;
                                                addexpense[ad].number = num;

                                                if (typeof(data[i].cost != undefined)) {
                                                    addexpense[ad].price = parseFloat(addexpense[ad].price) + parseFloat(data[i].cost);
                                                    addexpense[ad].price = addexpense[ad].price.toFixed(2);
                                                    vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(data[i].cost);
                                                }

                                                flag = true;
                                                break;
                                            }
                                        }

                                        if (flag == false) {
                                            var addobj = {
                                                title: data[i].servicename,
                                                serviceurl: "https://logo.clearbit.com/" + data[i].serviceurl,
                                                price: '' + data[i].cost,
                                                number: 1
                                            };
                                            if (typeof(data[i].cost != undefined)) {
                                                vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(data[i].cost);
                                            }
                                            vm.$data.addExpensesData.push(addobj);
                                        }
//                                        vm.$data.addExpensesData = addexpense;
                                        if (vm.$data.addExpensesData.length == 0) {
                                            var addobj = {
                                                title: data[i].servicename,
                                                serviceurl: "https://logo.clearbit.com/" + data[i].serviceurl,
                                                price: data[i].cost,
                                                number: 1
                                            };
                                            if (typeof(data[i].cost != undefined)) {
                                                vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(data[i].cost);
                                            }
                                            vm.$data.addExpensesData.push(addobj);
                                        }

                                        var invoicesData = {
                                            eid: data[i].eid,
                                            emailid: data[i].emailid,
                                            title: data[i].servicename,
                                            serviceurl: "https://logo.clearbit.com/" + data[i].serviceurl,
                                            checked: false,
                                            date: data[i].invoiceDate,
                                            price: data[i].cost,
                                            describe: data[i].mailSubject
                                        };
                                        vm.$data.invoicesData.push(invoicesData);
                                        vm.$data.viewExpensesData.push(invoicesData);
                                    }

                                }
                                var totalPriceInt = parseFloat(vm.$data.totalPrice).toFixed(2);
                                vm.$data.totalPrice = totalPriceInt;
                                vm.$nextTick(function () {
                                    InitPage();
                                });


                            },
                            error: function (e) {
                                vm.$message.error('error load expense');
                            }
                        });
                    }
                });
                vm.hideAppLoading();
                vm.initChangePage();
            },
            initChangePage: function () {
                vm.$nextTick(function () {
                    vm.$data.newTempExpensesData = vm.$data.newExpensesData;
                    vm.$data.newTempSearchExpensesData = vm.$data.newTempExpensesData;

                    vm.$data.addTempExpensesData = vm.$data.addExpensesData;
                    vm.$data.addTempSearchExpensesData = vm.$data.addTempExpensesData;

                    vm.$data.tempinvoicesData = vm.$data.invoicesData;
                    vm.$data.tempviewExpensesData = vm.$data.viewExpensesData;
                    vm.changePage();
                    vm.changeAddPage();
                    vm.changeInvoicePage();
                    vm.changeViewExpensesPage();
                });
            }, initChangePage2: function () {
                vm.$nextTick(function () {

                    vm.$data.addTempExpensesData = vm.$data.addExpensesData;
                    vm.$data.addTempSearchExpensesData = vm.$data.addTempExpensesData;

                    vm.$data.tempinvoicesData = vm.$data.invoicesData;
                    vm.$data.tempviewExpensesData = vm.$data.viewExpensesData;
                    vm.changePage();
                    vm.changeAddPage();
                    vm.changeInvoicePage();
                    vm.changeViewExpensesPage();
                });
            },
            changeMain: function (id, projectName, currency) {
                vm.$data.appLoading = true;
                $('#projecttitlespan').html(projectName);
                vm.$data.currentProjectId = id;
                vm.loadEmail();
                vm.$data.appLoading = false;
            },
            mailchange: function () {
                vm.$nextTick(function () {
                    if (vm.$data.gmailvalue == 0) {
                        //TODO
                        var url = "https://accounts.google.com/o/oauth2/auth?" +
                            "scope=https://www.googleapis.com/auth/gmail.readonly%20https://www.googleapis.com/auth/userinfo.email%20https://www.googleapis.com/auth/userinfo.profile" +
                            "&redirect_uri=http://test.yuewei.site/google/oauth2callback&response_type=code" +
                            "&client_id=319757543751-bj4lvlrthqal00u80r3dqfqm0i61f5g1.apps.googleusercontent.com" +
                            "&prompt=consent&access_type=offline" +
//                            "&prompt=consent&access_type=offline" +
                            "&state=" + vm.$data.currentProjectId;
                        window.open(url, '', 'height=500,width=611,scrollbars=yes,status =yes')
                    }
                });

            },
            editProject: function (id, projectName, currency) {
                vm.$data.currencyvalue = currency;
                vm.$data.inputProjectId = id;
                vm.$data.inputProjectName = projectName;
                $('#modal-edit-project').modal('show');

                vm.$forceUpdate();


            },
            editSaveProject: function () {
                var saveData = {
                    "pid": this.inputProjectId,
                    "projectname": this.inputProjectName,
                    "currency": this.currencyvalue
                };
                $.ajax({
                    url: "/project/update",
                    type: "post",
                    contentType: "application/json",
                    //提交的数据
                    data: JSON.stringify(saveData),
                    //返回数据的格式
                    datatype: "json",
                    success: function (data) {
                        $('#modal-edit-project').modal('hide');
                        vm.loadProject();
                    },
                    error: function (e) {
                        console.log("project save error.." + e);
                    }
                });
            },
            addExpensesClose: function (event) {
                this.loading = false;
            },

            saveProject: function () {
                var saveData = {"projectname": this.inputProjectName, "currency": this.currencyvalue};
                $.ajax({
                    url: "/project/add",
                    type: "post",
                    contentType: "application/json",
                    //提交的数据
                    data: JSON.stringify(saveData),
                    //返回数据的格式
                    datatype: "json",
                    success: function (result) {
                        var data = result.data;
                        $('#modal-new-project').modal('hide');
                        var obj = {projectid: data.pid, title: data.projectname, currency: data.currency};
                        vm.$data.tableData.push(obj);
                        $('#projecttitlespan').html(data.projectname);
                        vm.$data.currentProjectId = data.pid;
                        $('.contents').css('display', 'block');
                        $('.top-area').css('display', 'block');
                    },
                    error: function (e) {
                        console.log("project save error.." + e);
                    }
                });
            },
            addExpensesClose: function (event) {
                this.loading = false;
            }
        }
    };
    //    var app= new Vue({
    //    	el:'#app',
    //		data:Main
    //	})
    var Ctor = Vue.extend(Main)
    //init the vue component.

    var vm = new Ctor().$mount('#app')
    vm.loadProject();
    /**
     * search function
     */
    vm.$watch('inputSearch', function (val) {
        var newExp = vm.$data.newTempSearchExpensesData;
        vm.$data.newExpensesData = [];
        var newEx = [];
        for (var ad = 0; ad < newExp.length; ad++) {
            if (newExp[ad].title.toLowerCase().indexOf(val.toLowerCase()) > -1 || val == "" || val == null) {
                newEx.push(newExp[ad]);
            }
        }

        var addExp = vm.$data.tempinvoicesData;
        vm.$data.addExpensesData = [];
        var addEx = [];
        vm.$data.totalPrice = 0;
        for (var ad = 0; ad < addExp.length; ad++) {
            if (addExp[ad].title.toLowerCase().indexOf(val.toLowerCase()) > -1 || val == "" || val == null) {
//                addEx.push(addExp[ad]);
                var flag = false;
                var addexpense = vm.$data.addExpensesData;
                for (var adc = 0; adc < addexpense.length; adc++) {

                    if (addexpense[adc].title == addExp[ad].title) {
                        var num = addexpense[adc].number + 1;
                        addexpense[adc].number = num;
                        if (typeof(addExp[ad].price != undefined)) {
                            addexpense[adc].price = parseFloat(addexpense[adc].price) + parseFloat(addExp[ad].price);
                            addexpense[adc].price = addexpense[adc].price.toFixed(2);
                            vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(addExp[ad].price);
                        }
                        flag = true;
                        break;
                    }


                }
                vm.$data.addExpensesData = addexpense;
                if (flag == false) {

                    var addobj = {
                        title: addExp[ad].title,
                        serviceurl: addExp[ad].serviceurl,
                        price: '' + addExp[ad].price,
                        number: 1
                    };
                    if (typeof(addExp[ad].price != undefined)) {
                        vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(addExp[ad].price);
                    }
                    vm.$data.addExpensesData.push(addobj);
                }
                if (vm.$data.addExpensesData.length == 0) {
                    var addobj = {
                        title: addExp[ad].title,
                        serviceurl: addExp[ad].serviceurl,
                        price: addExp[ad].price,
                        number: 1
                    };
                    if (typeof(addExp[ad].price != undefined)) {
                        vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(addExp[ad].price);
                    }
                    vm.$data.addExpensesData.push(addobj);
                }


            }
        }

        vm.$data.newExpensesData = newEx;
        vm.$data.newTempExpensesData = vm.$data.newExpensesData;
        vm.changePage();

        vm.$data.addTempExpensesData = vm.$data.addExpensesData;
        vm.changeAddPage();
        vm.$nextTick(function () {
            InitPage();
        });
    })
    /**
     * data change function
     */
    vm.$watch('valueDataPicker', function (val) {

        var startDate = val[0];
        var endDate = val[1];
        var t1 = new Date(val[0]);
        var t2 = new Date(val[1]);
        var newExp = vm.$data.newTempSearchExpensesData;
        vm.$data.newExpensesData = [];
        var newEx = [];
        for (var ad = 0; ad < newExp.length; ad++) {
            if ((newExp[ad].date >= t1.getTime() && newExp[ad].date <= t2.getTime()) || val[0] == null || val[1] == null) {
                newEx.push(newExp[ad]);
            }
        }
        //TODO
        var addExp = vm.$data.tempinvoicesData;
        vm.$data.addExpensesData = [];
        var addEx = [];
        vm.$data.totalPrice = 0;
        for (var adnum = 0; adnum < addExp.length; adnum++) {
//            console.dir(addExp[ad].date);
//            if (addExp[ad].date>=t1.getTime()&& addExp[ad].date<=t2.getTime()||val[0]==null||val[1]==null) {
//                addEx.push(addExp[ad]);
//                vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(addExp[ad].price);
//            }
            var flag = false;
            var addexpense = vm.$data.addExpensesData;
            for (var ad = 0; ad < addexpense.length; ad++) {

                if (addExp[adnum].date >= t1.getTime() && addExp[adnum].date <= t2.getTime() || val[0] == null || val[1] == null) {

                    if (addexpense[ad].title == addExp[adnum].title) {
                        var num = addexpense[ad].number + 1;
                        addexpense[ad].number = num;
                        if (typeof(addExp[adnum].price != undefined)) {
                            addexpense[ad].price = parseFloat(addexpense[ad].price) + parseFloat(addExp[adnum].price);
                            addexpense[ad].price = addexpense[ad].price.toFixed(2);
                            vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(addExp[adnum].price);
                        }
                        flag = true;
                        break;
                    }
                }

            }
            vm.$data.addExpensesData = addexpense;
            if (flag == false && ((addExp[adnum].date >= t1.getTime() && addExp[adnum].date <= t2.getTime()) || val[0] == null || val[1] == null )) {

                var addobj = {
                    title: addExp[adnum].title,
                    serviceurl: addExp[adnum].serviceurl,
                    price: '' + addExp[adnum].price,
                    number: 1
                };
                if (typeof(addExp[adnum].price != undefined)) {
                    vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(addExp[adnum].price);
                }
                vm.$data.addExpensesData.push(addobj);
            }
            if (vm.$data.addExpensesData.length == 0 && ((addExp[adnum].date >= t1.getTime() && addExp[adnum].date <= t2.getTime()) || val[0] == null || val[1] == null )) {
                var addobj = {
                    title: addExp[adnum].title,
                    serviceurl: addExp[adnum].serviceurl,
                    price: addExp[adnum].price,
                    number: 1
                };
                if (typeof(addExp[adnum].price != undefined)) {
                    vm.$data.totalPrice = parseFloat(vm.$data.totalPrice) + parseFloat(addExp[adnum].price);
                }
                vm.$data.addExpensesData.push(addobj);
            }
        }


        vm.$data.newExpensesData = newEx;
        vm.$data.newTempExpensesData = vm.$data.newExpensesData;
        vm.changePage();

        vm.$data.addTempExpensesData = vm.$data.addExpensesData;
        vm.changeAddPage();
        vm.$nextTick(function () {
            InitPage();
        });
    })
    Vue.filter('time', function (value) {
        var newDate = new Date();
        newDate.setTime(value);
        return newDate.toDateString();
    })
</script>
<%--<script src="js/script.js"></script>--%>
</html>