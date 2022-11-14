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
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	String boardPw = request.getParameter("boardPw");
	
	
	// 2. 업무 처리
	
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");

	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// deleteSql
	String deleteSql = "DELETE FROM board WHERE board_no = ? AND board_pw = ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	
	// deleteSql 에 ? 대입
	deleteStmt.setInt(1, boardNo);
	deleteStmt.setString(2, boardPw);
	
	
	int row = deleteStmt.executeUpdate();
	if(row == 1) {
		response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
	} else {
		String msg = URLEncoder.encode("비밀번호가 올바르지 않습니다.", "UTF-8");
		
		response.sendRedirect(request.getContextPath() + "/board/deleteBoardForm.jsp?boardNo=" + boardNo + "&msg=" + msg);
	}
		
		
	// 3. 출력




%>
