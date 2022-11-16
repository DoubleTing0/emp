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
	
	// 1-1 검색기능
	String deptEmpWord = request.getParameter("deptEmpWord");
	
	
	
	// 1-2 페이징 처리
	// 현재페이지 기본적으로 1
	int currentPage = 1;
	
	// 받아온 값이 있다면 대입
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 처음출력할 행
	int beginRow = (currentPage - 1) * rowPerPage;
	
	
			
	
	
	
	
	// 2. 요청 처리
	
	
	// Driver 및 DB 접속 준비
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	
	// 드라이버 로딩
	Class.forName(driver);
	
	// DB 접속
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	
	
	
	
	
	// 페이지 처리를 위한 초기화
	int count = 0;
	String cntSql = null;
	PreparedStatement cntStmt = null;
	ResultSet cntRs = null;
	int lastPage = 0;
	
	
	// list 출력을 위한 초기화
	String listSql = null;
	PreparedStatement listStmt = null;
	ResultSet listRs = null;
	
	
	// 2-1 검색 하지 않을때 전체 출력
	// 검색어가 null 일 떄 전체 출력
	if(deptEmpWord == null) {
		
		// cntSql
		// 전체 갯수니까 emp_no만 봐도 가능.
		cntSql = "SELECT COUNT(de.emp_no) cnt FROM dept_emp de";
		
		// cntSql 실행할 객체 생성
		cntStmt = conn.prepareStatement(cntSql);
		
		// ResultSet 에 저장
		cntRs = cntStmt.executeQuery();
		
		// 전체 갯수 count에 대입
		if(cntRs.next()) {
			count = cntRs.getInt("cnt");
		}
		
		// 마지막 페이지 구하기
		lastPage = count / rowPerPage;
		
		// 딱 떨어지지 않는다면 1페이지 추가해야 마지막페이지 출력
		if((count % rowPerPage) != 0) {
			lastPage += 1;
		}
		
		
		
		
		// listSql
		// employees, departments 테이블 INNER JOIN 후 전체 출력
		// SELECT de.emp_no empNo, e.first_name firstName, e.last_name lastName, d.dept_name deptName, de.from_date fromDate,
		// de.to_date toDate FROM dept_emp de 
		// INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no 
		// ORDER BY de.emp_no LIMIT ?, ?";
		
		
		listSql = "SELECT de.emp_no empNo, e.first_name firstName, e.last_name lastName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no LIMIT ?, ?";
		
		// listSql 실행할 객체 생성
		listStmt = conn.prepareStatement(listSql);
		
		// listSql 안의 ? 대입
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, rowPerPage);
	
		// listRs 에 저장
		listRs = listStmt.executeQuery();
		
		
		
	} else {
		// deptEmpWord != null : 검색할 경우
		
		
		// cntSql
		// 이름으로 검색하기 위해 employees 테이블 INNER JOIN 후 CONCAT 으로 이름 결합 후 COUNT 
		// SELECT COUNT(CONCAT(e.first_name, ' ', e.last_name)) cnt FROM dept_emp de 
		// INNER JOIN employees e ON de.emp_no = e.emp_no WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE ?
		cntSql = "SELECT COUNT(CONCAT(e.first_name, ' ', e.last_name)) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE ?";
		
		// cntSql 실행할 객체 생성
		cntStmt = conn.prepareStatement(cntSql);
		
		// cntSql 안의 ? 대입
		cntStmt.setString(1, "%" + deptEmpWord + "%");
		
		// ResultSet 에 저장
		cntRs = cntStmt.executeQuery();
		
		// 전체 갯수 count에 대입
		if(cntRs.next()) {
			count = cntRs.getInt("cnt");
		}
		
		// 마지막 페이지 구하기
		lastPage = count / rowPerPage;
		
		// 딱 떨어지지 않는다면 1페이지 추가해야 마지막페이지 출력
		if((count % rowPerPage) != 0) {
			lastPage += 1;
		}
		
		
		
		
		// listSql
		// employees, departments 테이블 INNER JOIN 후 CONCAT 으로 이름 결합 후 검색한 결과 출력
		
		// SELECT de.emp_no empNo, CONCAT(e.first_name, ' ', e.last_name) name, d.dept_name deptName, de.from_date fromDate, 
		// de.to_date toDate FROM dept_emp de 
		// INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no 
		// WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE ? ORDER BY de.emp_no ASC LIMIT ?, ?";
		
		listSql = "SELECT de.emp_no empNo, e.first_name firstName, e.last_name lastName, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE ? ORDER BY de.emp_no ASC LIMIT ?, ?";
		
		// listSql 실행할 객체 생성
		listStmt = conn.prepareStatement(listSql);
		
		// listSql 안의 ? 대입
		listStmt.setString(1, "%" + deptEmpWord + "%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, rowPerPage);
	
		// listRs 에 저장
		listRs = listStmt.executeQuery();
		
		
	}
	
	
	
	// ResultSet 대신 일반적인 사용을 위해 ArrayList에 저장
	// HashMap 사용하여 저장
		ArrayList<HashMap<String, Object>> deptEmpList = new ArrayList<HashMap<String, Object>>();
		while(listRs.next()) {
			// HashMap 객체 생성
			HashMap<String, Object> deptEmpHm = new HashMap<String, Object>();
			
			// list 결과 HashMap에 담은 후 ArrayList 에 저장
			deptEmpHm.put("empNo", listRs.getInt("empNo"));
			deptEmpHm.put("firstName", listRs.getString("firstName"));
			deptEmpHm.put("lastName", listRs.getString("lastName"));
			deptEmpHm.put("deptName", listRs.getString("deptName"));
			deptEmpHm.put("fromDate", listRs.getString("fromDate"));
			deptEmpHm.put("toDate", listRs.getString("toDate"));
					
			deptEmpList.add(deptEmpHm);
			
			
		}
		

		// 사용 끝나면 종료
		cntStmt.close();
		listStmt.close();
		conn.close();
		
	
	
	
	
	
	
	
	
	// 3. 출력
	
	
	
	

%>



<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>사원 부서 관리</title>
		
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
					<span class = "badge bg-success">사원 부서 관리</span>
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
		
		
		
			<!-- 결과 출력 -->
			<div class = "row justify-content-center">
				<table class = "table table-borderless w-auto text-center">
					<thead class = "table-active">
						<tr>
							<th>사원 번호</th>
							<th>사원 이름</th>
							<th>부서 번호</th>
							<th>시작일</th>
							<th>종료일</th>
						</tr>
					</thead>
					
					<!-- foreach문 사용하여 출력 -->
					<!-- 이름은 합쳐서 출력 -->
					<tbody>
						<%
							for(HashMap<String, Object> hm : deptEmpList) {
						%>
								<tr>
									<td><%=hm.get("empNo") %></td>
									<td><%=hm.get("firstName") + " " + hm.get("lastName") %></td>
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
		
			<div>&nbsp;</div>
			
			<!-- 검색 기능 구현 -->
			<div class = "text-center">
				<form method = "post" action = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp">
					<label for = "deptEmpWord">사원 이름 : </label>
					
					<%
						if(deptEmpWord == null) {
					%>
							<input type = "text" name = "deptEmpWord" id = "deptEmpWord">
					<% 
						} else {
					%>
							<input type = "text" name = "deptEmpWord" id = "deptEmpWord" value = "<%=deptEmpWord %>">
					<%
						}
					%>
				
					<button type = "submit">검색</button>
				</form>
			</div>
		
			
			<div>&nbsp;</div>
			
			<!-- 페이징 처리 -->
			<div class = "text-center">
				<span>현재 페이지 : <%=currentPage %></span>
			</div>
			
			<div class = "text-center">
			
				<%
					if(deptEmpWord == null) {
				%>
						<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=1">처음 </a>
						<%
							if(currentPage > 1) {
						%>
								<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage - 1%>">이전 </a>
						<%					
							}
						
							if(currentPage < lastPage) {
						%>
								<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage + 1%>">다음 </a>
						<%						
							}
						%>
						<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage %>">마지막 </a>
				<%		
					} else {
				%>
				
						<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=1&deptEmpWord=<%=deptEmpWord %>">처음 </a>
						<%
							if(currentPage > 1) {
						%>
								<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage - 1%>&deptEmpWord=<%=deptEmpWord %>">이전 </a>
						<%					
							}
						
							if(currentPage < lastPage) {
						%>
								<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage + 1%>&deptEmpWord=<%=deptEmpWord %>">다음 </a>
						<%						
							}
						%>
						<a href = "<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage %>&deptEmpWord=<%=deptEmpWord %>">마지막 </a>
				<%
					}
				%>
			</div>
		
		</div>	
	

		
	</body>
</html>