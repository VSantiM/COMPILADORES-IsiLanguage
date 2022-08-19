package br.com.isilanguage.ast;

import br.com.isilanguage.datastructures.IsiVariable;

public class CommandLeitura extends AbstractCommand {

	private String id;
	private IsiVariable var;
	
	public CommandLeitura (String id, IsiVariable var) {
		this.id = id;
		this.var = var;
	}
	
	@Override
	public String toString() {
		return "CommandLeitura [id=" + id + "]";
	}
	
	private String ScannerType(int type) {
		if(type == IsiVariable.INT) {
			return "nextInt();";
		}
		
		if(type == IsiVariable.DECIMAL) {
			return "nextDouble();";
		}
		
		return "nextLine();";
	}

	@Override
	public String generateJavaCode() {
		return id + " = _key." + ScannerType(var.getType());
	}
	
	
}
