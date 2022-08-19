package br.com.isilanguage.main;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import br.com.isilanguage.exceptions.IsiSemanticException;
import br.com.isilanguage.parser.IsiLangLexer;
import br.com.isilanguage.parser.IsiLangParser;

public class MainClass {

	public static void main(String[] args) {
		try {
			IsiLangLexer lexer;
			IsiLangParser parser;
			
			lexer = new IsiLangLexer(CharStreams.fromFileName("input.isi"));
			
			CommonTokenStream tokenStream = new CommonTokenStream(lexer);
			
			parser = new IsiLangParser(tokenStream);
			parser.prog();
			
			
			
			parser.exibeComandos();
			
			parser.generateCode();
			
			System.out.println("Compilation Successful");
		}
		catch(IsiSemanticException ex) {
			System.err.println("Semantic ERROR - "+ex.getMessage());
		}
		catch(Exception ex) {
			System.err.println("ERROR "+ex.getMessage());
		}
	}
}
