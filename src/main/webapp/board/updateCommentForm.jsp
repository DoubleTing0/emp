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
	</head>
	
	<body>
		<div>
			
			
			댓글 수정
			
			
			<div>
				<form method = "post" action = "<%=request.getContextPath() %>/board/updateCommentAction.jsp">
					<div>
						<input type = "hidden" name = "boardNo" value = "<%=c.boardNo %>">
					
						<table>
							<tr>
								<th>댓글 번호</th>
								<td>
									<input type = "text" name = "commentNo" value = "<%=c.commentNo %>" readonly = "readonly">
								</td>
							</tr>
						
							<tr>
								<th>댓글 내용</th>
								<td>
									<textarea row = "5" cols = "40" name = "commentContent"><%=c.commentContent %></textarea>
								</td>
							</tr>
						
							<tr>
								<th>댓글 등록일</th>
								<td>
									<input type = "text" name = "createdate" value = "<%=c.createdate %>" readonly = "readonly">
								</td>
							</tr>
							
							<tr>
								<th>비밀번호</th>
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