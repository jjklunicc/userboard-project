<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//요청값 유효성 검사
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//요청값 저장 & 디버깅
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println("updateCommentAction boardNo : " + boardNo);
	
	//나머지 요청값 유효성 검사
	if(request.getParameter("commentNo") == null
	|| request.getParameter("commentNo").equals("")
	|| request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")
	|| request.getParameter("commentContent") == null
	|| request.getParameter("commentContent").equals("")){
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
		return;
	}
	
	//요청값 저장
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String memberId = request.getParameter("memberId");
	String commentContent = request.getParameter("commentContent");
	
	//요청값 디버깅
	System.out.println("updateCommentAction commentNo : " + commentNo);
	System.out.println("updateCommentAction memberId : " + memberId);
	System.out.println("updateCommentAction commentContent : " + commentContent);
	
	//DB연결을 위한 변수설정
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//update를 위한 쿼리
	String updateSql = "update comment set comment_content = ?, updatedate = now() where board_no = ? and comment_no = ? and member_id = ?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	
	//?값 세팅
	updateStmt.setString(1, commentContent);
	updateStmt.setInt(2, boardNo);
	updateStmt.setInt(3, commentNo);
	updateStmt.setString(4, memberId);
	
	//쿼리 디버깅
	System.out.println("updateCommentAction updateQuery : " + updateStmt);
	
	//쿼리 실행 후 영향받은 행 저장
	int row = updateStmt.executeUpdate();
	
	//row값 디버깅
	System.out.println("updateCommentAction row : " + row);
	
	// 성공/실패 모두 boardOne으로
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
		
%>