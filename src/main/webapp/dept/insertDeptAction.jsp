<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>

<%
	// 1. 요청 분석(Controller)
	
	// 부서 목록 값 입력 받아오기
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");

	// deptName 확인용 디버깅 코드
	System.out.println(deptName + " <-- deptName");

	// 2. 업무 처리(Model)
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 접속 확인용 디버깅 코드
	System.out.println(conn + " <-- conn");
	
	// sql 쿼리 
	String sql = "insert into departments (dept_no, dept_name) values (?, ?)";
	
	// sql 쿼리 전송 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// sql 내용 중 value ? 값 대입
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	
	// sql 실행 후 실행 완료된 쿼리 개수 반환
	int row = stmt.executeUpdate();
	
	// 쿼리 실행 확인용 디버깅 코드
	if(row == 1) {
		System.out.println("실행 완료");
	} else {
		System.out.println("실행 실패");
	}

	// 3. 출력(View)
	// 출력 따로 없으므로 deptList.jsp 부서목록 재연결
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
	

%>
