<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	//세션 유효성 검사 - 로그인이 안되어있는 상태면 home으로
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	//요청값 유효성 검사
	String msg = null;
	if(request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		msg = URLEncoder.encode("Id값이 비어있습니다.", "utf-8");
	}else if(request.getParameter("memberPw") == null
	|| request.getParameter("memberPw").equals("")){
		msg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8");
	}else if(request.getParameter("updatePw") == null
	|| request.getParameter("updatePw").equals("")){
		msg = URLEncoder.encode("변경할 비밀번호를 입력하세요.", "utf-8");
	}
	if(msg != null){
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + msg);
		return;
	}
	
	//요청값 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String updatePw = request.getParameter("updatePw");
	
	//요청값 디버깅
	System.out.println("updateMemberAction memberId : " + memberId);
	System.out.println("updateMemberAction memberPw : " + memberPw);
	System.out.println("updateMemberAction updatePw : " + updatePw);
	
	//DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//update쿼리
	String sql = "update member set member_pw = password(?) where member_id = ? and member_pw = password(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//?값 세팅
	stmt.setString(1, updatePw);
	stmt.setString(2, memberId);
	stmt.setString(3, memberPw);
	
	//쿼리 디버깅
	System.out.println("updateMemberAction query : " + stmt);
	
	//쿼리 실행, 영향받은 행 가져옴
	int row = stmt.executeUpdate();
	
	//결과값 디버깅
	System.out.println("updateMemberAction row : " + row);
	
	//기존 비밀번호가 틀린경우
	if(row == 0){
		String errMsg = URLEncoder.encode("비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/updateMemberForm.jsp?msg=" + errMsg);
		return;
	}else{
		//성공시 변경된 비밀번호로 다시 로그인 하도록 logout
		response.sendRedirect(request.getContextPath() + "/member/logoutAction.jsp");
	}
%>