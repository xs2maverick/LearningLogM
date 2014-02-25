<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title><c:if test="${!empty param.title}">${param.title} - </c:if>Learning Log</title>
    <link rel="icon" type="image/png" href="<c:url value="/images/favicon.png" />">
    <link rel="stylesheet" type="text/css" media="screen" href="${ctx}/css/main.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="${ctx}/css/learninglog/jquery-ui.css" />
    <!--[if lt IE 9]><script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.10.0/jquery.validate.min.js"></script>
    <script type="text/javascript" src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.10.0/additional-methods.min.js"></script>
    <script type="text/javascript" src="${ctx}/js/jquery/jquery.contextMenu.js"></script>
    <script type="text/javascript" src="${ctx}/js/jquery/jquery.form.js"></script>
    <script type="text/javascript">
    <c:url value="/usermessage/send" var="usermessagesenduri"/>
    <c:url value="/usermessage/checkmessage" var="checkmessageuri" />
        function refreshUnreadMsg(){
           $.get("${checkmessageuri}", function(e){
                if(e!="" && e>0){
                    $("#msgUnreadCount").text("("+e+")");
                }else{
                    $("#msgUnreadCount").text("");
                }
            });
        }
        function sendUserMessage(){
            var umsg_sendto=$("#umsg_sendto").val();
            var umsg_content=$("#umsg_content").val();
            $.post("${usermessagesenduri}",{"umsg_sendto":umsg_sendto, "content":umsg_content},function(e){
                $("#usermsgdlg").dialog("destroy").remove();
            });
        }
        $(function(){
            $(".userlink").contextMenu('context-menu-1', {
                'Search by author': {
                    click: function(element) { 
                        window.location = $(element).attr("href");
                    }
                },
                'Send message': {
                    click: function(element){
                        $("<div id=\"usermsgdlg\">"
                        +"<div><form id=\"usermessageform\" action=\"#\" method=\"post\">"
                        +"<input id=\"umsg_sendto\" name=\"umsg_sendto\" type=\"hidden\" value=\""+$(element).attr("data-uid")+"\" />"
                        +"<textarea id=\"umsg_content\" name=\"content\" style=\"width:100%;height:100%;\" rows=\"5\"></textarea>"
                        +"<input type=\"submit\" value=\"Send\" onclick=\"sendUserMessage();return false;\" />"
                        +"</form></div>"
                        +"</div>").dialog({
                            title:"Send A Message To <span style=\"color:green\">"+$(element).attr("data-uname")+"</span>", 
                            modal:true, 
                            resizable:false});
                        $("#usermessageform").ajaxForm({
                            forceSync:true,
                            success:function(){
                            $("#usermsgdlg").dialog("destroy").remove();
                            }
                        });
                    }
                }
            }, {leftClick:true});
            <shiro:user>
            refreshUnreadMsg();
            setInterval( "refreshUnreadMsg()",30000);
            </shiro:user>
        });
    </script>
<c:out value="${param.css}" escapeXml="false" />
<c:out value="${param.javascript}" escapeXml="false" />
<c:out value="${param.content}" escapeXml="false" />
</head>