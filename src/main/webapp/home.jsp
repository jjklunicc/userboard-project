<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	//로그인 되어있는지 확인
	boolean isLogin = false;
	if(session.getAttribute("loginMemberId") != null){
		isLogin = true;
	}
	//다른 페이지 거쳐서 메시지 값 있으면 저장해주기
	String msg = "";
	if(request.getParameter("msg") != null
	&& !request.getParameter("msg").equals("")){
		msg = request.getParameter("msg");
	}
	
	//선택된 지역 이름 있으면 값 저장해주기
	String selectedLocalName = "전체";
	if(request.getParameter("localName") != null
	&& !request.getParameter("localName").equals("")){
		selectedLocalName = request.getParameter("localName");
	}
	System.out.println("home localName : " + selectedLocalName);
	
	//몇번째 페이지인지 받아오기
	int currentPage = 1;
	if(request.getParameter("currentPage") != null
	&& !request.getParameter("currentPage").equals("")){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startRow = (currentPage - 1) * rowPerPage;
	
	//DB연결을 위한 변수 설정
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		
		//DB연결
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//지역별 게시물 개수 쿼리
	String subMenuSql = "select '전체' localName, count(local_name) cnt from board union all select local_name localName, count(local_name) cnt from board group by local_name UNION ALL SELECT local_name, 0 cnt FROM local WHERE local_name NOT IN (SELECT local_name FROM board)";
	PreparedStatement subMenuStmt = conn.prepareStatement(subMenuSql);
	System.out.println("home subMenu query : " + subMenuStmt);
	ResultSet subMenuRs = subMenuStmt.executeQuery();
	
	//db에서 받아온 값들 해시맵리스트에 저장
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	
	//지역 이름만 따로 저장
	ArrayList<String> localList = new ArrayList<String>();
	for(HashMap<String, Object> m : subMenuList){
		String currLocal = (String)m.get("localName");
		if(!currLocal.equals("전체")){
			localList.add(currLocal);
		}
	}
	
	//지역이름 세션에 저장
	session.setAttribute("localList", localList);
	
	//선택지역 게시물 쿼리
	String boardSql = "select board_no boardNo, local_name localName, board_title boardTitle from board";
	//전체일때도 다 보여줘야 하니까 조건절 없이!
	if(!selectedLocalName.equals("전체")){
		boardSql += " where local_name='" + selectedLocalName + "'";
	}
	//마지막 페이지 계산할때도 같은 쿼리를 써주니까 미리 저장
	boardSql += " limit ?, ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, startRow);
	boardStmt.setInt(2, rowPerPage);
	System.out.println("home board query : " + boardStmt);
	ResultSet boardRs = boardStmt.executeQuery();
	
	//db에서 받아온 값들 해시맵리스트에 저장
	ArrayList<HashMap<String, Object>> boardList = new ArrayList<HashMap<String, Object>>();
	while(boardRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("boardNo", boardRs.getInt("boardNo"));
		m.put("localName", boardRs.getString("localName"));
		m.put("boardTitle", boardRs.getString("boardTitle"));
		boardList.add(m);
	}
	
	//마지막 페이지 계산
	int totalCnt = 0;
	int lastPage = 0;
	
	//for문 돌면서 현재 선택된 localName과 같은 항목의 count가져와서 저장
	for(HashMap<String, Object> m : subMenuList){
		if(selectedLocalName.equals(m.get("localName"))){
			totalCnt = (Integer)m.get("cnt");
		}
	}
	
	lastPage = totalCnt / rowPerPage;
	//전체 개수가 rowPerPage로 나눠떨어지지 않으면 한페이지 더 있어야함 => +1
	if(totalCnt % rowPerPage != 0){
		lastPage++;
	}
	
	//10개 띄워줄 페이지 중 첫 페이지
	int startPage = currentPage % 10 == 0 ? currentPage / 10 - 1 : currentPage / 10;
	startPage = startPage * 10 + 1;
	
	//10개 띄워줄 페이지 중 마지막 페이지
	int endPage = startPage + 9 < lastPage ? startPage + 9 : lastPage;
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Home</title>
	<link href="./style.css" type="text/css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<%
			//request.getRequestDispatcher("/inc/mainmenu.jsp").include(request, response);
			//이 코드 액션태그로 변경하면 아래와 같음
		%>
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="middle_content">
			<!-- 서브메뉴(subMemuList) -->
			<%
				// 로그인 되어있을 땐 local을 추가/수정/삭제할 수 있는 메뉴가 나와야함.
				// 서브메뉴 파트 크기를 줄여주는 클래스를 추가해서 크기를 맞춰줌.
				String loginClass = "logout";
				if(isLogin){
					loginClass = "login";
				}
			%>
			<div class="sub_menu">
				<div class="<%=loginClass%>">
					<ul>
						<%
							for(HashMap<String, Object> m : subMenuList){
								String className = "";
								if(selectedLocalName.equals(m.get("localName"))){
									className = "selected";
								}
						%>
								<li class="<%=className%>">
									<a href="<%=request.getContextPath() %>/home.jsp?localName=<%=(String)m.get("localName")%>">
										<%=(String)m.get("localName") %>(<%=(Integer)m.get("cnt") %>)
									</a>
								</li>
						<%
							}
						%>
					</ul>
				
				</div>
				<!-- 로그인 되어있을 때만 local 추가/수정/삭제 가능하게 -->
				<%
					if(isLogin){
				%>
					<div class="small_container">
						<div class="small_menu"><a href="<%=request.getContextPath()%>/board/insertLocalForm.jsp">지역추가</a></div>
						<%
							// 게시글이 없을 때만 수정/삭제 가능하도록
							if(totalCnt == 0){
						%>
								<div class="small_menu"><a href="<%=request.getContextPath()%>/board/updateLocalForm.jsp?localName=<%=selectedLocalName%>">이름수정</a></div>
								<div class="small_menu"><a href="<%=request.getContextPath()%>/board/deleteLocalAction.jsp?localName=<%=selectedLocalName%>">삭제</a></div>
						<%
							}
						%>
					</div>
				<%
					}
				%>
			</div>
			<div>
				<!-- home내용 : 로그인폼 / 카테고리별 게시글 5개씩 -->
				<!-- 로그인 폼 -->
				<%
					//로그인 전이면 로그인폼 출력
					if(session.getAttribute("loginMemberId") == null){
				%>
						<form class="login_form" action="<%=request.getContextPath() %>/member/loginAction.jsp" method="post">
							<div class="title">로그인</div>
							<table>
								<tr>
									<td colspan="2"><div class="error"><%=msg %></div></td>
								</tr>
								<tr>
									<th>아이디</th>
									<td><input type="text" name="memberId"></td>
								</tr>
								<tr>
									<th>비밀번호</th>
									<td><input type="password" name="memberPw"></td>
								</tr>
							</table>
							<button type="submit">로그인</button>
						</form>
				<%
					}
				%>
			</div>
		</div>
		
		<div class="board_content">
			<!-- 카테고리 별 게시글 5개씩 -->
			<table>
				<tr>
					<th>지역이름</th>
					<th>번호</th>
					<th>제목</th>
				</tr>
				<%
					for(HashMap<String, Object> m : boardList){
				%>
						<tr>
							<td><%=m.get("localName") %></td>
							<td><%=m.get("boardNo") %></td>
							<td><a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=m.get("boardNo")%>"><%=m.get("boardTitle") %></a></td>
						</tr>
				<%
					}
				%>
			</table>
			
		</div>
		
		<div class="pagination">
			<div>
			<%
				if(currentPage > 1){
			%>
					<a href="<%=request.getContextPath() %>/home.jsp?currentPage=<%=currentPage-1 %>&localName=<%=selectedLocalName%>">
						<img src="./images/before.png" class="icon">
					</a>
			<%
				}
			%>
				
			</div>
			<div class="page">
				<%
					for(int i = startPage; i <= endPage; i++){
						String selectedPage = i == currentPage ? "selectedPage" : "";
				%>
						<a class="<%=selectedPage %>" href="<%=request.getContextPath() %>/home.jsp?currentPage=<%=i %>&localName=<%=selectedLocalName%>">
							<%=i %>
						</a>
				<%
					}
				%>
			</div>
			<div>
				<%
					if(currentPage < lastPage){
				%>
						<a href="<%=request.getContextPath() %>/home.jsp?currentPage=<%=currentPage+1 %>&localName=<%=selectedLocalName%>">
							<img src="./images/next.png" class="icon">
						</a>
				<%
					}
				%>
				
			</div>
		</div>
		
		<div>
			<!-- include 페이지 : copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>