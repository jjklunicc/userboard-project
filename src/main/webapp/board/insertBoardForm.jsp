<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	//다른 페이지에서 넘어온 메시지 있으면 저장
	String msg = "";
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	//로그인 안되어 있으면 home으로 redirection
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	//로그인 아이디 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	//아이디 확인
	System.out.println("insertBoardForm loginMemberId : " + loginMemberId);
	
	//세션에 저장된 localList불러옴
	Object o = session.getAttribute("localList");
	List<?> list = new ArrayList<>();
	if(o instanceof Collection){
		list = new ArrayList<>((Collection<?>)o);
	}
	ArrayList<String> localList = new ArrayList<String>();
	for(int i = 0; i < list.size(); i++){
		localList.add(list.get(i).toString());
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert Board</title>
	<link href="../style.css" type="text/css" rel="stylesheet">
</head>
<body>
<div class="container">
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<form class="insert_form" action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
			<div class="title">게시물 작성</div>
			<!-- board one 결과 -->
			<table>
				<tr>
					<td colspan="2"><div class="error"><%=msg %></div></td>
				</tr>
				<tr>
					<th>지역이름</th>
					<td>
						<select name="localName">
							<option value="">지역선택</option>
							<%
								for(String local : localList){
							%>
								<option><%=local %></option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="boardTitle"></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea rows="7" name="boardContent"></textarea></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><input type="text" value="<%=loginMemberId%>" name="loginMemberId" readonly></td>
				</tr>
			</table>
			<button type="submit">작성완료</button>
		</form>
	</div>
</body>
</html>