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
	
	
	String salaryWord = request.getParameter("salaryWord");	
	
	// 디버깅 코드
	System.out.println(salaryWord + " <-- salaryWord");
	
	// 2. 요청 처리
	
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	// 드라이버 로딩
	Class.forName(driver);
	
	// DB 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	
	

	
	// salaryWord 값에 따른 분기
	
	String cntSalarySql = null;
	PreparedStatement cntSalaryStmt = null;
	
	if(salaryWord == null) {
		
		// 2-1 count 쿼리
		cntSalarySql = "SELECT COUNT(s.emp_no) cnt FROM salaries s";
		
		// 쿼리 실행할 객체 생성
		cntSalaryStmt = conn.prepareStatement(cntSalarySql);
		
	} else {
		
		// firstName 이나 lastName을 검색했을때
		cntSalarySql = "SELECT COUNT(CONCAT(e.first_name, ' ', e.last_name)) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE ?";
		
		// 쿼리 실행할 객체 생성
		cntSalaryStmt = conn.prepareStatement(cntSalarySql);
		
		cntSalaryStmt.setString(1, "%" + salaryWord + "%");
		
		
		
	}
	
	
	
	
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
	
	// 디버깅 코드
	System.out.println(count + " <-- count");
	System.out.println(lastPage + " <-- lastPage");
	
	
	
	
	// 2-2 List 쿼리
	
	// salaryWord 값에 따른 분기
	
	String salaryListSql = null;
	PreparedStatement salaryListStmt = null;
	
	if(salaryWord == null) {
		
		
		salaryListSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		
		// 쿼리 실행할 객체 생성
		salaryListStmt = conn.prepareStatement(salaryListSql);
		
		// salaryListSql ? 대입
		salaryListStmt.setInt(1, beginRow);
		salaryListStmt.setInt(2, ROW_PER_PAGE);
		
	} else {
		// 검색할 때
		salaryListSql = 
			"SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		
		// 쿼리 실행할 객체 생성
		salaryListStmt = conn.prepareStatement(salaryListSql);
		
		// salaryListSql ? 대입
				
		salaryListStmt.setString(1, "%" + salaryWord + "%");		
		salaryListStmt.setInt(2, beginRow);
		salaryListStmt.setInt(3, ROW_PER_PAGE);
		
		
		
		
		
	}
	
	
	
	// ResultSet에 저장
	ResultSet salaryListRs = salaryListStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> salaryList = new ArrayList<HashMap<String, Object>>();
	
	while(salaryListRs.next()) {
		HashMap<String, Object> salaryHm = new HashMap<String, Object>();
		salaryHm.put("empNo", salaryListRs.getInt("empNo"));
		salaryHm.put("salary", salaryListRs.getInt("salary"));
		salaryHm.put("fromDate", salaryListRs.getString("fromDate"));
		salaryHm.put("toDate", salaryListRs.getString("toDate"));
		salaryHm.put("name", salaryListRs.getString("name"));
		salaryList.add(salaryHm);	
		
		
		
	}
	
	
	
	// 3. 출력
	// 디버깅 코드
	
	
	salaryListStmt.close();
	conn.close();
	

%>





<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>급여 관리</title>
		
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
					<span class = "badge bg-success">급여 관리</span>
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
					<thead>
						<tr>
							<th class = "table-active">사원 번호</th>
							<th class = "table-active">이름</th>
							<th class = "table-active">연봉</th>
							<th class = "table-active">시작일</th>
							<th class = "table-active">종료일</th>
						</tr>
					</thead>
					
					<tbody>
						<%
							for(HashMap<String, Object> hm : salaryList) {
							
						%>
							
							<tr>
								<td><%=hm.get("empNo") %></td>
								<td><%=hm.get("name") %></td>
								<td><%=hm.get("salary") %></td>
								<td><%=hm.get("fromDate") %></td>
								<td><%=hm.get("toDate") %></td>
							</tr>
									
						<%		
							
							}
							
						%>
					</tbody>
				
				</table>
			</div>
		
			<div>&nbsp;</div>
			
			<!-- 검색 기능 구현 -->
			<div class = "text-center">
				<form method = "post" action = "<%=request.getContextPath() %>/salary/salaryList2.jsp">
					<label for = "salaryWord">사원 이름 : </label>
					
					<%
						if(salaryWord == null) {
					%>
							<input type = "text" name = "salaryWord" id = "salaryWord">
					<% 
						} else {
					%>
							<input type = "text" name = "salaryWord" id = "salaryWord" value = "<%=salaryWord %>">
					<%
						}
					%>
					
					
					<button type = "submit">검색</button>
				</form>
			</div>
			
			<div>&nbsp;</div>
			
		
			<!-- 페이징 처리 -->
			<div class = "text-center">
				<span>현재 페이지 : </span>
				<span><%=currentPage %></span>
			</div>
		
			<%
				if(salaryWord == null) {
			%>
					<div class = "text-center">
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
			<%		
				} else {
			%>
					<!-- 검색했을때 -->
					<div class = "text-center">
						<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currentPage=1&salaryWord=<%=salaryWord %>">처음</a>
						<%
							if(currentPage > 1) {
						%>
								<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currnetPage=<%=currentPage - 1 %>&salaryWord=<%=salaryWord %>">이전</a>
						<%
							}
						
							if(currentPage < lastPage) {
						%>
								<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currentPage=<%=currentPage + 1 %>&salaryWord=<%=salaryWord %>">다음</a>
						<%
							}
						%>
						<a href = "<%=request.getContextPath() %>/salary/salaryList2.jsp?currentPage=<%=lastPage %>&salaryWord=<%=salaryWord %>">마지막</a>
					
					</div>
					
			<%
				}
			%>
		
		</div>
	
		
	</body>
</html>