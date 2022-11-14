<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	// 인코딩 : UTF-8
	request.setCharacterEncoding("UTF-8");
%>

<%
	// Map 타입의 이해
	
	// 정석(자주 여러번 사용할 경우)
	// 클래스를 사용하면 아래와 같이 코드 사용.
	/*
	
	Class Student {
		public String name;
		public int age;
	}

	*/
	
	Student s = new Student();
	s.name = "김도희";
	s.age = 29;

	
	
	
	// 결과는 같지만 많이 사용하지 않을 경우
	// Student Class 가 없다면 - 클래스를 사용하지 않는 방법
	//	String 에는 name 과 age가 오게 하고
	//	object는 아무타입이나 다 올수 있음.
	HashMap<String, Object> m  = new HashMap<String, Object>();
	m.put("name", "김도희");
	m.put("age", 29);
	
	
	System.out.println(s.name + " <-- s.name");
	System.out.println(s.age + " <-- s.age");
	System.out.println(m.get("name") + " <-- m.get(\"name\")");
	System.out.println(m.get("age") + " <-- m.get(\"age\")");
	
	
	// 집합이면 (학생이 여러명이면)
	// 1) Student 클래스 사용
	Student s1 = new Student();
	s1.name = "김민송";
	s1.age = 26;
	
	Student s2 = new Student();
	s2.name = "김설";
	s2.age = 29;
	
	ArrayList<Student> studentList = new ArrayList<Student>();
	studentList.add(s1);
	studentList.add(s2);
	
	System.out.println("studentList 출력");
	for(Student st : studentList) {
		System.out.println(st.name + " <-- st.name");
		System.out.println(st.age + " <-- st.age");
	}
	
	// 2) Map 사용
	HashMap<String, Object> m1 = new HashMap<String, Object>();
	m1.put("name", "김민송");
	m1.put("age", 26);
	
	HashMap<String, Object> m2 = new HashMap<String, Object>();
	m2.put("name", "김설");
	m2.put("age", 29);
	
	ArrayList<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
	mapList.add(m1);
	mapList.add(m2);
	
	System.out.println("mapList 출력");
	for(HashMap<String, Object> hm : mapList) {
		System.out.println(hm.get("name"));
		System.out.println(hm.get("age"));
		
	}
	
	
	
%>



<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	
	<body>
		
	</body>
</html>