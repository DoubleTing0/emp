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
	
	if(boardNo == null) {
		// boardList에서 클릭하여 들어오지 않으면 boardNo 는 null  /  boardList.jsp 재연결
		response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
		return;
		
	}
	
	System.out.println(boardNo + " <-- boardNo");
	
	
	// 2. 요청 처리
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1 수정하기 전 내용들 boardNo를 이용하여 DB에서 가져오기
	// SELECT board_pw boardPw, board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate
	// From board WHERE board_no = ?
	String oneSql = "SELECT board_pw boardPw, board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate From board WHERE board_no = ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement oneStmt = conn.prepareStatement(oneSql);
	
	// oneSql 에 ? 대입
	oneStmt.setInt(1, Integer.parseInt(boardNo));
	
	// ResultSet 에 저장
	ResultSet oneRs = oneStmt.executeQuery();
	
	// 일반적인 사용을 위해 Board 객체에 저장
	Board oneBoard = null;
	if(oneRs.next()) {
		oneBoard = new Board();
		oneBoard.boardNo = Integer.parseInt(boardNo);
		oneBoard.boardTitle = oneRs.getString("boardTitle");
		oneBoard.boardContent = oneRs.getString("boardContent");
		oneBoard.boardWriter = oneRs.getString("boardWriter");
		oneBoard.createdate = oneRs.getString("createdate");
	}
	
	System.out.println(oneBoard.boardContent);






%>





<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>글 수정</title>
		
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
		

			<div class = "text-center text-danger">
				<%
					if(request.getParameter("msg") != null) {
				%>
						<span><%=request.getParameter("msg") %></span>
				<%
					}
				%>
			</div>
			
			<div>
				<form method = "post" action = "<%=request.getContextPath() %>/board/updateBoardAction.jsp">
					<div class = "row justify-content-center">
						<table class = "table table-borderless w-auto text-center">
							<tr>
								<th class = "table-active">번호</th>
								<td>
									<input type = "text" name = "boardNo" value = "<%=oneBoard.boardNo %>" readonly = "readonly">
								</td>
							</tr>
							
							<tr>
								<th class = "table-active">제목</th>
								<td>
									<input type = "text" name = "boardTitle" value = "<%=oneBoard.boardTitle %>">
								</td>
							</tr>
							
							<tr>
								<th class = "table-active">내용</th>
								<td>
									<textarea rows = "10" cols = "100" name = "boardContent"><%=oneBoard.boardContent %></textarea>
								</td>
							</tr>
							
							<tr>
								<th class = "table-active">작성자</th>
								<td>
									<input type = "text" name = "boardWriter" value = "<%=oneBoard.boardWriter %>">
								</td>
							</tr>
							
							<tr>
								<th class = "table-active">등록일</th>
								<td>
									<input type = "text" name = "createdate" value = "<%=oneBoard.createdate %>" readonly = "readonly">
								</td>
							</tr>
							
							<tr>
								<th class = "table-active">비밀번호</th>
								<td>
									<input type = "password" name = "boardPw">
								</td>
							</tr>
							
						</table>
					</div>
					
					<div class = "text-center">
						<h4>
							<button type = "submit" class = "badge bg-info" style = "border:0; outline:0">수정</button>
						</h4>
					</div>
					
				</form>
			</div>
		
		</div>
		
		
		
		
		
		
		
		
		
		
	</body>
</html>