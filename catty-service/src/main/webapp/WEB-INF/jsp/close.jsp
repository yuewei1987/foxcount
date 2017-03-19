<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1,user-scalable=no,maximum-scale=1"/>
    <meta charset="UTF-8">
    <title>Hello</title>
    <script>
        window.opener.vm.loadEmail();
        window.opener.vm.$data.loading = true;
        setTimeout(function () {
            window.opener.vm.$data.loading = false;
            window.close();
        }, 1000);

    </script>
</head>
<body>

</body>
</html>