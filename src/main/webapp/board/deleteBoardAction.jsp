<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//요청값 유효성 검사
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//요청값 저장 & 디버깅
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println("deleteBoardAction boardNo : " + boardNo);
	
	if(request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
		return;
	}
	
	//요청값 저장 & 디버깅
	String memberId = request.getParameter("memberId");
	System.out.println("deleteBoardAction memberId : " + memberId);
	
	//DB연결을 위한 변수 설정
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//delete를 위한 쿼리
	String deleteSql = "delete from board where board_no = ? and member_id = ?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	
	//?값 세팅
	deleteStmt.setInt(1, boardNo);
	deleteStmt.setString(2, memberId);
	
	//쿼리 디버깅
	System.out.println("deleteBoardAction deleteQeury : " + deleteStmt);
	
	//쿼리 실행후 영향받은 행 저장
	int row = deleteStmt.executeUpdate();
	
	//실패시 boardOne으로 성공시 home으로
	if(row == 0){
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
		return;
	}else{
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}
%>