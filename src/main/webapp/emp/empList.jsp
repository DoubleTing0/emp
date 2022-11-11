<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
	}

	// 2. 업무 처리
	
	int rowPerPage = 10;
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	
	// lastPage 처리
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	
	int count = 0;
	if(countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}
		
	int lastPage = count / rowPerPage;
	if((count % rowPerPage) != 0) {
		lastPage += 1;
	}
	
	// 한 페이지당 출력할 emp 목록

	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
	
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	
	empStmt.setInt(1, rowPerPage * (currentPage - 1));
	empStmt.setInt(2, rowPerPage);
	
	ResultSet empRs = empStmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()) {
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
	}
	
	
%>	
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>사원 관리</title>
		
		<!-- Bootstrap5를 참조한다 시작-->
		
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		
		<!-- Bootstrap5를 참조한다 끝-->
		
		<!-- 외부 부트스트랩 템플릿 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/minty.css">
		
		<!-- 앵커 태그 외부 css 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/anchor.css">
		
		<!-- 테이블 외부 css 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/table.css">
		
	</head>
	
	<body>
		<div class = "container">
			<div>&nbsp;</div>
				
			<div class = "text-center">
				<h1>
					<span class = "badge bg-success">사원 관리</span>
				</h1>
			</div>
			
			<div>&nbsp;</div>

			<!-- 메뉴 partical jsp 구성 -->
			<div>
				<!-- include 주체는 서버라서 경로를 서버기준으로 생각해야한다.
					 request.getContextPath() 쓰지마라. 
					 이미 같이 안에 있기 때문에 context path를 가져올 필요가 없다.-->
				<jsp:include page = "/inc/menu.jsp"></jsp:include>
			</div>
			
			<div>&nbsp;</div>
		
			<div class = "row justify-content-center">
				<table class = "table table-borderless w-auto text-center">
					<thead class = "table-active">
						<tr>
							<th>사원 번호</th>	
							<th>퍼스트네임</th>	
							<th>라스트네임</th>	
						</tr>
					</thead>
					
					<tbody>
						<%
							for(Employee e : empList) {
						%>
								<tr>
									<td><%=e.empNo %></td>
									<td>
										<a href = "">
											<%=e.firstName %></td>
										</a>
									<td><%=e.lastName %></td>
								</tr>
						<%
							}				
						%>
					</tbody>
							
				</table>
			
			</div>
			
			
			
			
			
			<div class = "text-center">현재 페이지 : <%=currentPage %></div>
		
			<!-- 페이징 코드 -->
			<div class = "text-center">
				<a href = "<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
				<%
					if(currentPage > 1) {
				%>					
						<a href = "<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage - 1%>">이전</a>
				<%
					}
				
					if(currentPage < lastPage) {
				%>						
						<a href = "<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage + 1%>">다음</a>
				<%	
					}
				
				%>
				<a href = "<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
			</div>
		
		
		
		</div>
	
	
	
	
	
	
	
	
	
	
	</body>
</html>