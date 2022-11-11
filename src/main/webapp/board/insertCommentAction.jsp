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
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	if(boardNo == null || commentContent == null || commentPw == null || commentContent.equals("") || commentPw.equals("")) {
		String commentMsg = URLEncoder.encode("댓글내용과 비밀번호를 입력하세요", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo + "&&commentMsg=" + commentMsg);
		return;
	}
	
	
	
	// 2. 요청 처리
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// insertSql
	String insertSql = "INSERT INTO comment (board_no, comment_pw, comment_content, createdate) VALUES (?, ?, ?, CURDATE())";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	
	// insertSql ? 대입
	insertStmt.setInt(1, Integer.parseInt(boardNo));
	insertStmt.setString(2, commentPw);
	insertStmt.setString(3, commentContent);
	
	// 쿼리 실행 후 검사
	int row  = insertStmt.executeUpdate();
	if(row == 1) {
		System.out.println("댓글 등록 완료");
	} else {
		System.out.println("댓글 등록 실패");
	}
	
	// boardOne.jsp rediriect
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
%>

