<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//이전 페이지에서 넘어온 메시지가 있으면 저장
	String msg = "";
	if(request.getParameter("msg") != null
	&& !request.getParameter("msg").equals("")){
		msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Add Local</title>
	<link href="../style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<form class="insert_form" action="<%=request.getContextPath()%>/board/insertLocalAction.jsp" method="post">
			<div class="title">지역추가</div>
			<table>
				<tr>
					<td colspan="2"><div class="error"><%=msg %></div></td>
				</tr>
				<tr>
					<th>지역이름</th>
					<td><input type="text" name="localName"></td>
				</tr>
			</table>
			<button type="submit">지역추가</button>
		</form>
	</div>
</body>
</html>