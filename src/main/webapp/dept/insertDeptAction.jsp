<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*" %>
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
	
	// 공백 값 입력 받아오면 insertDeptForm.jsp  재연결 후 코드 종료
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요.", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm.jsp?msg=" + msg);
		return;
	}
	
	// deptName 확인용 디버깅 코드
	System.out.println(deptNo + " <-- deptNo");
	System.out.println(deptName + " <-- deptName");

	// 2. 업무 처리(Model)
	
	// 이미 존재하는 key(dept_no)값이 동일한 값이 입력되면(중복되면) 예외(에러)가 발생한다.
	// 동일한 dept_no값이 입력되었을 때 예외가 발생
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 접속 확인용 디버깅 코드
	System.out.println(conn + " <-- conn");
	
	// 2-1 dept_no 중복 검사
	// 입력 추가 하기 전에 동일한 dept_no 가 있는지 확인
	// 사실상 중복만 확인하기 때문에 SELECT * ~ 해도 상관없다.
	String sql1 = "SELECT dept_no FROM departments WHERE dept_no = ? OR dept_name = ?";
	
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	
	ResultSet rs1 = stmt1.executeQuery();
	
	// 결과물이 있으면 dept_no값이 중복된다. --> insertDeptForm.jsp 로 재연결
	if(rs1.next()) {
		String msg = URLEncoder.encode("부서번호 또는 부서이름이 중복되었습니다.", "UTF-8");
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm.jsp?msg=" + msg);
		return;
	}
	
	
	// 2-2 입력 후 추가
	// sql 쿼리 
	String sqlInsert = "insert into departments (dept_no, dept_name) values (?, ?)";
	
	// sql 쿼리 전송 객체 생성
	PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert);
	
	// sql 내용 중 value ? 값 대입
	stmtInsert.setString(1, deptNo);
	stmtInsert.setString(2, deptName);
	
	// sql 실행 후 실행 완료된 쿼리 개수 반환
	int row = stmtInsert.executeUpdate();
	
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
