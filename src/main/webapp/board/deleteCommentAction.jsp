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
	System.out.println("deleteCommentAction boardNo : " + boardNo);
	
	//나머지 요청값 유효성 검사
	if(request.getParameter("commentNo") == null
	|| request.getParameter("commentNo").equals("")
	|| request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
		return;
	}
	
	//요청값 저장
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String memberId = request.getParameter("memberId");
	
	//요청값 디버깅
	System.out.println("deleteCommentAction commentNo : " + commentNo);
	System.out.println("deleteCommentAction memberId : " + memberId);
	
	//DB연결을 위한 변수설정
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//delete를 위한 쿼리
	String deleteSql = "delete from comment where board_no = ? and comment_no = ? and member_id = ?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	
	//?값 세팅
	deleteStmt.setInt(1, boardNo);
	deleteStmt.setInt(2, commentNo);
	deleteStmt.setString(3, memberId);
	
	//쿼리 디버깅
	System.out.println("deleteCommentAction deleteQuery : " + deleteStmt);
	
	//쿼리 실행 후 영향받은 행의 수 저장
	int row = deleteStmt.executeUpdate();
	
	//row값 디버깅
	System.out.println("deleteCommentAction row : " + row);
	
	// 실패/성공 모두 boardOne으로 redirection
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
%>
