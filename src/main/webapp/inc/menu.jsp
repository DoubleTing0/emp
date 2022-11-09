<!-- 제일 윗줄은 있어야한다. -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- partical jsp 페이지 사용할 코드 -->
<h3>
	<span class = "badge bg-info">
		<a href = "<%=request.getContextPath() %>/index.jsp">홈으로</a>
	</span>
	<span class = "badge bg-info">
		<a href = "<%=request.getContextPath() %>/dept/deptList.jsp">부서 관리</a>
	</span>
	<span class = "badge bg-info">
		<a href = "<%=request.getContextPath() %>/emp/empList.jsp">사원 관리</a>
	</span>
</h3>
