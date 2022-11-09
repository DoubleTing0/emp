<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>인덱스</title>
		
		<!-- Bootstrap5를 참조한다 시작-->
		
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		
		<!-- Bootstrap5를 참조한다 끝-->
		
		<!-- 외부 부트스트랩 템플릿 참조 -->
		<link rel = "stylesheet" type = "text/css" href = "<%=request.getContextPath() %>/css/minty.css">
		
		<style>
			a:link {
			  text-decoration : none;
			  color : white;
			}
			
			a:visited {
			  text-decoration : none;
			  color : white;
			}
			
			a:hover {
			  text-decoration : none;
			  color : black;
			}
			
			a:active {
			  text-decoration : none;
			}
		    
		    
		    
		</style>
      
		
	</head>
	
	<body>
		<div class = "container">
		
			<div>&nbsp;</div>
			
			<div class = "text-center">
				<h1>
					<span class = "badge bg-success">INDEX</span>
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
			
			<div class = "text-center"> 
				<h3>
					<span class = "badge bg-secondary">
						<a href = "<%=request.getContextPath() %>/dept/deptList.jsp">부서 관리</a>
						
					</span>
				</h3>
			</div>
			<div class = "text-center"> 
				<h3>
					<span class = "badge bg-secondary">
						<a href = "<%=request.getContextPath() %>/emp/empList.jsp">사원 관리</a>
					</span>
				</h3>
			</div>
		</div>
		
	</body>
</html>