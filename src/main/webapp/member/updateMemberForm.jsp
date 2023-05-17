<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%
	//세션 유효성 검사 - 로그인이 안되어있는 상태면 home으로
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//아이디값 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//이전 페이지로부터 메시지값 넘어온거 있으면 저장
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
	<title>User Information</title>
	<link href="../style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<form class="insert_form" action="<%=request.getContextPath()%>/member/updateMemberAction.jsp" method="post">
			<div class="title">회원정보</div>
			<table>
				<tr>
					<td colspan="2"><div class="error"><%=msg %></div></td>
				</tr>
				<tr>
					<th>아이디</th>
					<td><input type="text" name="memberId" value="<%=loginMemberId%>" readonly></td>
				</tr>
				<tr>
					<th>기존 비밀번호</th>
					<td><input type="password" name="memberPw"></td>
				</tr>
				<tr>
					<th>변경할 비밀번호</th>
					<td><input type="password" name="updatePw"></td>
				</tr>
			</table>
			<button type="submit">정보수정</button>
			<button type="submit" formaction="<%=request.getContextPath()%>/member/deleteMemberForm.jsp">회원탈퇴</button>
		</form>
	</div>
</body>
</html>