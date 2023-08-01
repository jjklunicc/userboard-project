<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//에러메시지 담을 때 사용할 변수
	String errMsg = null;

	//요청값 유효성 검사 
	if(request.getParameter("originName") == null
	|| request.getParameter("originName").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}
	
	//요청값 저장 & 디버깅
	String originName = request.getParameter("originName");
	System.out.println("updateLocalAction originName : " + originName);
	
	if(request.getParameter("localName") == null
	|| request.getParameter("localName").equals("")
	|| request.getParameter("localName").equals(originName)){
		errMsg = URLEncoder.encode("변경할 지역이름을 입력하세요.", "utf-8");
		String requestLocal = URLEncoder.encode(originName, "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateLocalForm.jsp?localName=" + requestLocal + "&msg=" + errMsg);
		return;
	}
	
	//요청값 저장 & 디버깅
	String localName = request.getParameter("localName");
	System.out.println("updateLocalAction localName : " + localName);
	
	//DB연결에 사용할 변수 셋팅
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//변경할 지역이름이 이미 있는지 확인하기 위한 쿼리
	String confirmSql = "select count(*) cnt from local where local_name = ?";
	PreparedStatement confirmStmt = conn.prepareStatement(confirmSql);
	
	//?값 세팅
	confirmStmt.setString(1, localName);
	
	//쿼리값 디버깅
	System.out.println("updateLocalAction confirmQuery : " + confirmStmt);
	
	//쿼리 실행 후 결과값 저장
	ResultSet confirmRs = confirmStmt.executeQuery();
	int cnt = 0;
	if(confirmRs.next()){
		cnt = confirmRs.getInt("cnt");
	}
	
	//cnt가 0이 아니면 (=이미 있는 지역 이름이면) redirect
	if(cnt != 0){
		errMsg = URLEncoder.encode("이미 존재하는 지역이름 입니다.", "utf-8");
		String requestLocal = URLEncoder.encode(originName, "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateLocalForm.jsp?localName=" + requestLocal + "&msg=" + errMsg);
		return;
	}
	
	//지역이름을 변경하는 쿼리
	String updateLocalSql = "update local set local_name = ?, updatedate = now() where local_name = ?";
	PreparedStatement updateLocalStmt = conn.prepareStatement(updateLocalSql);
	
	//?값 세팅
	updateLocalStmt.setString(1, localName);
	updateLocalStmt.setString(2, originName);
	
	//쿼리값 디버깅
	System.out.println("updateLocalAction updateLocalQuery : " + updateLocalStmt);
	
	//실행후 영향받은 행 수 저장
	int row = updateLocalStmt.executeUpdate();
	
	//row값에 따라 결과 분기
	if(row == 0){
		errMsg = URLEncoder.encode("지역이름 변경실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateLocalForm.jsp?msg=" + errMsg);
		return;
	}else{
		response.sendRedirect(request.getContextPath() + "/home.jsp");
	}
%>