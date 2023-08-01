<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//에러메시지 담을 때 사용할 변수
	String errMsg = null;

	//요청값 유효성 검사 
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")){
		errMsg = URLEncoder.encode("지역이름을 입력하세요.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertLocalForm.jsp?msg=" + errMsg);
		return;
	}
	
	//요청값 저장
	String localName = request.getParameter("localName");
	
	//요청값 디버깅
	System.out.println("insertLocalAction localName : " + localName);
	
	//DB연결에 사용할 변수 셋팅
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//지역이름이 이미 있는지 확인하기 위한 쿼리
	String confirmSql = "select count(*) cnt from local where local_name = ?";
	PreparedStatement confirmStmt = conn.prepareStatement(confirmSql);
	
	//?값 세팅
	confirmStmt.setString(1, localName);
	
	//쿼리값 디버깅
	System.out.println("insertLocalAction confirmQuery : " + confirmStmt);
	
	//쿼리 실행 후 결과값 저장
	ResultSet confirmRs = confirmStmt.executeQuery();
	int cnt = 0;
	if(confirmRs.next()){
		cnt = confirmRs.getInt("cnt");
	}
	
	//cnt가 0이 아니면 (=이미 있는 지역 이름이면) redirect
	if(cnt != 0){
		errMsg = URLEncoder.encode("이미 존재하는 지역이름 입니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertLocalForm.jsp?msg=" + errMsg);
		return;
	}
	
	//지역이름을 추가하는 쿼리
	String addLocalSql = "insert into local values(?, now(), now())";
	PreparedStatement addLocalStmt = conn.prepareStatement(addLocalSql);
	
	//?값 세팅
	addLocalStmt.setString(1, localName);
	
	//쿼리값 디버깅
	System.out.println("insertLocalAction addLocalQuery : " + addLocalStmt);
	
	//실행후 영향받은 행 수 저장
	int row = addLocalStmt.executeUpdate();
	
	//row값에 따라 결과 분기
	if(row == 0){
		errMsg = URLEncoder.encode("지역이름 추가실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/insertLocalForm.jsp?msg=" + errMsg);
		return;
	}else{
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}
%>
