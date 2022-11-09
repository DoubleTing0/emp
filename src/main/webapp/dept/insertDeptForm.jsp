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
		
		
		<style>
			table, tr, th, td {
				border : 1px solid gray;
			}
			
			
		
		</style>
		
		
		
	</head>
	
	<body>
		<!--  -->
		<div class = "container">
		
			<div>&nbsp;</div>
		
			<div class = "text-center">
				<h1>
					<span class = "badge bg-success">부서 추가</span>
				</h1>
			</div>

			<div>&nbsp;</div>

			<div>
				<form method = "post" action = "<%=request.getContextPath() %>/dept/insertDeptAction.jsp">
					<div class = "row justify-content-center">
						<table class = "table table-borderless w-auto text-center">
							<!-- 부서 번호 -->
							<tr>
								<th class = "table-active">부서 번호</th>
								<td>
									<input type = "text" name = "deptNo">
								</td>
							</tr>
							
							<!-- 부서 이름 -->
							<tr>
								<th class = "table-active">부서 이름</th>
								<td>
									<input type = "text" name = "deptName">
								</td>
							</tr>
							
							<tr>
								<td colspan = "2">
									<h3>
										<button type = "submit" class = "badge bg-info" style = "border:0; outline:0">추가</button>
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