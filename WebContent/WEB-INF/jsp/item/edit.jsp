<%@page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@include file="../include/taglibs.jsp" %>
<!doctype html>
<html>
    <c:import url="../include/head.jsp">
        <c:param name="title" value="Edit object" />
        <c:param name="content">
            <style>
                .titleLangName{
                    width:70px;
                }
                .titleMap{
                    width:60%;
                }
                #titleTable button{
                    width:30%;
                }
            </style>
            <link rel="stylesheet" type="text/css" media="screen" href="<c:url value='/js/mediaelement/mediaelementplayer.min.css' />" />
            <script src="<c:url value='/js/mediaelement/mediaelement-and-player.min.js' />"></script>
            <script src="http://www.google.com/jsapi"></script>
            <script src="http://maps.google.com/maps/api/js?sensor=true"></script>
            <script src="<c:url value='/js/LLMap.js' />"></script>
            <script>
                $(function(){
                    $("video, audio").mediaelementplayer();
                });
            </script>
            <script>
                function translateTitle(code){
                    var translateTitleUri = "<c:url value='/api/translate/itemTitle' />";
                    var titles = "{";
                    $.each($(".titleMap"),function(i, item){
                        titles+=$(item).attr("lang")+":\""+$(item).val()+"\"";
                        if(i<$(".titleMap").length-1)titles+=",";
                    });
                    titles+="}";
                    var inputdata={ 'target':code, 'titles': titles};
                    $.get(translateTitleUri,inputdata ,function(data){
                        $("#inputTitle_"+code).val(data);
                    });
                }
                
                function addLangTitle(){
                    var code = $("#addLangSelect").val();
                    var name = $("#addLangSelect").find("option:selected").text();
                    $("<tr><td class=\"titleLangName\">"+name+"</td><td><input name=\"titleMap['"+code+"']\" id=\"inputTitle_"+code+"\" class=\"titleMap\" lang=\""+code+"\" />&nbsp;<button onclick=\"translateTitle('"+code+"');return false;\">Translate</button></td></tr>").appendTo($("#titleTable"));
                    $("#addLangSelect option[value='"+code+"']").remove();
                }
                
                var map;
                $(function(){
                	<c:choose>
                	<c:when test="${(empty item.itemLng) || (empty item.itemLat) || (empty item.itemZoom)}">
                    map = new LLMap("map", {
                        onchange:function(lat, lng, zoom){
                            $("#itemLat").val(lat);
                            $("#itemLng").val(lng);
                            $("#itemZoom").val(zoom);
                        }
                    });
                    </c:when>
                    <c:otherwise>
                    map = new LLMap("map", {
                    	lat: ${item.itemLat},
                    	lng: ${item.itemLng},
                    	zoom: ${item.itemZoom},
                        onchange:function(lat, lng, zoom){
                            $("#itemLat").val(lat);
                            $("#itemLng").val(lng);
                            $("#itemZoom").val(zoom);
                        }
                    });
                    </c:otherwise>
                    </c:choose>
                    
                    $("#generateQrcode").click(function(){
                        if($("#qrcode").val()!=""){
                            if(!confirm("Generate a new QR code?")){
                                return;
                            }
                        }
                        $.get("<c:url value="/api/qrcode/generate" />", function(data){
                            $("#qrcode").val(data);
                            $("#qrcodeArea").html("<img src=\"http://chart.apis.google.com/chart?cht=qr&chs=120x120&chl=learninglog://item?qrcode="+data+"\"/>");
                        });
                        return false;
                    });
                    $("#clearQrcode").click(function(){
                        $("#qrcode").val("");
                        $("#qrcodeArea").html("");
                       });
                    $("#printQrcode").click(function(){
                        $.get("<c:url value="/api/qrcode/generate" />", function(data){
                            $("#qrcode").val(data);
                            $("#qrcodeArea").html("<img src=\"http://chart.apis.google.com/chart?cht=qr&chs=120x120&chl=learninglog://item?qrcode="+data+"\"/>");
                            window.open("<c:url value='/qrcodeprint?content=' />"+$("#qrcode").val(),"", "height=170, width=170" );
                        });
                    });
                    $("#qrcode").change(function(){
                        if($.trim($("#qrcode").val())==""){
                            $("#qrcodeArea").html("");
                            return;
                        }
                        $("#qrcodeArea").html("<img src=\"http://chart.apis.google.com/chart?cht=qr&chs=120x120&chl=learninglog://item?qrcode="+$("#qrcode").val()+"\"/>");
                    });
                });
            </script>
        </c:param>
    </c:import>
    <body id="page_member_profile">
        <div id="Body">
            <div id="Container">
                <c:import url="../include/header.jsp" />
                <div id="Contents">
                    <div id="ContentsContainer">
                        <div id="localNav">
                        </div><!-- localNav -->
                        <div id="LayoutD" class="Layout">
                            <div id="Top">
                            </div><!-- Top -->
                            <div id="Left">
                                <div id="memberImageBox_30" class="parts memberImageBox" style="text-align:center">
                                <c:choose>
                                    <c:when test="${fileType eq 'image'}">
                                        <p class="photo">
                                            <a id="itemImage" class="zoom" href="#itemImageZoom">
                                               <img alt="" src="<tags:static filename="${item.image}_320x240.png" />" width="240px" />
                                            </a>
                                        </p>
                                        <p class="text"></p>
                                        <div class="moreInfo">
                                        </div>
                                    </c:when>
                                    <c:when test="${fileType eq 'video'}">
                                   
                                        <video id="itemvideo" class="video"
                                            width="240px" controls preload="auto"
                                            poster="<tags:static filename="${item.image}_320x240.png" />"
                                            style="background-color:black"
                                            onclick="this.play();">
                                            <source src="<tags:static filename="${item.image}_320x240.mp4" />"></source>
                                        </video>
                                    </c:when>
                                    <c:when test="${fileType eq 'audio'}">
                                            <audio controls style="width:240px">
                                                <source src="<tags:static filename="${item.image}.mp3" />"></source>
                                            </audio>
                                    </c:when>
                                    <c:when test="${fileType eq 'pdf'}">
                                        <p class="photo">
                                            <a id="itemImage" href="<tags:static filename="${item.image}.pdf" />">
                                               <img alt="" src="<tags:static filename="${item.image}_320x240.png" />" width="240px" />
                                            </a>
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="photo">
                                            <img width="240px" alt="" src="<c:url value="/images/no_image.gif" />" />
                                        </p>
                                    </c:otherwise>
                                </c:choose>
                                </div><!-- parts -->
                            </div><!-- Left -->
                            <c:url value="/item/${item.id}/edit" var="itemresource" />
                            <form:form commandName="form"  action="${itemresource}" method="post">
                                <div id="Center">
                                    <div id="profile" class="dparts listBox">
                                        <div class="parts">
                                            <div class="partsHeading">
                                                <h3>Edit Information</h3>
                                            </div>
                                            <strong>*</strong> Required.
                                            <c:url value="/item/${item.id}" var="itemUrl" />
                                            <table>
                                                   <tr>
                                                    <th><label for="setting">Setting</label></th>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td style="width:80px;">Share Level</td>
                                                                <td style="width:80px;">
                                                                    <form:select path="shareLevel">
                                                                        <form:option value="0" label="Public" />
                                                                        <form:option value="1" label="Private" />
                                                                    </form:select>
                                                                </td>
                                                                  <td style="width:60px;">Category</td>
                                                                <td>
                                                                    <c:choose>
                                                            <c:when test="${empty myCategoryList}">
                                                                <a href="<c:url value="/mysetting" />" target="_blank">Please set your categories in Setting.</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form:select path="categoryId">
                                                                    <form:option value="" label="Select" />
                                                                    <c:forEach items="${myCategoryList}" var="cat">
                                                                      <form:option value="${cat.id}" label="${cat.name}" />
                                                                    </c:forEach>                                                            
                                                                </form:select>
                                                            </c:otherwise>
                                                        </c:choose>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><label for="quiztype">Options</label></th>
                                                    <td>
                                                        <c:forEach items="${questionTypes}" var="qestype">
                                                            <form:checkbox path="questionTypeIds" value="${qestype.id}" />&nbsp;${qestype.title}&nbsp;&nbsp;
                                                        </c:forEach>   
                                                        <form:checkbox path="locationBased" />&nbsp;Location Based&nbsp;&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th style="width: 120px">Title</th>
                                                    <td>
                                                        <table id="titleTable">
                                                            <c:forEach items="${langs}" var="lang">
                                                                <tr>
                                                                    <td class="titleLangName">${lang.name}</td>
                                                                    <td>
                                                                        <form:input path="titleMap['${lang.code}']" id="inputTitle_${lang.code}" cssClass="titleMap" lang="${lang.code}" />&nbsp;<button onclick="translateTitle('${lang.code}');return false;" >Translate</button>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </table>
                                                        <div>
                                                            <select id="addLangSelect">
                                                                <c:forEach items="${langList}" var="lang">
                                                                <c:if test="${!langs.contains(lang)}"><option id="addLang_${lang.code}" value="${lang.code}">${lang.name}</option></c:if>
                                                                </c:forEach>
                                                            </select>
                                                            <button onclick="addLangTitle();return false;">Add</button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Description</th>
                                                    <td><form:textarea path="note" cols="20" rows="4" cssStyle="width:98%"/></td>
                                                </tr>
                                                <tr>
                                                    <th><label for="tag1">ID</label></th>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td style="width:70px;">Barcode</td>
                                                                <td><form:input path="barcode" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td>QR Code</td>
                                                                <td>
                                                                    <form:input path="qrcode" id="qrcode" />
                                                                     <button id="printQrcode" onclick="return false;">Print</button>
                                                                    <button id="clearQrcode" onclick="return false;">Clear</button>
                                                                    <div id="qrcodeArea"></div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>RFID</td>
                                                                <td><form:input path="rfid" /></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th rowspan="2">Place</th>
                                                    <td>
                                                        <form:input path="place" cssClass="input_text" id="place" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <form:hidden path="itemLat" id="itemLat"/>
                                                        <form:hidden path="itemLng" id="itemLng"/>
                                                        <form:hidden path="itemZoom" id="itemZoom"/>
                                                        <div id="map" style="width: 300px; height: 300px">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><label for="question">Question</label></th>
                                                    <td>
                                                       <form:textarea path="question" cssStyle="width:98%;height:50px;" />
                                                       Ask: <form:select path="quesLan" items="${langList}" itemValue="code" itemLabel="name" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="operation">
                                            <ul class="moreInfo button">
                                                <li>
                                                    <input type="submit" class="input_submit" value="Edit" />
                                                </li>
                                                <li>
                                                    <a href="<c:url value="/item/${item.id}" />">Return to Object List</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div><!-- dparts -->
                                </div>
                            </form:form>
                        </div><!-- Layout -->
                        <div class="block">
                        </div>
                        <div id="sideBanner">
                        </div><!-- sideBanner -->

                    </div><!-- ContentsContainer -->
                </div><!-- Contents -->
                <c:import url="../include/footer.jsp" />
            </div><!-- Container -->
        </div><!-- Body -->
    </body>
</html>
