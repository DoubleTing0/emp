<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<% 
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>

<%
	// 1. 요청 분석(Controller)
	
	// 수정 Form 에서 값 받아오기
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");

	// 공백 값 입력 받아오면 updateDeptForm.jsp  재연결 후 코드 종료
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		String msg = URLEncoder.encode("부서이름을 입력하세요.", "UTF-8"); // get방식 한글 안깨지도록 인코딩
		response.sendRedirect(request.getContextPath() + "/dept/updateDeptForm.jsp?deptNo=" + deptNo + "&msg=" + msg + "");
		return;
	}
	
	Department d = new Department();
	d.deptNo = deptNo;
	d.deptName = deptName;
	
	
	// 입력받은 deptNo, deptName 를 저장한 Department d 확인용 디버깅 코드
	System.out.println(d.deptNo + " <--d.deptNo1");
	System.out.println(d.deptName + " <--d.deptName1");
	
	// 2. 업무 처리(Model)

	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");

	

	
	// 2-1 dept_name 중복 검사
	// 입력 추가 하기 전에 동일한 dept_name 가 있는지 확인
	String sqlName = "SELECT dept_no, dept_name FROM departments WHERE dept_name = ?";
	
	PreparedStatement stmtName = conn.prepareStatement(sqlName);
	
	stmtName.setString(1, d.deptName);
	
	ResultSet rsName = stmtName.executeQuery();
	
	// rsName의 결과물이 있고
	// 분기1 / 수정 전과 번호까지 같을경우 분기2 / 나머지의 다른 값과 같을경우 --> insertDeptForm.jsp 로 재연결
	if(rsName.next()) {
		// 디버깅 코드
		System.out.println(rsName.getString("dept_no") + " <-- rsName(dept_no)");
		System.out.println(rsName.getString("dept_name") + " <-- rsName(dept_name)");
	
		
		if(rsName.getString("dept_no").equals(deptNo) && rsName.getString("dept_name").equals(deptName)) {
			String msg = URLEncoder.encode("수정 전 부서이름과 같습니다.", "UTF-8");
			response.sendRedirect(request.getContextPath() + "/dept/updateDeptForm.jsp?deptNo=" + deptNo + "&msg=" + msg + "");
			return;
		} else {
			String msg = URLEncoder.encode("부서이름이 중복되었습니다.", "UTF-8");
			response.sendRedirect(request.getContextPath() + "/dept/updateDeptForm.jsp?deptNo=" + deptNo + "&msg=" + msg + "");
			return;
			
		}
	}
	
	
	
	
	
	
	
	
	// sql 쿼리
	String sql = "update departments set dept_name = ? where dept_no = ?";
	
	// sql 쿼리 실행 할 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
		
	// sql 쿼리 내의 ? 대입
	stmt.setString(1, d.deptName);
	stmt.setString(2, d.deptNo);
	
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



