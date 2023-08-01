<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	//세션 유효성 검사 - 로그인이 되어있는 상태면 home으로
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	//요청값 유효성 검사
	if(request.getParameter("memberId") == null
	|| request.getParameter("memberId").equals("")){
		String errMsg = URLEncoder.encode("아이디를 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + errMsg);
		return;
	}
	if(request.getParameter("memberPw") == null
	|| request.getParameter("memberPw").equals("")){
		String errMsg = URLEncoder.encode("비밀번호를 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + errMsg);
		return;
	}
	
	//요청값 변수에 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println("loginAction memberId : " + memberId);
	System.out.println("loginAction memberPw : " + memberPw);
	
	Member paraMember = new Member();
	paraMember.setMemberId(memberId);
	paraMember.setMemberPw(memberPw);
	
	//DB연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//아이디, 비밀번호 일치하는 memberId가져옴
	String sql = "select member_id memberId from member where member_id = ? and member_pw = password(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paraMember.getMemberId());
	stmt.setString(2, paraMember.getMemberPw());
	System.out.println("loginAction query : " + stmt);
	rs = stmt.executeQuery();
	
	//로그인 성공
	if(rs.next()){
		//세션에 로그인 정보 저장
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("loginAction 로그인 성공 세션 정보 : " + session.getAttribute("loginMemberId"));
	}else{ //로그인 실패
		System.out.println("loginAction 로그인 실패");
		String errMsg = URLEncoder.encode("아이디가 없거나 비밀번호가 틀렸습니다.", "utf-8");
		response.sendRedirect(request.getContextPath() + "/home.jsp?msg=" + errMsg);
		return;
	}
	response.sendRedirect(request.getContextPath() + "/home.jsp");
%>