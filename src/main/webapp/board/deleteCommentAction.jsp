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
	
	String boardNo = request.getParameter("boardNo");
	String commentNo = request.getParameter("commentNo");
	String commentPw = request.getParameter("commentPw");
	
	// 디버깅 코드
	System.out.println(boardNo + " <-- dCA boardNo");
	System.out.println(commentPw + " <-- dCA commentPw");
	
	if(boardNo == null || boardNo.equals("") || commentNo == null || commentNo.equals("")) {
		response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
		return;
	}
	
	// 2. 요청 처리
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// deleteSql
	String deleteSql = "DELETE FROM comment WHERE board_no = ? AND comment_no = ? AND comment_pw = ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	
	// deleteSql 에 ? 대입
	deleteStmt.setInt(1, Integer.parseInt(boardNo));
	deleteStmt.setInt(2, Integer.parseInt(commentNo));
	deleteStmt.setString(3, commentPw);
	
	// 쿼리 실행 후 완료된 쿼리 개수 반환
	int row = deleteStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("댓글 삭제 완료");
		// 삭제 후 글 상세보기 재연결
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
		
	} else {
		System.out.println("댓글 삭제 실패");
		String delCommentMsg = URLEncoder.encode("비밀번호가 올바르지 않습니다.", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		
		// response.sendRedirect(request.getContextPath() + "/board/deleteCommentForm.jsp?boardNo=" + boardNo
		// + "commentNo=" + commentNo + "&delCommentMsg=" + delCommentMsg);
		response.sendRedirect(request.getContextPath() + "/board/deleteCommentForm.jsp?boardNo=" + boardNo + "&commentNo=" + commentNo + "&delCommentMsg=" + delCommentMsg);
		return;
	}
	
	


%>

