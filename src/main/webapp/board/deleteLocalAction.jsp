<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//요청값 유효성 검사
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	
	//요청값 저장 & 디버깅
	String localName = request.getParameter("localName");
	System.out.println("deleteLocalAction localName : " + localName);
	
	//DB연결에 사용할 변수 셋팅
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//삭제쿼리
	String deleteSql = "delete from local where local_name = ?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	
	//?값 세팅
	deleteStmt.setString(1, localName);
	
	//쿼리값 디버깅
	System.out.println("deleteLocalAction deleteQuery : " + deleteStmt);
	
	//실행후 영향받은 행 수 저장
	int row = deleteStmt.executeUpdate();
	
	//결과값 디버깅
	if(row == 0){
		System.out.println("deleteLocalAction 삭제실패");
	}else{
		System.out.println("deleteLocalAction 삭제성공");
	}
	response.sendRedirect(request.getContextPath() + "/home.jsp");
%>