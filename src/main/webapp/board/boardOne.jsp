<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>


<%
	// 1. 요청 분석
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	
	// 2. 요청 처리
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// sql
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board ORDER BY board_no ASC";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// ResultSet 에 저장
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}	
	
	
	
	
	
	
	
	// 3. 출력
%>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>게시글 보기</title>
		
		<!-- Bootstrap5를 참조한다 시작-->
		
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		
		<!-- Bootstrap5를 참조한다 끝-->
		
		<!-- 외부 부트스트랩 템플릿 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/minty.css">
		
		<!-- 앵커 태그 외부 css 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/anchor.css">
		
		<!-- 테이블 외부 css 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/table.css">
		
		<style>
			th {
				width : 70px;
			}
			
		</style>
		
	</head>
	
	<body>
		<div class = "container">
			
			<div>&nbsp;</div>
				
			<div class = "text-center">
				<h1>
					<span class = "badge bg-success">상세 보기</span>
				</h1>
			</div>
			
			<div>&nbsp;</div>

			<!-- 메뉴 partical jsp 구성 -->
			<div>
				<!-- include 주체는 서버라서 경로를 서버기준으로 생각해야한다.
					 request.getContextPath() 쓰지마라. 
					 이미 같이 안에 있기 때문에 context path를 가져올 필요가 없다.-->
				<jsp:include page = "/inc/menu.jsp"></jsp:include>
			</div>
			
			<div>&nbsp;</div>
		
		
			<div class = "row justify-content-center">
				<table class = "table table-borderless w-auot text-center">
					<tr>
						<th class = "table-active">번호</th>
						<td><%=board.boardNo %>
					</td>
						
					<tr>
						<th class = "table-active">제목</th>
						<td><%=board.boardTitle %>
					</td>
						
					<tr>
						<th class = "table-active">내용</th>
						<td><%=board.boardContent %>
					</td>
						
					<tr>
						<th class = "table-active">작성자</th>
						<td><%=board.boardWriter %>
					</td>
						
					<tr>
						<th class = "table-active">등록일</th>
						<td><%=board.createdate %>
					</td>
						
				</table>
			</div>
		
		
			<div class = "text-center">
				
					<span class = "badge bg-warning">
						<h4>
							<a href = "<%=request.getContextPath() %>/board/updateBoardForm.jsp?boardNo=<%=board.boardNo %>">
								<span>수정</span>
							</a>
						</h4>
					</span>
					
					<span class = "badge bg-danger">
						<h4>
							<a href = "<%=request.getContextPath() %>/board/deleteBoardForm.jsp?boardNo=<%=board.boardNo %>">
								<span>삭제</span>
							</a>
						</h4>
					</span>
			</div>
		
		</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	</body>
</html>