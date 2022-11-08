<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>


<%
	// 1. 요청 분석(Controller)
	
	// 삭제할 부서의 deptNo 받아오기
	String deptNo = request.getParameter("deptNo");

	// deptNo 확인용 디버깅 코드
	System.out.println(deptNo + " <-- deptNo");
	
	
	// 2. 업무 처리(Model)
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// sql 쿼리
	String sql = "delete from departments where dept_no = ?";
	
	// sql 쿼리 실행하는 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// sql 쿼리 중 ? 대입
	stmt.setString(1, deptNo);
	
	// 쿼리 실행 후 쿼리 실행 완료한 개수 반환하는 row
	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("쿼리 실행 완료");
	} else {
		System.out.println("쿼리 실행 실패");
		
	}
	
	// 3. 출력(View)
	// 삭제 후의 부서 목록 보여줘야 하므로 deptList.jsp 재연결
	
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");


%>
