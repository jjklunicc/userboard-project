<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
	//세션 유효성 검사 - 로그인이 되어있는 상태면 home으로
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
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
	<title>Join</title>
	<link href="../style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<form class="insert_form" action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
			<div class="title">회원가입</div>
			<table>
				<tr>
					<td colspan="2"><div class="error"><%=msg %></div></td>
				</tr>
				<tr>
					<th>아이디</th>
					<td><input type="text" name="memberId"></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="memberPw"></td>
				</tr>
				<tr>
					<th>비밀번호확인</th>
					<td><input type="password" name="confirmPw" ></td>
				</tr>
			</table>
			<button type="submit">회원가입</button>
		</form>
	</div>
</body>
</html>