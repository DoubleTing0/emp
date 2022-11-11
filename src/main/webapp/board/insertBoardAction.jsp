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
	// 1. 요청 분석(Controller)
	String boardWriter = request.getParameter("boardWriter");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	// 공백 값 입력 받아오면 insertBoardForm.jsp  재연결 후 코드 종료
	if(boardWriter == null || boardTitle == null || boardContent == null 
			|| boardWriter.equals("") || boardTitle.equals("") || boardContent.equals("")) {
		String msg = URLEncoder.encode("이름, 제목, 내용을 모두 입력하세요.", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		response.sendRedirect(request.getContextPath() + "/board/insertBoardForm.jsp?msg=" + msg);
		return;
	}
	
	
	
	
	// 2. 요청 처리(Model)
	
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// insertSql
	// board_pw 초기값이 없으므로 넣어줘야한다. 일단 1234로 통일하기로 했음
	String insertSql = "INSERT INTO board (board_pw, board_writer, board_title, board_content, createdate) VALUES (1234, ?, ?, ?, CURDATE())";
	
	// 쿼리 실행 할 객체 생성
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	
	// insertSql 의 ? 대입
	insertStmt.setString(1, boardWriter);		
	insertStmt.setString(2, boardTitle);		
	insertStmt.setString(3, boardContent);		

	// 쿼리 실행 후 완료한 쿼리 갯수 반환하는 row
	int row = insertStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("쿼리 실행 완료");
	} else {
		System.out.println("쿼리 실행 실패");
	}
	
	
	
	
	// 3. 출력(View)
	// 출력은 따로 없고 boardList.jsp 재연결
	response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");



%>