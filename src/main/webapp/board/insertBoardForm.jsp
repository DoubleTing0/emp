<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>글 쓰기</title>
		
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
		<!-- 출력 -->
		<div class = "container">
		
			<div>&nbsp;</div>
		
			<div class = "text-center">
				<h1>
					<span class = "badge bg-success">글 쓰기</span>
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
				<form method = "post" action = "<%=request.getContextPath() %>/board/insertBoardAction.jsp">
					<div class = "row justify-content-center">
						<table class = "table table-borderless w-auto text-center">
							
							<!-- 이름 -->
							<tr>
								<th class = "table-active">이름</th>
								<td>
									<input type = "text" name = "boardWriter">
								</td>
							</tr>
							
							<!-- 제목 -->
							<tr>
								<th class = "table-active">제목</th>
								<td>
									<input type = "text" name = "boardTitle">
								</td>
							</tr>
							
								
							<!-- 내용 -->
							<tr>
								<th class = "table-active">내용</th>
								<td>
									<textarea rows = "5" cols = "40" name = "boardContent"></textarea>
								</td>
							</tr>
																				
							<tr>
								<td colspan = "2">
									<h3>
										<button type = "submit" class = "badge bg-info" style = "border:0; outline:0">등록</button>
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