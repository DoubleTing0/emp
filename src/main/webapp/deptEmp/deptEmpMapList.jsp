<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>



<%

	/*
	
	// 방법 2
	// deptEmpMapList.jsp
	// deptEmpMapList.jsp
	ArrayList<HashMap<String, Object>> list = new ArrayList<String, Object>();
	while(rs.next()) {
		//...
	}
	*/
	
	
	
	// 1. 요청 분석
	
	
	
	
	// 2. 요청 처리
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	// 드라이버 로딩
	Class.forName(driver);
	
	// DB 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String sql = "SELECT de.emp_no empNo, e.first_name firstName, e.last_name lastName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT 0, 10"; 
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		
		HashMap<String, Object> hashMap = new HashMap<String, Object>();
		
		hashMap.put("empNo", rs.getInt("empNo"));
		hashMap.put("firstName", rs.getString("firstName"));
		hashMap.put("lastName", rs.getString("lastName"));
		hashMap.put("deptName", rs.getString("deptName"));
		hashMap.put("fromDate", rs.getString("fromDate"));
		hashMap.put("toDate", rs.getString("toDate"));
		list.add(hashMap);
		
		
	}
	
	
	
	// 3. 출력
	
	
	stmt.close();
	conn.close();
	
	
	
	
	

%>



<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	
	<body>
		<div>
		
		
		
			<div>
				<table>
					<thead>
						<tr>
							<th>사원 번호</th>
							<th>firstName</th>
							<th>lastName</th>
							<th>부서 이름</th>
							<th>fromDate</th>
							<th>toDate</th>
						</tr>
					</thead>
					
					<tbody>
						<%
							for(HashMap<String, Object> hm : list) {
						%>
								<tr>
									<td><%=hm.get("empNo") %></td>
									<td><%=hm.get("firstName") %></td>
									<td><%=hm.get("lastName") %></td>
									<td><%=hm.get("deptName") %></td>
									<td><%=hm.get("fromDate") %></td>
									<td><%=hm.get("toDate") %></td>
								</tr>
						<%								
							}
						%>
						
					
					</tbody>
						
				
				
				
				
				
				
				
				
				
				</table>
			
			
			</div>
		
		
		
		
		
		
		
		
		
		
		
		
		</div>
		
		
		
		
		
		
		
		
		
		
	</body>
</html>