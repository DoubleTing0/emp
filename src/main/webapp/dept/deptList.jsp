<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>부서 목록</title>
		
		<!-- Bootstrap5를 참조한다 시작-->
		
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		
		<!-- Bootstrap5를 참조한다 끝-->
		
		<!-- 외부 부트스트랩 템플릿 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/minty.css">
		
		<style>
			a:link {
			  text-decoration : none;
			  color : gray;
			}
			
			a:visited {
			  text-decoration : none;
			  color : gray;
			}
			
			a:hover {
			  text-decoration : none;
			  color : black;
			}
			
			a:active {
			  text-decoration : none;
			}
			
			th, td {
				border : 1px solid grey;
			}
			
			table th:first-child,
			table td:first-child {
				border-left: 0;
			}
			table th:last-child,
			table td:last-child {
				border-right: 0;
			}
			
		</style>
		
		
		
		
	</head>
	
	<body>
		<%
			// 1. 요청 분석(Controller)  --> 넘겨진 값을 분석하고 처리하는 부분
			
			
			// 2. 업무처리(Model)  --> 모델데이터(단일값 or 자료 구조 형태(배열, 리스트, 등))
			
			// 드라이버 로딩
			Class.forName("org.mariadb.jdbc.Driver");
		
			// DB 접속
			Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
			
			// sql 문
			String sql = "select dept_no deptNo, dept_name deptName from departments order by dept_no desc";
			
			// sql 쿼리 실행시킬 수 있는 객체 생성
			PreparedStatement stmt = conn.prepareStatement(sql);
			
			// ResultSet 에 저장
			// 모델 데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다.
			// ResultSet rs라는 모델자료구조를 좀더 일반적이고 독립적인 자료구조로 변경을 하자
			ResultSet rs = stmt.executeQuery();
			
			// ResultSet의 API(사용방법)를 모른다면 사용할 수 없는 반복문

			ArrayList<Department> list = new ArrayList<Department>();
			
			
			// list에 저장
			while(rs.next()) {
				Department d = new Department();
				d.deptNo = rs.getString("deptNo");
				d.deptName = rs.getString("deptName");
				list.add(d);
			}
			
			// 3. 출력(View) --> 모델 데이터를 고객이 원하는 형태로 출력  --> 뷰(리포트)
			
		%>
		
			<!-- 부서 목록 출력 -->
		
			<div class = "container">
			
				<div>&nbsp;</div>
			
				<div class = "text-center">
					<h1>
						<span class = "badge badge-pill bg-success">부서 목록</span>
					</h1>
				</div>
				
				<div>&nbsp;</div>
				
				<!-- 부서 추가 버튼 -->
				<div class = "text-center"> 
					<h3>
						<span class = "badge bg-secondary">
							<a href = "<%=request.getContextPath() %>/dept/insertDeptForm.jsp">부서 추가</a>
						</span>
					</h3>
				</div>
				
				<div>&nbsp;</div>
				
				<div class = "row justify-content-center">
					
					<!-- 부서 목록 출력(부서번호 내림차순으로) -->
					<table class = "table table-borderless w-auto text-center"">
						<thead class = "table-info">
							<tr>
								<th>부서 번호</th>
								<th>부서 이름</th>
								<th>수정</th>
								<th>삭제</th>
							</tr>
						</thead>
					
						<tbody class = "table-active">
							<%
								for(Department d : list) {
							%>
									<tr>
										<td><%=d.deptNo %></td>
										<td><%=d.deptName %></td>
										<td>
											<a href = "">수정</a>
										</td>
										<td>
											<a href = "">삭제</a>
										</td>
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