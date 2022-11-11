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
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String createdate = request.getParameter("createdate");
	String boardPw = request.getParameter("boardPw");
	
	System.out.println(boardNo + " <-- boardNo");
	
	if(boardNo == null || boardTitle == null || boardContent == null || boardWriter == null || createdate == null 
			|| boardPw == null || boardNo.equals("") || boardTitle.equals("") || boardContent.equals("") || boardWriter.equals("") 
			|| createdate.equals("") || boardPw.equals("")) {
		String msg = URLEncoder.encode("모든 항목을 빠짐없이 입력해주세요.", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo=" + boardNo + "&&msg=" + msg);
		return;
		
	}
	
	
	// 2. 요청 처리
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// updateSql
	// UPDATE board SET board_title = ?, board_content = ?, board_writer = ?
	// WHERE board_no = ? AND board_pw = ?
	String updateSql = "UPDATE board SET board_title = ?, board_content = ?, board_writer = ? WHERE board_no = ? AND board_pw = ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	
	// updateSql 에 ? 대입
	updateStmt.setString(1, boardTitle);		
	updateStmt.setString(2, boardContent);		
	updateStmt.setString(3, boardWriter);		
	updateStmt.setInt(4, Integer.parseInt(boardNo));		
	updateStmt.setString(5, boardPw);		
	
	// 쿼리 실행 후 실행한 쿼리 개수 반환
	int row = updateStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("쿼리 실행 완료");
	} else {
		System.out.println("쿼리 실행 실패");
		
		// 비밀번호가 다르면 수정이 안되고 문구 보여주기
		String msgPw = URLEncoder.encode("비밀번호가 올바르지 않습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?boardNo=" + boardNo + "&&msg=" + msgPw);
		return;
		
	}
	
	
	// 3. 출력(View)
	// 수정 후 결과를 보여주기 위해서 boardList.jsp 재연결
	response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
	

%>

