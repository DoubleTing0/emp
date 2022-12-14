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
	String boardNo = request.getParameter("boardNo");
	String commentContent = request.getParameter("commentContent");
	String createdate = request.getParameter("createdate");
	String commentPw = request.getParameter("commentPw");
	
	if(commentNo == null || boardNo == null || commentContent == null || createdate == null || commentPw == null
			|| commentNo.equals("") || boardNo.equals("") || createdate.equals("")) {
		
		// 비밀번호와 내용은 공백이여도 괜찮다.
		String updateCommentMsg = URLEncoder.encode("모든 항목을 입력하세요", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		response.sendRedirect(request.getContextPath() + "/board/updateCommentForm.jsp?commentNo=" + commentNo + "&updateCommentMsg=" + updateCommentMsg);
		return;
		
		
	}

	
	
	// 2. 요청 처리
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// updateSql
	//	UPDATE comment SET comment_content = ? WHERE comment_no = ? AND board_no = ? AND comment_pw = ?
	String updateCommentSql = "UPDATE comment SET comment_content = ? WHERE comment_no = ? AND board_no = ? AND comment_pw = ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement updateCommentStmt = conn.prepareStatement(updateCommentSql);
	
	// updateSql ? 대입
	updateCommentStmt.setString(1, commentContent);
	updateCommentStmt.setInt(2, Integer.parseInt(commentNo));
	updateCommentStmt.setInt(3, Integer.parseInt(boardNo));
	updateCommentStmt.setString(4, commentPw);
	
	// 쿼리 실행 후 완료된 개수 반환하는 row
	int row = updateCommentStmt.executeUpdate();
	
	if(row == 1) {
		
		System.out.println("댓글 수정 완료");
		
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
		
		
	} else {
		System.out.println("댓글 수정 실패");
		
		String updateCommentMsg = URLEncoder.encode("비밀번호가 올바르지 않습니다.", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		response.sendRedirect(request.getContextPath() + "/board/updateCommentForm.jsp?commentNo=" + commentNo + "&updateCommentMsg=" + updateCommentMsg);
		return;
		
	}
	
	
	// 수정 확인하기 위해 boardOne.jsp 재연결
	
	
	




%>
