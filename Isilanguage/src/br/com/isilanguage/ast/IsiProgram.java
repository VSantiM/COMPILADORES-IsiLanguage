package br.com.isilanguage.ast;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;

import br.com.isilanguage.datastructures.IsiSymbol;
import br.com.isilanguage.datastructures.IsiSymbolTable;

public class IsiProgram {
	private IsiSymbolTable varTable;
	private ArrayList<AbstractCommand> comandos;
	private String progName;

	public void generateTarget() {
		StringBuilder str = new StringBuilder();
		str.append("import java.util.Scanner;\n");
		str.append("public class MainClass{\n");
		str.append("	public static void main(String args[]){\n");
		str.append("    Scanner _key = new Scanner(System.in);\n");
		for(IsiSymbol symbol: varTable.getAllSymbols()) {
			str.append(symbol.generateJavaCode()+"\n");
		}
		for(AbstractCommand command: comandos) {
			str.append(command.generateJavaCode()+"\n");
		}
		str.append("	}\n");
		str.append("}\n");
		
		try {
			FileWriter fr = new FileWriter(new File("MainClass.java"));
			fr.write(str.toString());
			fr.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}
	}
	
	public IsiSymbolTable getVarTable() {
		return varTable;
	}

	public void setVarTable(IsiSymbolTable varTable) {
		this.varTable = varTable;
	}

	public ArrayList<AbstractCommand> getComandos() {
		return comandos;
	}

	public void setComandos(ArrayList<AbstractCommand> comandos) {
		this.comandos = comandos;
	}

	public String getProgName() {
		return progName;
	}

	public void setProgName(String progName) {
		this.progName = progName;
	}

}
