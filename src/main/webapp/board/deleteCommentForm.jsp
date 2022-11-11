<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>


<%
	// 1. 요청 분석
	String boardNo = request.getParameter("boardNo");
	String commentNo = request.getParameter("commentNo");

	// 디버깅 코드
	System.out.println(boardNo + "<-- dCF boardNo");
	
	String delCommentMsg  = request.getParameter("delCommentMsg");
%>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>댓글 삭제</title>
		
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
					<span class = "badge bg-success">댓글 삭제</span>
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
			
			
			<div class = "text-center text-danger">
				<%
					if(delCommentMsg != null) {
				%>
						<span><%=delCommentMsg %></span>
				<%
					}
				%>
			</div>
			
			
			
			<div>
				<form method = "post" action = "<%=request.getContextPath()%>/board/deleteCommentAction.jsp">
					<input type = "hidden" name = "boardNo" value = "<%=boardNo %>">
					<input type = "hidden" name = "commentNo" value = "<%=commentNo %>">
					<div class = "row justify-content-center">
						<table class = "table table-borderless w-auto text-center">
							<tr>
								<td class = "table-active">비밀번호</td>
								<td>
									<input type = "password" name = "commentPw">
								</td>
							</tr>
						</table>
					</div>
				
					<div class = "text-center">
						<h4>
							<button type = "submit" class = "badge bg-info" style = "border:0; outline:0">댓글삭제</button>
						</h4>
					</div>
				</form>
			</div>
		
		
		
		
		
		
		
		
		
		</div>
		
		
		
	</body>
</html>