<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 인코딩 : UTF-8
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>부서 추가</title>
		
		<!-- Bootstrap5를 참조한다 시작-->
		
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		
		<!-- Bootstrap5를 참조한다 끝-->
		
		<!-- 외부 부트스트랩 템플릿 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/minty.css">
		
		
	</head>
	
	<body>
		<!--  -->
		<div>
			<div>
				<h2>부서 추가</h2>
			</div>

			<div>
				<form method = "post" action = "<%=request.getContextPath() %>/insertDeptAction.jsp">
					<table>
						<!-- 부서 이름 -->
						<tr>
							<td>부서 이름</td>
							<td>
								<input type = "text" name = "deptName">
							</td>
						</tr>
						
						<tr>
							<td colspan = "2">
								<button type = "submit">추가</button>
							</td>
						</tr>						
					</table>
				</form>
			</div>		
		</div>	
	</body>
</html>