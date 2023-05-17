<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	//요청값 유효성 검사
	String errMsg = null;
	if(request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		errMsg = URLEncoder.encode("아이디를 입력하세요.", "utf-8");
	}else if(request.getParameter("memberPw") == null
	|| request.getParameter("memberPw").equals("")){
		errMsg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8");
	}else if(request.getParameter("confirmPw") == null
	|| request.getParameter("confirmPw").equals("")){
		errMsg = URLEncoder.encode("비밀번호를 한번 더 입력하세요.", "utf-8");
	}else if(!request.getParameter("confirmPw").equals(request.getParameter("memberPw"))){
		errMsg = URLEncoder.encode("비밀번호와 비밀번호확인이 일치하지 않습니다.", "utf-8");
	}
	
	if(errMsg != null){
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg=" + errMsg);
		return;
	}
	
	//요청값 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println("insertMemberAction memberId : " + memberId);
	System.out.println("insertMemberAction memberPw : " + memberPw);
	
	//Member에 값 저장
	Member paraMember = new Member();
	paraMember.setMemberId(memberId);
	paraMember.setMemberPw(memberPw);
	
	//DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//id 중복 체크
	String idSql = "select count(*) from member where member_id=(?)";
	PreparedStatement stmt0 = conn.prepareStatement(idSql);
	stmt0.setString(1, paraMember.getMemberId());
	System.out.println("insertMemberAction id query : " + stmt0);
	ResultSet rs = stmt0.executeQuery();
	
	//id중복 값 가져옴
	int sameId = 0;
	if(rs.next()){
		sameId = rs.getInt("count(*)");
	}
	
	//id중복값이 있으면 다시 가입 폼으로
	if(sameId != 0){
		errMsg = URLEncoder.encode("이미 가입된 아이디 입니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg="+ errMsg);
		return;
	}
	
	//insert query
	String sql = "insert into member(member_id, member_pw, createdate, updatedate) values(?, password(?), now(), now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, paraMember.getMemberId());
	stmt.setString(2, paraMember.getMemberPw());
	System.out.println("insertMemberAction query : " + stmt);
	
	//쿼리 실행 결과값 저장
	int row = stmt.executeUpdate();
	System.out.println("insertMemberAction row : " + row);
	
	if(row == 1){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}else{
		errMsg = URLEncoder.encode("회원가입 실패", "utf-8");
		response.sendRedirect(request.getContextPath() + "/member/insertMemberForm.jsp?msg="+ errMsg);
	}	
%>