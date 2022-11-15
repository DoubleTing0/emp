<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>


<%
	

	

	/*
	// 방법 1
	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	
	while(rs.next()) {
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = rs.getInt("empNo");
		de.dept = new Department();
		de.dept.deptNo = rs.getInt("deptNo");
		de.fromDate =
		de.toDate
		
		
	}
	*/














	// 1. 요청 분석
	/*
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	
	int beginRow = (currentPage - 1) * rowPerPage;
	*/
	
			
	
	
	
	// 2. 요청 처리
	
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	
	// 드라이버 로딩
	Class.forName(driver);
	
	// DB 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// sql
	String sql = "SELECT de.emp_no empNo, e.first_name firstName, e.last_name lastName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT 0, 10";
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()) {
		DeptEmp deptEmp = new DeptEmp();
		deptEmp.emp = new Employee();
		deptEmp.dept = new Department();
		
		deptEmp.emp.empNo = rs.getInt("empNo");
		deptEmp.emp.firstName = rs.getString("firstName");
		deptEmp.emp.lastName = rs.getString("lastName");
		deptEmp.dept.deptName = rs.getString("deptName");
		deptEmp.fromDate = rs.getString("fromDate");
		deptEmp.toDate = rs.getString("toDate");
		list.add(deptEmp);
		
		
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
							<th>부서 번호</th>
							<th>fromDate</th>
							<th>toDate</th>
						</tr>
					</thead>
					
					<tbody>
						<%
							for(DeptEmp de : list) {
						%>
								<tr>
									<td><%=de.emp.empNo %></td>
									<td><%=de.emp.firstName %></td>
									<td><%=de.emp.lastName %></td>
									<td><%=de.dept.deptName %></td>
									<td><%=de.fromDate %></td>
									<td><%=de.toDate %></td>
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