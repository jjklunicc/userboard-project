<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//요청값 유효성 검사
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//요청값 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId");
	
	//요청값 디버깅
	System.out.println("updateBoardAction boardNo : " + boardNo);
	System.out.println("updateBoardAction memberId : " + memberId);

	String msg = null;
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")){
		msg = URLEncoder.encode("변경할 지역을 선택하세요.", "utf-8");
	}else if(request.getParameter("boardTitle") == null
	|| request.getParameter("boardTitle").equals("")){
		msg = URLEncoder.encode("제목을 입력하세요.", "utf-8");
	}else if(request.getParameter("boardContent") == null
	|| request.getParameter("boardContent").equals("")){
		msg = URLEncoder.encode("내용을 입력하세요.", "utf-8");
	}
	
	//빈값이 있으면 updateBoardForm으로 redirect
	if(msg != null){
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo=" + boardNo + "&msg=" + msg);
		return;
	}
	
	//요청값 저장
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	//요청값 디버깅
	System.out.println("updateBoardAction localName : " + localName);
	System.out.println("updateBoardAction boardTitle : " + boardTitle);
	System.out.println("updateBoardAction boardContent : " + boardContent);
	
	//DB연결을 위한 변수 설정
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//update를 위한 쿼리
	String updateSql = "update board set local_name = ?, board_title = ?, board_content = ?, updatedate = now() where board_no = ? and member_id = ?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	
	//?값 세팅
	updateStmt.setString(1, localName);
	updateStmt.setString(2, boardTitle);
	updateStmt.setString(3, boardContent);
	updateStmt.setInt(4, boardNo);
	updateStmt.setString(5, memberId);
	
	//쿼리 디버깅
	System.out.println("updateBoardAction updateQuery : " + updateStmt);
	
	//쿼리실행 후 영향받은 행 저장
	int row = updateStmt.executeUpdate();
	
	//실패시 updateBoardForm으로, 성공시 boardOne으로
	if(row == 0){
		String err = URLEncoder.encode("수정실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?msg=" + err);
		return;
	}else{
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
	}
	
%>