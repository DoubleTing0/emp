<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청 분석(Controller)
	
	
	// 넘어온 currentPage가 없으면 첫 페이지를 / 있으면 그 페이지를 저장
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	
	// 2. 요청(업무) 처리 후 필요하다면 모델데이터를 생성(Model)
	
	
	// 변수 앞에 final 적으면 상수가 된다.(고칠 수 없는 값)
	// 상수는 대문자로 적고 단어 구분은 _로 한다.
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;		// ... LIMIT beginRow, ROW_PER_PAGE;
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1
	// countSql
	String cntSql = "SELECT COUNT(board_no) cnt FROM board";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	
	// ResultSet 에 저장
	ResultSet cntRs = cntStmt.executeQuery();
	
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = (int) Math.ceil((double) cnt / (double) ROW_PER_PAGE);
	
	
	// 2-2
	
	// listSql
	String listSql = 
		"SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	
	
	// 쿼리 실행할 객체 생성
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	
	// listSql 의 ? 대입
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	
	
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
			
			
			<!-- 페이징 처리 -->
			<div class = "text-center">
				<span>현재 페이지 : <%=currentPage %></span>
			</div>
			
			<div class = "text-center">
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
			</div>
		
		</div>
		
		
	</body>
</html>