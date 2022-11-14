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
	String commentNo = request.getParameter("commentNo");
	String updateCommentMsg = request.getParameter("updateCommentMsg");
	
	// 2. 요청 처리

	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// sql
	//	SELECT board_no boardNo, comment_pw commentPw, comment_content commentContent, createdate 
	// 	FROM comment WHERE comment_no = ?
	String sql = "SELECT board_no boardNo, comment_pw commentPw, comment_content commentContent, createdate FROM comment WHERE comment_no = ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// sql ? 대입
	stmt.setInt(1, Integer.parseInt(commentNo));
	
	// ResultSet 에 저장
	ResultSet rs = stmt.executeQuery();
	
	Comment c = null;
	if(rs.next()) {
		c = new Comment();
		c.commentNo = Integer.parseInt(commentNo);
		c.boardNo = rs.getInt("boardNo");
		c.commentPw = rs.getString("commentPw");
		c.commentContent = rs.getString("commentContent");
		c.createdate = rs.getString("createdate");
	}



%>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>댓글 수정</title>
		
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
					<span class = "badge bg-success">댓글 수정</span>
				</h1>
			</div>
			
			<div>&nbsp;</div>
			
			<div class = "text-center text-danger">
				<%
					if(updateCommentMsg != null) {
				%>
						<%=updateCommentMsg %>
				<%
					}
				%>
			
			</div>
			
			
			<div>
				<form method = "post" action = "<%=request.getContextPath() %>/board/updateCommentAction.jsp">
					<div class = "row justify-content-center">
						<input type = "hidden" name = "boardNo" value = "<%=c.boardNo %>">
					
						<table class = "table table-borderless w-auto text-center">
							<tr>
								<th class = "table-active">댓글 번호</th>
								<td>
									<input type = "text" name = "commentNo" value = "<%=c.commentNo %>" readonly = "readonly">
								</td>
							</tr>
						
							<tr>
								<th class = "table-active">댓글 내용</th>
								<td>
									<textarea row = "5" cols = "40" name = "commentContent"><%=c.commentContent %></textarea>
								</td>
							</tr>
						
							<tr>
								<th class = "table-active">댓글 등록일</th>
								<td>
									<input type = "text" name = "createdate" value = "<%=c.createdate %>" readonly = "readonly">
								</td>
							</tr>
							
							<tr>
								<th class = "table-active">비밀번호</th>
								<td>
									<input type = "password" name = "commentPw">
								</td>
						</table>
			
					</div>
					
					<div class = "text-center">
						<h3>
							<button type = "submit" class = "badge bg-info" style = "border:0; outline:0">댓글수정</button>
						</h3>
					</div>
					
					
				</form>
			
			</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		</div>
	</body>
</html>