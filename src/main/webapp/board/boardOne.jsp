<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>


<%
	// 1. 요청 분석
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentMsg = request.getParameter("commentMsg");
	
	
	
	// 2. 요청 처리
	
	// 2-1 게시글 상세보기
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	// DB 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// boardSql
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ? ORDER BY board_no ASC";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	
	// boardSql 에 ? 대입
	boardStmt.setInt(1, boardNo);
	
	// ResultSet 에 저장
	ResultSet boardRs = boardStmt.executeQuery();
	
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}	
	
	
	// 2-2 댓글 목록 n개씩 보이기
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 5;
	int beginRow = ROW_PER_PAGE * (currentPage - 1);
	
	
	//댓글 목록 commentSql
	// SELECT comment_no commentNo, comment_content commentContent, createdate FROM comment 
	// WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent, createdate FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?";
	
	// 쿼리 실행할 객체 생성
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	
	// commentSql 에 ? 대입
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);		
	commentStmt.setInt(3, ROW_PER_PAGE);
	
	
	// ResultSet 에 저장
	ResultSet commentRs = commentStmt.executeQuery();
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		c.createdate = commentRs.getString("createdate");
		commentList.add(c);
		
	}

	// cntSql 
	// 총 개수가 아닌 board_no 이 같은 것의 개수
	String cntSql = "SELECT COUNT(comment_no) cnt FROM comment WHERE board_no = ?";
	
	// cntSql 실행 할 객체 생성
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	
	// cntSql에 ? 대입
	cntStmt.setInt(1, boardNo);
	
	// ResultSet에 저장
	ResultSet cntRs = cntStmt.executeQuery();
		
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / ROW_PER_PAGE;
	if(cnt % ROW_PER_PAGE != 0) {
		lastPage += 1;
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
				width : 150px;
			}
			
		</style>
		
	</head>
	
	<body>
		<div class = "container">
			
			<!-- 글 상세보기 시작 -->
			<div>
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
			
			<!-- 글 상세보기 끝 -->
		
			<div>
				<h1>&nbsp;</h1>
				<h1>&nbsp;</h1>
			</div>
		
		
			<!-- 댓글입력 폼 시작 -->
			<div>
				<div class = "text-center">
					<h1>
						<span class = "badge bg-success">댓글</span>
					</h1>
				</div>
				
				<!-- 댓글 공백시 메세지 출력 -->
				<div class = "text-center text-danger">
					<%
						if(commentMsg != null) {
					%>
							<span><%=commentMsg %></span>
					<%
						}
					%>
				</div>
				
				<div>
					<form action = "<%=request.getContextPath() %>/board/insertCommentAction.jsp" method = "post">
						<div class = "row justify-content-center">
							<input type = "hidden" name = "boardNo" value = "<%=board.boardNo %>">
							
							<table class = "table table-borderless w-auto text-center">
								<tr>
									<td>댓글내용</td>
									<td>
										<textarea rows = "3" cols = "50" name = "commentContent"></textarea>
									</td>
								</tr>
								
								<tr>
									<td>비밀번호</td>
									<td>
										<input type = "password" name = "commentPw" >
									</td>
								</tr>
							</table>
						
							<div class = "text-center">
								<h3>
									<button type = "submit" class = "badge bg-info" style = "border:0; outline:0">댓글등록</button>
								</h3>
							</div>
					
						</div>
					</form>
				</div>
				
				
			</div>
			<!-- 댓글 입력 폼 끝 -->
		
		
			
			<div>
				<h1>&nbsp;</h1>
				<h1>&nbsp;</h1>
			</div>
		
		
		
			<!-- 댓글 목록 시작 -->
			<div>
				<div class = "text-center">
					<h1>
						<span class = "badge bg-success">댓글 목록</span>
					</h1>
				</div>
				
				<div>
					<h3>&nbsp;</h3>
				</div>
				
				<div class = "row justify-content-center">
					<table class = "table table-borderless w-auto text-center">
						<%
							for(Comment c : commentList) {
						%>
								<tr>
									<th class = "table-active">댓글 번호</th>
									<td><%=c.commentNo %></td>
								</tr>
								
								<tr>
									<th class = "table-active">댓글 내용</th>
									<td><%=c.commentContent %></td>
								</tr>
								
								<tr>
									<th class = "table-active">댓글 등록일</th>
									<td><%=c.createdate %></td>
								</tr>
							
								<tr>
									<td colspan = "2">
										<div class = "text-center">
											<span class = "badge bg-warning">
												<h4>
													<a href = "<%=request.getContextPath() %>/board/updateCommentForm.jsp?boardNo=<%=board.boardNo %>&commentNo=<%=c.commentNo%>">
														<span>수정</span>
													</a>
												</h4>
											</span>
											
											<span class = "badge bg-danger">
												<h4>
													<a href = "<%=request.getContextPath() %>/board/deleteCommentForm.jsp?boardNo=<%=board.boardNo %>&commentNo=<%=c.commentNo%>">
														<span>삭제</span>
													</a>
												</h4>
											</span>
										</div>
										
										<div>
											<h1>&nbsp;</h1>
										</div>
									</td>
								</tr>
					
						<%
							}
						%>
					</table>
					
					
				</div>
				
			</div>		

			<!-- 댓글 목록 끝 -->
			
			<!-- 댓글 목록 페이징 시작 -->
			<div class = "text-center">
				<div>
					현재페이지 : <%=currentPage %>
				</div>
				
				<div>
					<a href = "<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=1">처음</a>
					<%
						if(currentPage > 1) {
					%>
							<a href = "<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage - 1%>">이전</a>
					<%
						}
					
						if(currentPage < lastPage) {
					%>						
							<a href = "<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage + 1%>">다음</a>
					<%
						}
					%>
					
					<a href = "<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=lastPage %>">마지막</a>
					
				
				</div>
			</div>
			<!-- 댓글 목록 페이징 끝 -->
			
		</div>
		
	</body>
</html>