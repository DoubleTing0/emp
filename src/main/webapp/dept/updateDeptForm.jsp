<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>부서 수정</title>
		
		<!-- Bootstrap5를 참조한다 시작-->
		
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		
		<!-- Bootstrap5를 참조한다 끝-->
		
		<!-- 외부 부트스트랩 템플릿 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/minty.css">
		
		<style>
			table, tr, th, td {
				border : 1px solid gray;
			}
			
			
		
		</style>
		
	</head>
	
	<body>
		<%
			// 1. 요청 분석(Controller)
			
			// 입력 받은 deptNO 저장
			String deptNo = request.getParameter("deptNo");
		
			if(deptNo == null) {
				// 주소창으로 직접 입력하여 들어오면 deptNo 가 null 이되므로 deptList.jsp 로 재연결 후 코드 종료
				response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
				return;
			}
		
			// deptNo 디버깅 확인용 코드
			System.out.println(deptNo + " <--deptNo");
			
			
			
			// 2. 업무 처리(Model)
			
			// 드라이버 로딩
			Class.forName("org.mariadb.jdbc.Driver");
			
			// DB 접속
			Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
			
			// sql 쿼리
			String sql = "select dept_name deptName from departments where dept_no = ?";
			
			// sql 쿼리 실행할 객체 생성
			PreparedStatement stmt = conn.prepareStatement(sql);
			
			// sql 쿼리 내 ? 대입
			stmt.setString(1, deptNo);
			
			// ResultSet rs에 부서 번호 이름 저장
			ResultSet rs = stmt.executeQuery();
			
			// 출력에 사용하기 위하여 if문 밖에서 사용할 변수 초기화
			Department d = null;

			// rs에 있는 데이터 Department d 에 저장
			if(rs.next()) {
				d = new Department();
				d.deptNo = deptNo;
				d.deptName = rs.getString("deptName");
			}
			
			// 디버깅 확인용 코드
			System.out.println(d.deptNo + " <-- 쿼리 후 d.deptNo");
			System.out.println(d.deptName + " <-- 쿼리 후 d.deptName");
			
			// 3. 출력(View)
			// 수정하려는 부서의 번호와 이름을 수정 폼에 출력
			
			
		
		%>
	
			<div class = "container">
				
				<div>&nbsp;</div>
				
				<div class = "text-center">
					<h1>
						<span class = "badge bg-success">부서 수정</span>
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
				
				<!-- 부서번호 부서이름 공백일 경우 msg 출력 -->
				<%
					if(request.getParameter("msg") != null) {
				%>
						<div class = "text-center text-danger">
							<%=request.getParameter("msg")%>
						</div>
				<%
					}
				%>
				
				<div>
					<form method = "post" action = "<%=request.getContextPath() %>/dept/updateDeptAction.jsp">
						<div class = "row justify-content-center">
							<table class = "table table-borderless w-auto text-center">
									<!-- 부서 번호는 수정할 수 없도록 readonly 속성 사용 -->
									<tr>
										<th  class = "table-active">부서 번호</th>
										<td>
											<input type = "text" name = "deptNo" value = "<%=d.deptNo %>" readonly = "readonly">
										</td>
									</tr>
									<!-- 부서 이름 -->
									<tr>
										<th class = "table-active">부서 이름</th>
										<td>
											<input type = "text" name = "deptName" value = "<%=d.deptName %>">
										</td>
									</tr>
							
									<tr>
										<td colspan = "2">
											<h3>
												<button type = "submit" class = "badge bg-info" style = "border:0; outline:0">수정</button>
											</h3>
											
										</td>
									</tr>
							</table>
						</div>
					</form>
				</div>
		
		
			</div>
		
	</body>
</html>