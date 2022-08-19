package br.com.isilanguage.datastructures;

public abstract class IsiSymbol {
	
	protected String name;
	
	public abstract String generateJavaCode();
	
	public IsiSymbol(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
