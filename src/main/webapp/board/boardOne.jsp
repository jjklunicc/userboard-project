<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//로그인 된 id저장
	String loginMemberId = null;
	if(session.getAttribute("loginMemberId") != null){
		loginMemberId = (String)session.getAttribute("loginMemberId");
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
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
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
	
	//현재 board에 해당하는 comment list
	String commentSql = "select comment_no, board_no, comment_content, member_id, createdate, updatedate from comment where board_no = ? order by createdate desc limit ?, ?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, startRow);
	commentStmt.setInt(3, rowPerPage);
	System.out.println("boardOne commect query : " + commentStmt);
	ResultSet commentRs = commentStmt.executeQuery();
	
	//comment list에 담아줌
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){
		Comment c = new Comment();
		c.setCommentNo(commentRs.getInt("comment_no"));
		c.setBoardNo(commentRs.getInt("board_no"));
		c.setCommentContent(commentRs.getString("comment_content"));
		c.setMemberId(commentRs.getString("member_id"));
		c.setCreatedate(commentRs.getString("createdate"));
		c.setUpdatedate(commentRs.getString("updatedate"));
		commentList.add(c);
	}
	
	//마지막 페이지 구하기
	int totalCnt = 0;
	int lastPage = 0;
	
	String countSql = "select count(*) cnt from comment where board_no = ?";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	countStmt.setInt(1, boardNo);
	System.out.println("boardOne count query : " + countStmt);
	ResultSet countRs = countStmt.executeQuery();
	
	if(countRs.next()){
		totalCnt = countRs.getInt("cnt");
	}
	
	lastPage = totalCnt / rowPerPage;
	//totalCnt가 rowPerPage로 나눠떨어지지 않으면 페이지 한개 더 있어야함
	if(totalCnt % rowPerPage != 0){
		lastPage++;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Board Detail</title>
	<link href="../style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<form class="detail_form" method="post">
			<div class="title">게시물 정보</div>
			<!-- board one 결과 -->
			<table>
				<tr>
					<th>번호</th>
					<td><%=board.getBoardNo() %></td>
				</tr>
				<tr>
					<th>지역이름</th>
					<td><%=board.getLocalName() %></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><%=board.getBoardTitle() %></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><%=board.getBoardContent() %></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td><%=board.getMemberId() %></td>
				</tr>
				<tr>
					<th>생성일자</th>
					<td><%=board.getCreatedate() %></td>
				</tr>
				<tr>
					<th>수정일자</th>
					<td><%=board.getUpdatedate() %></td>
				</tr>
			</table>
			<div class="main_container">
				<%
					if(loginMemberId != null && loginMemberId.equals(board.getMemberId())){
				%>
						<button type="submit" class="main_menu" formaction="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">수정</button>
						<button type="submit" class="main_menu" formaction="<%=request.getContextPath()%>/board/deleteBoardAction.jsp?boardNo=<%=boardNo%>&memberId=<%=board.getMemberId()%>">삭제</button>
				<%
					}
				%>
			</div>
		</form>
		<div class="title">댓글목록</div>
		<%
			//로그인 된 사용자만 댓글 입력 허용
			if(loginMemberId != null){
		%>
				<form class="comment_form" action="<%=request.getContextPath() %>/board/insertCommentAction.jsp" method="post">
					<input type="hidden" name="boardNo" value="<%=board.getBoardNo() %>">
					<input type="hidden" name="memberId" value="<%=loginMemberId %>">
					<table>
						<tr>
							<th>댓글</th>
							<td>
								<textarea rows="2" cols="60" name="commentContent"></textarea>
							</td>
							<td>
								<button type="submit">입력</button>
							</td>
						</tr>
					</table>
				</form>
		<%
			}
		%>
		<form class="comment_form" method="post">
			<!-- comment list 출력 -->
			<table>
				<tr>
					<th>댓글</th>
					<th>작성자</th>
					<th>작성일자</th>
					<th>수정일자</th>
					<th>수정</th>
					<th>삭제</th>
				</tr>
				<%
					for(Comment c : commentList){
						boolean isMyComment = c.getMemberId().equals(loginMemberId);
				%>	
						<tr>
							<td>
								<input type="hidden" name="boardNo" value="<%=c.getBoardNo()%>">
								<input type="hidden" name="commentNo" value="<%=c.getCommentNo()%>">
								<input type="hidden" name="memberId" value="<%=c.getMemberId() %>">
								<%
									if(isMyComment){
								%>
										<textarea rows="3" name="commentContent"><%=c.getCommentContent() %></textarea>
								<%
									}else{
								%>
										<%=c.getCommentContent() %>
								<%
									}
								%>
							</td>
							<td><%=c.getMemberId() %></td>
							<td><%=c.getCreatedate() %></td>
							<td><%=c.getUpdatedate() %></td>
				<%
							if(isMyComment){
				%>
								<td><button class="updateBtn" type="submit" formaction="<%=request.getContextPath()%>/board/updateCommentAction.jsp">수정</button></td>
								<td><button class="updateBtn" type="submit" formaction="<%=request.getContextPath()%>/board/deleteCommentAction.jsp">삭제</button></td>
				<%
							}
				%>
						</tr>	
				<%
					}
				%>
			</table>
		</form>
		
		<div class="pagination">
			<div>
				<% 
					if(currentPage > 1){
				%>
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">
							<img src="../images/before.png" class="icon">
						</a>
				<%
					}
				%>
			</div>
			<div>
				<%=currentPage %>
			</div>
			<div>
				<%
					if(currentPage < lastPage){
				%>
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">
							<img src="../images/next.png" class="icon">
						</a>
				<%
					}
				%>
				
			</div>
		</div>
	</div>
</body>
</html>