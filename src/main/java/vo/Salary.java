package vo;

public class Salary {
	//	public int empNo;	// 1) 조인한 나머지 결과물을 받을수 없다.
	public Employee emp;	// 2) 항상 Employee 객체를 만들어줘야 사용 가능하다. // inner join 결과물을 저장하기 위하여
	public int salary;
	public String fromDate;
	public String toDate;
	public String name;
	
	/*
	public static void main(String[] args) {
		
		Salary s = new Salary();
		s.Salary = 5000;
		s.fromDate = "2021-01-01";
		s.toDate = "210-12-31";
		s.emp = new Employee();		// 객체를 항상 만들어 줘야 한다.
		s.emp.empNo = 1;
		
		
		
		
	}
	*/
	
}
