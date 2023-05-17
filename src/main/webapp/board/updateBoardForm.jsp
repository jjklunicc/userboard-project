<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	//이전페이지에서 넘어온 메시지 있으면 저장
	String msg = "";
	if(request.getParameter("msg") != null){
		msg = request.getParameter("msg");
	}
	
	//요청값 유효성 검사
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	System.out.println("boardOne boardNo : " + boardNo);
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null
	&& !request.getParameter("currentPage").equals("")){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println("boardOne currentPage : " + currentPage);
	
	int rowPerPage = 10;
	int startRow = (currentPage - 1) * rowPerPage;
	
	//DB연결을 위한 변수설정
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	//DB연결
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//board one 결과
	String boardSql = "select board_no, local_name, board_title, board_content, member_id, createdate, updatedate from board where board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	System.out.println("boardOne board query : " + boardStmt);
	ResultSet boardRs = boardStmt.executeQuery();
	
	//board 객체에 담아줌.
	Board board = null;
	if(boardRs.next()){
		board = new Board();
		board.setBoardNo(boardRs.getInt("board_no"));
		board.setLocalName(boardRs.getString("local_name"));
		board.setBoardTitle(boardRs.getString("board_title"));
		board.setBoardContent(boardRs.getString("board_content"));
		board.setMemberId(boardRs.getString("member_id"));
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}

	//세션에 저장된 localList 가져오기
	Object o = session.getAttribute("localList");
	List<?> list = new ArrayList<>();
	if(o instanceof Collection){
		list = new ArrayList<>((Collection<?>)o);
	}
	ArrayList<String> localList = new ArrayList<String>();
	for(int i = 0; i < list.size(); i++){
		localList.add(list.get(i).toString());
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Update Board</title>
	<link href="../style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<form class="insert_form" method="post" action="<%=request.getContextPath()%>/board/updateBoardAction.jsp">
			<div class="title">게시물 수정</div>
			<!-- board one 결과 -->
			<table>
				<tr>
					<td colspan="2"><div class="error"><%=msg %></div></td>
				</tr>
				<tr>
					<th>번호</th>
					<td><input type="text" name="boardNo" readonly value="<%=boardNo %>"></td>
				</tr>
				<tr>
					<th>지역이름</th>
					<td>
						<select name="localName">
							<option value="">지역선택</option>
							<%
								for(String local : localList){
									String selected = local.equals(board.getLocalName()) ? "selected" : "";
							%>
									<option <%=selected %>><%=local %></option>
							<%
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="boardTitle" value="<%=board.getBoardTitle() %>"></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea name="boardContent" rows="7"><%=board.getBoardContent() %></textarea></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><input type="text" name="memberId" readonly value="<%=board.getMemberId() %>"></td>
				</tr>
				<tr>
					<th>생성일자</th>
					<td><input type="text" name="createdate" readonly value="<%=board.getCreatedate() %>"></td>
				</tr>
				<tr>
					<th>수정일자</th>
					<td><input type="text" name="updatedate" readonly value="<%=board.getUpdatedate() %>"></td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
	
</body>
</html>