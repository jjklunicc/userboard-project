<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div>
	<div class="main-logo">
		<img src="<%=request.getContextPath()%>/lock.png">
		<h1>방탈출 후기 게시판</h1>
	</div>
	<ul class="main_container">
		<li class="main_menu"><a href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
	
		<!-- 
			로그인 전 : 회원가입
			로그인 후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId
		 -->
		 
		 <%
		 	//로그인 전
		 	if(session.getAttribute("loginMemberId") == null){
		 %>
		 		<li class="main_menu"><a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
		 <%
		 	}else{ //로그인 후
		 %>
		 		<li class="main_menu"><a href="<%=request.getContextPath()%>/member/updateMemberForm.jsp">회원정보</a></li>
		 		<li class="main_menu"><a href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
		 		<li class="main_menu"><a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">게시물 작성</a></li>
		 <%
		 	}
		 %>
	</ul>
</div>