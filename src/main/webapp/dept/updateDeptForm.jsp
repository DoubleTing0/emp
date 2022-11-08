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
	</head>
	
	<body>
		<%
			// 1. 요청 분석(Controller)
			
			// 입력 받은 deptNO 저장
			String deptNo = request.getParameter("deptNo");
		
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
			String deptName = null;

			// rs에 있는 데이터 deptNo, deptName에 저장
			if(rs.next()) {
				deptName = rs.getString("deptName");
			}
			
			// 디버깅 확인용 코드
			System.out.println(deptNo + " <-- 쿼리 후 deptNo");
			System.out.println(deptName + " <-- 쿼리 후 deptName");
			
			// 3. 출력(View)
			// 수정하려는 부서의 번호와 이름을 수정 폼에 출력
			
			
		
		%>
	
			<div>
				<div>
					<h2>
						<span>부서 수정</span>
					</h2>
				</div>
				
				<div>
					<form method = "post" action = "<%=request.getContextPath() %>/dept/updateDeptAction.jsp">
						<table>
							<thead>
								<!-- 부서 번호 -->
								<tr>
									<td>부서 번호</td>
									<td>
										<input type = "text" name = "deptNo" value = "<%=deptNo %>">
									</td>
								</tr>
						
								<!-- 부서 이름 -->
								<tr>
									<td>부서 이름</td>
									<td>
										<input type = "text" name = "deptName" value = "<%=deptName %>">
									</td>
								</tr>
						
								<tr>
									<td colspan = "2">
										<button type = "submit">수정</button>
									</td>
								</tr>
						</table>
					
					</form>
				</div>
		
		
			</div>
		
	</body>
</html>