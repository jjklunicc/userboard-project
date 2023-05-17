<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//이전 페이지에서 넘어온 메시지가 있으면 저장
	String msg = "";
	if(request.getParameter("msg") != null
	&& !request.getParameter("msg").equals("")){
		msg = request.getParameter("msg");
	}
	
	//요청값 유효성 검사
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	//요청값 저장
	String localName = request.getParameter("localName");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Update Local</title>
	<link href="../style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<form class="insert_form" action="<%=request.getContextPath()%>/board/updateLocalAction.jsp" method="post">
			<div class="title">이름수정</div>
			<table>
				<tr>
					<td colspan="2"><div class="error"><%=msg %></div></td>
				</tr>
				<tr>
					<th>기존이름</th>
					<td><input type="text" name="originName" value="<%=localName%>" readonly></td>
				</tr>
				<tr>
					<th>변경할 이름</th>
					<td><input type="text" name="localName" value="<%=localName%>"></td>
				</tr>
			</table>
			<button type="submit">이름수정</button>
		</form>
	</div>
</body>
</html>