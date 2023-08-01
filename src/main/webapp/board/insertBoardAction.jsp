<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//요청값 유효성 검사
	String msg = null;
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")){
		msg = URLEncoder.encode("지역을 선택하세요.", "utf-8");
	}else if(request.getParameter("boardTitle") == null
	|| request.getParameter("boardTitle").equals("")){
		msg = URLEncoder.encode("제목을 입력하세요.", "utf-8");
	}else if(request.getParameter("boardContent") == null
	|| request.getParameter("boardContent").equals("")){
		msg = URLEncoder.encode("내용을 입력하세요.", "utf-8");
	}else if(request.getParameter("loginMemberId") == null
	|| request.getParameter("loginMemberId").equals("")){
		msg = URLEncoder.encode("로그인 후 작성 가능합니다.", "utf-8");
	}
	
	//빈값이 있을경우 insertBoardForm으로 redirection
	if(msg != null){
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?msg=" + msg);
		return;
	}
	
	//요청값 저장
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String loginMemberId = request.getParameter("loginMemberId");
	
	//요청값 디버깅
	System.out.println("insertBoardAction localName : " + localName);
	System.out.println("insertBoardAction boardTitle : " + boardTitle);
	System.out.println("insertBoardAction boardContent : " + boardContent);
	System.out.println("insertBoardAction loginMemberId : " + loginMemberId);
	
	//DB연결을 위한 변수저장
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	//Board추가를 위한 쿼리
	String insertSql = "insert into board(local_name, board_title, board_content, member_id, createdate, updatedate) values(?, ?, ?, ?, now(), now())";
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	
	//?값 세팅
	insertStmt.setString(1, localName);
	insertStmt.setString(2, boardTitle);
	insertStmt.setString(3, boardContent);
	insertStmt.setString(4, loginMemberId);
			
	//쿼리 확인
	System.out.println("insertBoardAction insertQuery : " + insertStmt);
	
	//실행후 영향받은 행의 수 저장
	int row = insertStmt.executeUpdate();
	
	//저장 실패시 insertBoardForm, 성공시 home으로
	if(row == 0){
		String err = URLEncoder.encode("작성실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?msg=" + err);
		return;
	}else{
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}
	
%>

