<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://52.79.53.122:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(dburl, dbuser,dbpw);
	
	String sql = "select local_name localName, '대한민국' country, '박성환' worker from local limit 0,1";
	stmt = conn.prepareStatement(sql);
	rs1 = stmt.executeQuery();
	
	//vo대신 HashMap타입 사용
	HashMap<String, Object> map = null;
	
	if(rs1.next()){
		map = new HashMap<String, Object>();
		//map.put(키이름, 값)
		map.put("localName", rs1.getString("localName")); 
		map.put("country", rs1.getString("country")); 
		map.put("worker", rs1.getString("worker")); 
	}
	//map.get(키이름) => 값을 가져옴
	System.out.println("localListByMap localName" + (String)map.get("localName"));
	System.out.println("localListByMap country" + (String)map.get("country"));
	System.out.println("localListByMap worker" + (String)map.get("worker"));
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "select local_name localName, '대한민국' country, '박성환' worker from local";
	stmt2 = conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs2.getString("localName"));
		m.put("country", rs2.getString("country"));
		m.put("worker", rs2.getString("worker"));
		list.add(m);
	}
	
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	//group by => 특정 컬럼값을 기준으로 행값의 집합을 만들어 집계함수를 사용하는 sql명령
	String sql3 = "select local_name localName, count(local_name) cnt from board group by local_name";
	stmt3 = conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String,Object>>();
	while(rs3.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs3.getString("localName"));
		m.put("cnt", rs3.getInt("cnt"));
		list3.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>localListByMap.jsp</title>
</head>
<body>
	<div>
		<h2>rs1 결과셋</h2>
		<%=map.get("localName") %>
		<%=map.get("country") %>
		<%=map.get("worker") %>
	</div>
	
	<hr>
	
	<h2>rs2 결과셋</h2>
	<table>
		<tr>
			<th>localName</th>
			<th>country</th>
			<th>worker</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
				<tr>
					<td><%=map.get("localName") %></td>
					<td><%=map.get("country") %></td>
					<td><%=map.get("worker") %></td>
				</tr>
		<%
			}
		%>
	</table>

	<hr>

	<h2>rs3 결과셋</h2>
	<ul>
		<%
			for(HashMap<String, Object> m : list3){
		%>	
				<li>
					<a href=""><%=(String)m.get("localName") %>(<%=(Integer)m.get("cnt") %>)</a>
				</li>
		<%
			}
		%>
	</ul>	
	
</body>
</html>