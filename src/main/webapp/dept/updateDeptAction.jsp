<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<% 
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>

<%
	// 1. 요청 분석(Controller)
	
	// 수정 Form 에서 값 받아오기
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");

	// 받아온 deptNo, deptName 확인용 디버깅 코드
	System.out.println(deptNo + " <--deptNo");
	System.out.println(deptName + " <--deptName");
	
	// 2. 업무 처리(Model)
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// sql 쿼리
	String sql = "update departments set dept_name = ? where dept_no = ?";
	
	// sql 쿼리 실행 할 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
		
	// sql 쿼리 내의 ? 대입
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	// 쿼리 실행 후 완료한 쿼리 개수 반환하는 row
	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("쿼리 실행 완료");
	} else {
		System.out.println("쿼리 실행 완료");
	}
		
	
	// 3. 출력(View)
	// 수정 후 출력하기 위하여 deptList.jsp 재연결
	
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");


%>



