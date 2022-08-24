package br.com.isilanguage.ast;

import br.com.isilanguage.datastructures.IsiVariable;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CommandAtribuicao extends AbstractCommand {
	private String id;
	private String expr;
	
	public CommandAtribuicao(String id, String expr) {
		this.id = id;
		this.expr = expr;
	}
	
	@Override
	public String toString() {
		return "CommandAtribuicao [id=" + id + ", expr=" + expr + "]";
	}

	@Override
	public String generateJavaCode() {
		String expr_aux = this.expr + ';';
		String final_express = "";
		Character[] operadores_basicos = {'+', '-', '/', '*', ';'};
		List<Character> array_operadores_basicos = new ArrayList<Character>();
		
		array_operadores_basicos.addAll(Arrays.asList(operadores_basicos));

		String n1 = "";
		String n2 = "";
		
		boolean opExponencial = false;
		boolean opRaiz = false;
		boolean opLog = false;

		for(char c : expr_aux.toCharArray()) { 
			if (c == '^') {
				opExponencial = true;
				opRaiz = false;
				opLog = false;
			} else if (c == '$') {
				opExponencial = false;
				opRaiz = true;
				opLog = false;
			} else if (c == '%') {
				opExponencial = false;
				opRaiz = false;
				opLog = true;
			} else if (array_operadores_basicos.contains(c)) {
				if(opExponencial) {
					final_express += "Math.pow(" + n1 + ", " + n2 + ")" + c;
					opExponencial = false;
				} else if (opRaiz) {
					final_express += "Math.pow(" + n1 + ", 1/" + n2 + ")" + c;
					opRaiz = false;
				} else if (opLog) {
					final_express += "(Math.log(" + n1 + ")/Math.log(" + n2 + "))" + c;
					opLog = false;
				} else {
	                final_express += n1 + c;
	            }
				
				n1 = "";
				n2 = "";
			} else {
				if(opExponencial || opRaiz || opLog) n2 += c;
	            else n1 += c;
			}
		}
		return id + " = " + final_express;
	}
	
}
