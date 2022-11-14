<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>

<%
	// 1. 요청 분석
	
	// 페이징
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	
	
	
	
	// 2. 요청 처리
	
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	
	// count 쿼리
	String cntSalarySql = "SELECT COUNT(s.emp_no) cnt FROM salaries s";
	
	PreparedStatement cntSalaryStmt = conn.prepareStatement(cntSalarySql);
	
	ResultSet cntSalaryRs = cntSalaryStmt.executeQuery();
	
	int count = 0;
	if(cntSalaryRs.next()) {
		count = cntSalaryRs.getInt("cnt");
		
	}
	
	int lastPage = count / ROW_PER_PAGE;
	if((count % ROW_PER_PAGE) != 0) {
		lastPage += 1;
	}
	
	
	
	// 임시객체 사용 안한 정석적인 조인 방법
	/*
	
	SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName 
	FROM salaries s INNER JOIN employees e 
	ON s.emp_no = e.emp_no LIMIT 0, 10;
	*/

	String salarySql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
	
	PreparedStatement salaryStmt = conn.prepareStatement(salarySql);
	
	salaryStmt.setInt(1, beginRow);
	salaryStmt.setInt(2, ROW_PER_PAGE);
	
	
	
	ResultSet salaryRs = salaryStmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<Salary>();
	while(salaryRs.next()) {
		Salary s = new Salary();
		s.emp = new Employee();		// 참조타입을 또 다른 참조타입에 넣을 수 있다. emp를 salary에 사용한 것처럼.
		
		s.emp.empNo = salaryRs.getInt("empNo");
		s.salary = salaryRs.getInt("salary");
		s.fromDate = salaryRs.getString("fromDate");
		s.toDate = salaryRs.getString("toDate");
		s.emp.firstName = salaryRs.getString("firstName");
		s.emp.lastName = salaryRs.getString("lastName");
		salaryList.add(s);
		
		
	}
	
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
				<table border = "1">
					<tr>
						<th>사원 번호</th>
						<th>연봉</th>
						<th>fromDate</th>
						<th>toDate</th>
						<th>firstName</th>
						<th>lastName</th>
						<!--  <th>성별</th> 성별 안 넣어서 null로 초기화되어서 주석처리 -->
					</tr>
				
					<%
						for(Salary s : salaryList) {
					%>
							<tr>
								<td><%=s.emp.empNo %></td>
								<td><%=s.salary %></td>
								<td><%=s.fromDate %></td>
								<td><%=s.toDate %></td>
								<td><%=s.emp.firstName %></td>
								<td><%=s.emp.lastName %></td>
								<!--  <td><%=s.emp.gender %></td> -->
							</tr>	
							
					<%
						}
					%>
				
				</table>
				
			</div>
		
			<!-- 페이징 처리 -->
		
			<div>&nbsp;</div>
			
			<div>
				<span>현재 페이지 : </span>
				<span><%=currentPage %></span>
			</div>
			
			<div>
				<a href = "<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=1">처음</a>
				<%
					if(currentPage > 1) {
				%>
						<a href = "<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=currentPage - 1%>">이전</a>
				<% 
					}
				
					if(currentPage < lastPage) {
				%>
						<a href = "<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=currentPage + 1%>">다음</a>
				<% 
					}
				%>
				<a href = "<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=lastPage%>">마지막</a>
				
			
			
			</div>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		</div>
		
		
	</body>
</html>