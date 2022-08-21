package br.com.isilanguage.ast;

import java.util.ArrayList;

public class CommandEnquanto extends AbstractCommand {

	private String condition;
	private ArrayList<AbstractCommand> listaComandos;
	
	public CommandEnquanto(String condition, ArrayList<AbstractCommand> listaComandos) {
		this.condition = condition;
		this.listaComandos = listaComandos;
	}
	
	@Override
	public String generateJavaCode() {
		StringBuilder str = new StringBuilder();
		str.append("while("+condition+") {\n");
		for(AbstractCommand cmd : listaComandos) {
			str.append(cmd.generateJavaCode()+"\n");
		}
		str.append("}");
		return str.toString();
	}

	@Override
	public String toString() {
		return "CommandEnquanto [condition=" + condition + ", listaComandos=" + listaComandos + "]";
	}

}
