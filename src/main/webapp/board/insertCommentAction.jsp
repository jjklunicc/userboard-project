<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	//넘어온 값들 유효성 검사
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	String msg = null;
	if(request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		msg = "memberId is required";
	}
	if(request.getParameter("commentContent") == null
	|| request.getParameter("commentContent").equals("")){
		msg = "commentContent is required";
	}
	if(msg != null){
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?msg=" + msg);
		return;
	}
	String memberId = request.getParameter("memberId");
	String commentContent = request.getParameter("commentContent");
	
	//DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//insert쿼리 전송
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	String sql = "insert into comment(board_no, comment_content, member_id, createdate, updatedate) values(?, ?, ?, now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	//?의 값들 추가
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentContent);
	stmt.setString(3, memberId);
	System.out.println("insertAction query : " + stmt);
	
	//쿼리 실행 => 영향받은 행의 수 가져옴
	int row = stmt.executeUpdate();
	
	//성공이라면 row == 1
	if(row == 1){
		System.out.println("insertCommentAction query success");
	}else{
		System.out.println("insertCommentAction query failed");
	}
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
%>