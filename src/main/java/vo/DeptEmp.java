package vo;

public class DeptEmp {
	
	// 테이블 컬럼과 일치하는 도메인 타입
	// 단점 : 조인 결과를 처리 할 수 없다.
	// ex) public int empNo; public int deptNo;  불가능
	
	/*
	public int empNo;
	public int deptNo;
	public String fromDate;
	public String toDate;
	*/
	
	// 장점 : dept_emp 테이블의 행뿐만 아니라 JOIN 결과의 행도 처리할 수 있다.
	// 단점 : 복잡하다.
	public Employee emp;
	public Department dept;
	public String fromDate;
	public String toDate;
	
}
