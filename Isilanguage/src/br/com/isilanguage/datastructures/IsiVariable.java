package br.com.isilanguage.datastructures;

public class IsiVariable extends IsiSymbol {

	public static final int INT=0;
	public static final int	TEXT  =1;
	public static final int DECIMAL = 2;
	
	private int type;
	private String value;
	
	public IsiVariable(String name, int type, String value) {
		super(name);
		this.type = type;
		this.value = value;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
	public String toString() {
		return "IsiVariable [name="+ name + ", type=" + type + ", value=" + value + "]";
	}
	
	public String generateJavaCode() {
		String str;
		if(this.type == INT) {
			return "int " + super.name + ";";
		}
		
		if(this.type == DECIMAL) {
			return "double " + super.name + ";";
		}
		return "String " + super.name + ";";
	}
}
