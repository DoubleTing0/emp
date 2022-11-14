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
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	
	
	System.out.println(123);
	
	
	
	// 2. 요청 처리
	
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");

	
	// 2-1 count 쿼리
	String cntSalarySql = "SELECT COUNT(s.emp_no) cnt FROM salaries s";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement cntSalaryStmt = conn.prepareStatement(cntSalarySql);
	
	// ResultSet 에 저장
	ResultSet cntSalaryRs = cntSalaryStmt.executeQuery();
	
	int count = 0;
	if(cntSalaryRs.next()) {
		count = cntSalaryRs.getInt("cnt");
	}
	
	int lastPage = count / ROW_PER_PAGE;
	if((count % ROW_PER_PAGE) != 0) {
		lastPage += 1;
	}
	
	
	
	// 2-2 List 쿼리
	// SELECT s.emp_no empNO, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName 
	// FROM salaries s INNER JOIN employees e on s.emp_no = e.emp_no 
	// ORDER BY s.emp_no ASC LIMIT ?, ?";
	String salaryListSql = "SELECT s.emp_no empNO, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e on s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement salaryListStmt = conn.prepareStatement(salaryListSql);
	
	// salaryListSql ? 대입
	salaryListStmt.setInt(1, beginRow);
	salaryListStmt.setInt(2, ROW_PER_PAGE);
	
	// ResultSet에 저장
	ResultSet salaryListRs = salaryListStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> salaryList = new ArrayList<HashMap<String, Object>>();
	
	while(salaryListRs.next()) {
		HashMap<String, Object> salaryHm = new HashMap<String, Object>();
		salaryHm.put("empNo", salaryListRs.getInt("empNo"));
		salaryHm.put("salary", salaryListRs.getInt("salary"));
		salaryHm.put("fromDate", salaryListRs.getString("fromDate"));
		salaryHm.put("toDate", salaryListRs.getString("toDate"));
		salaryHm.put("firstName", salaryListRs.getString("firstName"));
		salaryHm.put("lastName", salaryListRs.getString("lastName"));
		salaryList.add(salaryHm);	
		
		
	}
	
	
	
	// 3. 출력

	
	
	
	
	
	

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
				<table border = 3>
					<tr>
						<th style = "background-color : aqua;">사원 번호</th>
						<th>연봉</th>
						<th>fromDate</th>
						<th>toDate</th>
						<th>firstName</th>
						<th>lastName</th>
					</tr>
					
					
					<%
						
						for(HashMap<String, Object> hm : salaryList) {
						
					%>
						
							<tr>
								<td><%=hm.get("empNo") %></td>
								<td><%=hm.get("salary") %></td>
								<td><%=hm.get("fromDate") %></td>
								<td><%=hm.get("toDate") %></td>
								<td><%=hm.get("firstName") %></td>
								<td><%=hm.get("lastName") %></td>
							</tr>
								
					<%		
						
						}
						
					%>
					
				
				</table>
			</div>
		
		
			<div>
				<span>현재 페이지 : </span>
				<span><%=currentPage %></span>
			</div>
		
		
			<div>
				<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currentPage=1">처음</a>
				<%
					if(currentPage > 1) {
				%>
						<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currnetPage=<%=currentPage - 1 %>">이전</a>
				<%
					}
				
					if(currentPage < lastPage) {
				%>
						<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currentPage=<%=currentPage + 1 %>">다음</a>
				<%
					}
				%>
				<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currentPage=<%=lastPage %>">마지막</a>
			
			</div>
		
		</div>
	
		
	</body>
</html>