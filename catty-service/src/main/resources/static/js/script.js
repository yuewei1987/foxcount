// 对Date的扩展，将 Date 转化为指定格式的String
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
// 例子：
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18
Date.prototype.Format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
$(document).ready(function(){
    InitPage();
    var maxh = $(window).height();
    $(".el-table__body-wrapper").height(maxh-245);
})
function InitPage() {
    //click Checkbox options
    $(".btn-checkboxs").click(function(){
        if($(this).hasClass("check-off"))
        {
            $(this).addClass("check-on").removeClass("check-off")
        }
        else
        {
            $(this).addClass("check-off").removeClass("check-on")
        }
    });

    //click dropdown options
    $(".dropdown-default .dropdown-menu li a").click(function(){
        $(this).parents(".dropdown-default").find(".selected-option").html($(this).html());
        $(this).parents(".dropdown-default").removeClass("field-error");
    });

    //click "Create" button in modal window of Create Project
    //click "Submit" button in modal window of Edit Project
    $("#modal-new-project .btn-create-project,\
     #modal-edit-project .btn-submit-project").click(function(){
        var modal_window = $(this).parents(".modal-default");
        var pass = true;

        if(modal_window.find(".project-name-input").find("input").val() === "")
        {
            pass = false;
            modal_window.find(".project-name-input").addClass("field-error");
        }
        else
        {
            modal_window.find(".project-name-input").removeClass("field-error");
        }

        if(pass)
        {
            $(this).html("Please wait...");
        }
    })

    //click "Update" button in 2 modal window of Edit Service
    $("#modal-edit-expenses .btn-update-expense,\
     #modal-edit-added-expenses .btn-update-expense").click(function(){
        var modal_window = $(this).parents(".modal-default");
        var pass = true;

        if(modal_window.find(".service-name-input").find("input").val() === "")
        {
            pass = false;
            modal_window.find(".service-name-input").addClass("field-error");
        }
        else
        {
            modal_window.find(".service-name-input").removeClass("field-error");
        }

        if(modal_window.find(".cost-input").length > 0)
        {
            if(modal_window.find(".cost-input").find("input").val() === "")
            {
                pass = false;
                modal_window.find(".cost-input").addClass("field-error");
            }
            else
            {
                modal_window.find(".cost-input").removeClass("field-error");
            }
        }

        if(pass)
        {
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
    $(".modal-default input[type='text']").focus(function(){
        $(this).removeClass("field-error");
    })

    //click to show Projects List sidebar
    $(".link-projects").click(function () {
        $(".aside").addClass("hide");
        $(".aside.projects").removeClass("hide");
    })
    $(".link-logout").click(function () {
        vm.logout();
    })
    //click to show View expenses sidebar
    $(".link-view-expenses").click(function(){
        $(".aside").addClass("hide");

        $(".aside.view-expense").removeClass("hide");
    })

    //click to show Add and edit expenses sidebar
    $(".link-add-expenses").click(function(){

    })

    //click News tab in Add and edit expenses sidebar
    $(".aside.expenses .new-nav-item").click(function(){
        $(".aside.expenses .new-nav-item").addClass("active");
        $(".aside.expenses .added-nav-item").removeClass("active");

        $(".aside.expenses .news-expenses").removeClass("hide");
        $(".aside.expenses .added-expenses").addClass("hide");
    })

    //click Added tab in Add and edit expenses sidebar
    $(".aside.expenses .added-nav-item").click(function(){
        $(".aside.expenses .new-nav-item").removeClass("active");
        $(".aside.expenses .added-nav-item").addClass("active");

        $(".aside.expenses .news-expenses").addClass("hide");
        $(".aside.expenses .added-expenses").removeClass("hide");
    })

    //click items in Added tab in Add and edit expenses sidebar
    $(".link-edit-webflow").click(function(){
        $(".aside.edit-aside").removeClass("hide");
    })

    //click Edit icon of Add and edit expenses sidebar
    $(".open-modal-edit-added-expenses").click(function(event){
        $("#modal-edit-added-expenses").modal('show');
    })

    //click Delete icon of Add and edit expenses sidebar
    $(".open-modal-delete-expenses").click(function(event){
        event.stopPropagation();
        $('#modal-delete-expenses').modal('show');
    })

    //click items in View expenses sidebar
    $(".link-view-webflow").click(function(){
        $(".aside.expense-detail").removeClass("hide");
    })

    //click X icon in right sidebar
    $(".aside .btn-icon-close").click(function(){
        $(this).parents(".aside").addClass("hide");
    })

    //when open Edit Service modal window,cover the right sidebar
    $('#modal-edit-expenses').on('shown.bs.modal', function (e) {
        $(".edit-aside").css("z-index","1000");
        $("#modal-edit-added-expenses").modal("hide");
    })

    //when close Edit Service modal window,reset the z-index of right sidebar
    $('#modal-edit-expenses').on('hidden.bs.modal', function (e) {
        $(".edit-aside").css("z-index","10000");
    })
}
//check URL format
function checkURL(str_url){
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

    var re=new RegExp(strRegex);
    //re.test()

    if (re.test(str_url)){
        return (true);
    }else{
        return (false);
    }
}


//element-ui script code
var Main = {
    data() {
        return {
            mail_subject: "",
            target: "",
            mail_content: "",
            valueDataPicker: "",
            inputSearch: "",
            inputAddSearch: "",
            valueSwitch: true,
            appLoading: true,
            inputProjectId: 0,
            inputProjectName: "",
            percentageValue: 0,
            currentProjectId: 0,
            inputEid: 0,
            delCatagory: "",
            delEid: 0,
            inputService: "",
            inputServiceName: "",
            inputCost: 0,
            show:false,
            loading: false,
            options: [{
                value: 0.5,
                label: ' ',
                icon: false,
                token: ''
            },{
                value: 0,
                label: 'Add Gmail',
                icon: true,
                token: ''
            }],
            currencyOptions: [{
                value: '1',
                label: 'USD'
            },{
                value: '2',
                label: 'CAD'
            },{
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
            newExpensesDataPageSize:6,
            newExpensesDataPageNum: 1,
            addExpensesData: [],
            addTempExpensesData: [],
            addTempSearchExpensesData: [],
            addExpensesDataPageSize: 6,
            addExpensesDataPageNum: 1,
            invoicesData: [],
            tempinvoicesData: [],
            invoicesDataPageSize: 5,
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
            var addExpensesData4 =[];
            var newAddExpensesData = [];
            var servicename = vm.$data.currentAdd.servicename;
            if(servicename != null &&servicename!=""&&typeof(servicename)!="undefined"){
                addExpensesData4=  addExpensesData3.filter(function (invoicesData) {
                    return (invoicesData.title == servicename)
                });
                for (var i = 0; i < pagesize; i++) {
                    if (typeof(addExpensesData4[(page - 1) * pagesize + i]) == "undefined") {
                        break;
                    }
                    newAddExpensesData.push(addExpensesData4[(page - 1) * pagesize + i]);
                }
                vm.$data.invoicesData = newAddExpensesData;
            }else{
                for (var i = 0; i < pagesize; i++) {
                    if (typeof(addExpensesData3[(page - 1) * pagesize + i]) == "undefined") {
                        break;
                    }
                    newAddExpensesData.push(addExpensesData3[(page - 1) * pagesize + i]);
                }
                vm.$data.invoicesData = newAddExpensesData;
            }



        }, changeViewExpensesPage: function () {

            var page = vm.$data.viewExpensesPageNum;
            var pagesize = vm.$data.viewExpensesPageSize;
            var addExpensesData4 = vm.$data.tempviewExpensesData;
            var addExpensesData5 = [];
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
            $('#modal-delete-expenses').modal('show');
            vm.$data.delEid = obj.eid;

        }, delInvoice: function () {
            var saveData = {};
            if (vm.$data.delEid == "") {
                saveData = {
                    "servicename": vm.$data.delCatagory,
                    "status":"1"
                };
                for (var newnum = 0; newnum < vm.$data.addExpensesData.length; newnum++) {
                    if (vm.$data.addExpensesData[newnum].title == vm.$data.delCatagory) {
                        vm.$data.addExpensesData.splice(newnum, 1);
                        break;
                    }
                }

            } else {
                saveData = {
                    "eid": vm.$data.delEid
                };
                for (var newnum = 0; newnum < vm.$data.newExpensesData.length; newnum++) {
                    if (vm.$data.newExpensesData[newnum].eid == vm.$data.delEid) {
                        vm.$data.newExpensesData.splice(newnum, 1);
                        break;
                    }
                }
                for (var newnum = 0; newnum < vm.$data.newTempExpensesData.length; newnum++) {
                    if (vm.$data.newTempExpensesData[newnum].eid == vm.$data.delEid) {
                        vm.$data.newTempExpensesData.splice(newnum, 1);
                        break;
                    }
                }
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
            vm.changeInvoicePage();
        },
        editActiveInvoice: function (servicename, serviceurl) {
            vm.$data.currentAdd = {
                servicename: servicename,
                servicetype: serviceurl.slice(26),
                serviceurl: serviceurl
            };
            $("#modal-edit-added-expenses").modal('show');

            vm.changeInvoicePage();
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
        },
        addNewExpense: function (obj) {
            $('#modal-add-expenses').modal('show');
            vm.$data.mail_subject = obj.describe;
            vm.$data.target = obj.target;
            var mailcontent = decodeURIComponent(escape(atob(obj.mailContent.replace(/\-/g, '+').replace(/\_/g, '/'))));
            vm.$data.mail_content = mailcontent;
            vm.$data.inputService = obj.title;
            vm.$data.inputEid = obj.eid;
            vm.$data.inputCost = obj.price;
        }, updateNewExpense: function (obj) {

            vm.$data.inputService = obj.title;
            vm.$data.inputEid = obj.eid;
            vm.$data.inputCost = obj.price;
            $('#modal-edit-expenses').modal('show');

            $('#modal-edit-expenses').on('shown.bs.modal', function () {

                vm.$forceUpdate();
                setTimeout(function () {
                    vm.$forceUpdate();
                }, 1000);
            })

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
                    $('#modal-add-expenses').modal('hide');
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

        },loadProject:function() {
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
            if (eid == null || eid == "" || typeof(eid) == "undefined") {
                eid = vm.$data.inputEid;
            }
            vm.$data.loading = true;
            var saveData = {
                "eid": eid
            };

            // let it fast!
//                        vm.loadExpenses();
            vm.$data.invoicesData = vm.$data.tempinvoicesData;
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
            vm.$data.invoicesData.push(invoicesDataT);
            vm.$data.viewExpensesData.push(invoicesDataT);
            vm.initChangePage2();

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
            $(".gray-cover").addClass("hide");
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
                                        describe: data[i].mailSubject,
                                        target: data[i].target,
                                        mailContent: data[i].mailContent
                                    };
                                    if (vm.$data.gmailvalue == "" || vm.$data.gmailvalue == "0.5" || data[i].emailid == vm.$data.gmailvalue) {
                                        vm.$data.newExpensesData.push(newExpensesData);
                                    }

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
                                        describe: data[i].mailSubject,
                                        target: data[i].target,
                                        mailContent: data[i].mailContent
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
            vm.$data.percentageValue = 100;
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
        mailchange:function(){
            vm.$nextTick(function () {
                if (vm.$data.gmailvalue == 0) {
                    //TODO
                    var url = "https://accounts.google.com/o/oauth2/auth?" +
                        "scope=https://www.googleapis.com/auth/gmail.readonly%20https://www.googleapis.com/auth/userinfo.email%20https://www.googleapis.com/auth/userinfo.profile" +
                        "&redirect_uri=https://fast-hamlet-34558.herokuapp.com/google/oauth2callback&response_type=code" +
                        "&client_id=319757543751-bj4lvlrthqal00u80r3dqfqm0i61f5g1.apps.googleusercontent.com" +
                        "&prompt=consent&access_type=offline" +
//                            "&prompt=consent&access_type=offline" +
                        "&state=" + vm.$data.currentProjectId;
                    window.open(url, '', 'height=500,width=611,scrollbars=yes,status =yes')
                } else if (vm.$data.gmailvalue == "0.5") {
                    vm.$data.percentageValue = 0;
                    $(".gray-cover").removeClass("hide");

                    setInterval(function(){
                        if(vm.$data.percentageValue < 100 ){
                            vm.$data.percentageValue++;
                        }else{
                            $(".gray-cover").addClass("hide");
                        }
                    },200);
                    vm.loadExpenses();
                    vm.hideAppLoading();
                    vm.$data.percentageValue = 100;
                } else if (vm.$data.gmailvalue > 1) {
                    vm.$data.appLoading = true;
                    vm.$data.percentageValue = 0;
                    $(".gray-cover").removeClass("hide");
                    setInterval(function(){
                        if(vm.$data.percentageValue < 100 ){
                            vm.$data.percentageValue++;
                        }else{
                            $(".gray-cover").addClass("hide");
                        }
                    },200);
                    $.ajax({
                        url: "/google/import/importemailv2?pid=" + vm.$data.currentProjectId + "&eid=" + vm.$data.gmailvalue,
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
                            vm.$data.percentageValue = 100;
                        },
                        error: function (e) {
                            vm.$message.error("project load error..");
                        }
                    });
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
            var saveData={"pid":this.inputProjectId,"projectname":this.inputProjectName,"currency":this.currencyvalue};
            $.ajax({
                url:"/project/update",
                type:"post",
                contentType: "application/json",
                //提交的数据
                data:JSON.stringify(saveData),
                //返回数据的格式
                datatype: "json",
                success:function(data){
                    $('#modal-edit-project').modal('hide');
                    vm.loadProject();
                },
                error:function(e){
                    console.log("project save error.."+e);
                }
            });
        },
        addExpensesClose: function (event) {
            this.loading = false;
        },

        saveProject:function(){
            var saveData={"projectname":this.inputProjectName,"currency":this.currencyvalue};
            $.ajax({
                url:"/project/add",
                type:"post",
                contentType: "application/json",
                //提交的数据
                data:JSON.stringify(saveData),
                //返回数据的格式
                datatype: "json",
                success: function (result) {
                    var data = result.data;
                    $('#modal-new-project').modal('hide');
                    var obj = {projectid: data.pid, title: data.projectname, currency: data.currency};
                    vm.$data.tableData.push(obj);
                    vm.$data.currentProjectId = data.pid;
                    $('.contents').css('display', 'block');
                    $('.top-area').css('display', 'block');
                },
                error:function(e){
                    console.log("project save error.."+e);
                }
            });
        },
        addExpensesClose: function (event) {
            this.loading = false;
        },
        loadMoreRow: function (event) {
            vm.$data.percentageValue = 0;
            $(".gray-cover").removeClass("hide");
            setInterval(function(){
                if(vm.$data.percentageValue < 100 ){
                    vm.$data.percentageValue++;
                }else{
                    $(".gray-cover").addClass("hide");
                }
            },200);
            //import all email
            if (vm.$data.gmailvalue == "0.5" || vm.$data.gmailvalue == "") {
                vm.importEmail();
                //import
            } else if (vm.$data.gmailvalue > 1) {
                vm.$data.appLoading = true;
                $.ajax({
                    url: "/google/import/importemailv2?pid=" + vm.$data.currentProjectId + "&eid=" + vm.$data.gmailvalue,
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
                        vm.$data.percentageValue = 100;
                    },
                    error: function (e) {
                        vm.$message.error("project load error..");
                    }
                });
            }


        },
        handleCommand(command) {
            if (command == "edit")
                $('#modal-edit-expenses').modal();
            vm.$data.inputService = obj.title;
            vm.$data.inputEid = obj.eid;
            vm.$data.inputCost = obj.price;
            vm.$forceUpdate();
            if (command == "delete")
                $("#modal-delete-expenses").modal("show");
        }, showLoading: function () {
            $(".gray-cover").removeClass("hide");
            setInterval(function(){
                if(vm.$data.percentageValue < 100 ){
                    vm.$data.percentageValue++;
                }else{
                    $(".gray-cover").addClass("hide");
                }
            },200);
        },viewExpenseOpen:function(obj){
            $("#modal-info-bounced").modal("show");
            vm.$data.mail_subject = obj.describe;
            vm.$data.target = obj.target;
            var mailcontent = decodeURIComponent(escape(atob(obj.mailContent.replace(/\-/g, '+').replace(/\_/g, '/'))));
            vm.$data.mail_content = mailcontent;
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
    var totalPriceInt = parseFloat(vm.$data.totalPrice).toFixed(2);
    vm.$data.totalPrice = totalPriceInt;
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

    var totalPriceInt = parseFloat(vm.$data.totalPrice).toFixed(2);
    vm.$data.totalPrice = totalPriceInt;
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
    return newDate.Format("MM/dd/yyyy");
})
Vue.filter('comma', function (num) {
    if(num)
    {
        //将num中的$,去掉，将num变成一个纯粹的数据格式字符串
        num = num.toString().replace(/\$|\,/g,'');
        //如果num不是数字，则将num置0，并返回
        if(''==num || isNaN(num)){return 'Not a Number ! ';}
        //如果num是负数，则获取她的符号
        var sign = num.indexOf("-")> 0 ? '-' : '';
        //如果存在小数点，则获取数字的小数部分
        var cents = num.indexOf(".")> 0 ? num.substr(num.indexOf(".")) : '';
        cents = cents.length>1 ? cents : '' ;//注意：这里如果是使用change方法不断的调用，小数是输入不了的
        //获取数字的整数数部分
        num = num.indexOf(".")>0 ? num.substring(0,(num.indexOf("."))) : num ;
        //如果没有小数点，整数部分不能以0开头
        if('' == cents){ if(num.length>1 && '0' == num.substr(0,1)){return 'Not a Number ! ';}}
        //如果有小数点，且整数的部分的长度大于1，则整数部分不能以0开头
        else{if(num.length>1 && '0' == num.substr(0,1)){return 'Not a Number ! ';}}
        //针对整数部分进行格式化处理，这是此方法的核心，也是稍难理解的一个地方，逆向的来思考或者采用简单的事例来实现就容易多了
        /*
         也可以这样想象，现在有一串数字字符串在你面前，如果让你给他家千分位的逗号的话，你是怎么来思考和操作的?
         字符串长度为0/1/2/3时都不用添加
         字符串长度大于3的时候，从右往左数，有三位字符就加一个逗号，然后继续往前数，直到不到往前数少于三位字符为止
         */
        for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        {
            num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));
        }
        //将数据（符号、整数部分、小数部分）整体组合返回
        return (sign + num + cents);
    }
})
Vue.filter('comma2', function (num) {
    if(num)
    {
        //将num中的$,去掉，将num变成一个纯粹的数据格式字符串
        num = num.toString().replace(/\$|\,/g,'');
        //如果num不是数字，则将num置0，并返回
        if(''==num || isNaN(num)){return 'Not a Number ! ';}
        //如果num是负数，则获取她的符号
        var sign = num.indexOf("-")> 0 ? '-' : '';
        //如果存在小数点，则获取数字的小数部分
        var cents = num.indexOf(".")> 0 ? num.substr(num.indexOf(".")) : '';
        cents = cents.length>1 ? cents : '' ;//注意：这里如果是使用change方法不断的调用，小数是输入不了的
        //获取数字的整数数部分
        num = num.indexOf(".")>0 ? num.substring(0,(num.indexOf("."))) : num ;
        //如果没有小数点，整数部分不能以0开头
        if('' == cents){ if(num.length>1 && '0' == num.substr(0,1)){return 'Not a Number ! ';}}
        //如果有小数点，且整数的部分的长度大于1，则整数部分不能以0开头
        else{if(num.length>1 && '0' == num.substr(0,1)){return 'Not a Number ! ';}}
        //针对整数部分进行格式化处理，这是此方法的核心，也是稍难理解的一个地方，逆向的来思考或者采用简单的事例来实现就容易多了
        /*
         也可以这样想象，现在有一串数字字符串在你面前，如果让你给他家千分位的逗号的话，你是怎么来思考和操作的?
         字符串长度为0/1/2/3时都不用添加
         字符串长度大于3的时候，从右往左数，有三位字符就加一个逗号，然后继续往前数，直到不到往前数少于三位字符为止
         */
        for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        {
            num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));
        }
        //将数据（符号、整数部分、小数部分）整体组合返回
        return ("$"+sign + num + cents);
    }
})