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
	
	
	// 넘어온 currentPage가 없으면 첫 페이지를 / 있으면 그 페이지를 저장
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	
	String boardWord = request.getParameter("boardWord");
	
	// 디버깅 코드
	System.out.println(boardWord + " <-- boardWord");
	
	
	
	// 2. 요청(업무) 처리 후 필요하다면 모델데이터를 생성(Model)
	
	
	// 변수 앞에 final 적으면 상수가 된다.(고칠 수 없는 값)
	// 상수는 대문자로 적고 단어 구분은 _로 한다.
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;		// ... LIMIT beginRow, ROW_PER_PAGE;
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	
	// word의 값에 따른 countSql 분기
	String cntSql = null;
	PreparedStatement cntStmt = null;
	
	if(boardWord == null) {
		// word 값이 null 일경우
		// countSql
		cntSql = "SELECT COUNT(board_no) cnt FROM board";
		
		// 쿼리 실행할 객체 생성
		cntStmt = conn.prepareStatement(cntSql);
		
		
		
	} else {
		// word 값이 들어올 경우(공백 포함)
		cntSql = "SELECT COUNT(board_no) cnt FROM board WHERE board_title LIKE ?";
		
		cntStmt = conn.prepareStatement(cntSql);
		
		cntStmt.setString(1, "%" + boardWord + "%");
		
		
	}
	
	
	
	// 2-1
	// ResultSet 에 저장
	ResultSet cntRs = cntStmt.executeQuery();
	
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = (int) Math.ceil((double) cnt / (double) ROW_PER_PAGE);
	
	
	// 2-2
	
	
	// word 값에 따른 listSql 분기
	
	String listSql = null;
	PreparedStatement listStmt = null;
	
	if(boardWord == null) {
		
		// listSql
		listSql = 
			"SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
		
		
		// 쿼리 실행할 객체 생성
		listStmt = conn.prepareStatement(listSql);
		
		// listSql 의 ? 대입
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
		
	} else {
		
		listSql = 
			"SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_title LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
		
		listStmt = conn.prepareStatement(listSql);
		
		listStmt.setString(1, "%" + boardWord + "%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
		
		
	
	
	
	
	
	// ResultSet 에 저장
	ResultSet listRs = listStmt.executeQuery();
	
	
	ArrayList<Board> listBoard = new ArrayList<Board>();
	while(listRs.next()) {
		Board tempBoard = new Board();
		tempBoard.boardNo = listRs.getInt("boardNo");
		tempBoard.boardTitle = listRs.getString("boardTitle");
		listBoard.add(tempBoard);
	}
	
	
	
	
	
	// 3. 출력(View)


%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>자유 게시판</title>
		
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
					<span class = "badge bg-success">자유 게시판</span>
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
		
			<!-- 부서 추가 버튼 -->
				<div class = "text-center"> 
					<h3>
						<span class = "badge bg-secondary">
							<a href = "<%=request.getContextPath() %>/board/insertBoardForm.jsp">글 쓰기</a>
						</span>
					</h3>
				</div>
		
			<div>&nbsp;</div>
		
		
		
			<div class = "row justify-content-center">
				<table class = "table table-borderless w-auto text-center">
					<thead class = "table-active">
						<tr>
							<th>번호</th>
							<th>제목</th>
						</tr>
					</thead>
					
					<tbody>
						<%
							for(Board b : listBoard) {
						%>
								<tr>
									<td><%=b.boardNo %></td>
									<td>
										<a href = "<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=b.boardNo %>">
											<span><%=b.boardTitle %></span>
										</a>
									</td>
								</tr>
						<%
							}
						%>	
					
					</tbody>
				</table>
			</div>
			
			<div>&nbsp;</div>
			
			<div class = "text-center">
				<form method = "post" action = "<%=request.getContextPath() %>/board/boardList.jsp">
					<label for = "boardWord">글 제목 : </label>
					
					<%
						if(boardWord == null) {
					%>
							<input type = "text" name = "boardWord" id = "boardWord">
					<% 
						} else {
					%>
							<input type = "text" name = "boardWord" id = "boardWord" value = "<%=boardWord %>">
					<%
						}
					%>
					
					
					<button type = "submit">검색</button>
				</form>
			</div>
			
			<div>&nbsp;</div>
			
			<!-- 페이징 처리 -->
			<div class = "text-center">
				<span>현재 페이지 : <%=currentPage %></span>
			</div>
			
			<div class = "text-center">
			
				<%
					if(boardWord == null) {
				%>
						<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=1">처음 </a>
						<%
							if(currentPage > 1) {
						%>
								<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage - 1%>">이전 </a>
						<%					
							}
						
							if(currentPage < lastPage) {
						%>
								<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage + 1%>">다음 </a>
						<%						
							}
						%>
						<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=lastPage %>">마지막 </a>
				<%		
					} else {
				%>
				
						<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=1&boardWord=<%=boardWord %>">처음 </a>
						<%
							if(currentPage > 1) {
						%>
								<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage - 1%>&boardWord=<%=boardWord %>">이전 </a>
						<%					
							}
						
							if(currentPage < lastPage) {
						%>
								<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage + 1%>&boardWord=<%=boardWord %>">다음 </a>
						<%						
							}
						%>
						<a href = "<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=lastPage %>&boardWord=<%=boardWord %>">마지막 </a>
				<%
					}
				%>
			</div>
		
		</div>
		
		
	</body>
</html>