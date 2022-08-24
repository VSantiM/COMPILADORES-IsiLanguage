grammar IsiLang;

@header{
	import br.com.isilanguage.datastructures.IsiSymbol;
	import br.com.isilanguage.datastructures.IsiVariable;
	import br.com.isilanguage.datastructures.IsiSymbolTable;
	import br.com.isilanguage.exceptions.IsiSemanticException;
	import br.com.isilanguage.ast.IsiProgram;
	import br.com.isilanguage.ast.AbstractCommand;
	import br.com.isilanguage.ast.CommandLeitura;
	import br.com.isilanguage.ast.CommandEscrita;
	import br.com.isilanguage.ast.CommandAtribuicao;
	import br.com.isilanguage.ast.CommandDecisao;
	import br.com.isilanguage.ast.CommandEnquanto;
	import java.util.ArrayList;
	import java.util.Stack;
}

@members{
	private int _tipo;
	private String _varName;
	private String _varValue;
	private IsiSymbolTable symbolTable = new IsiSymbolTable();
	private IsiSymbolTable symbolTableAtribuidos = new IsiSymbolTable();
	private IsiSymbol symbol;
	private IsiProgram program = new IsiProgram();
	private ArrayList<AbstractCommand> mainThread;
	private Stack<ArrayList<AbstractCommand>> stack = new Stack<ArrayList<AbstractCommand>>();
	private String _readID;
	private String _writeID;
	private String _exprID;
	private String _exprContent;
	private String _exprDecision;
	private ArrayList<AbstractCommand> listaTrue;
	private ArrayList<AbstractCommand> listaFalse;
	private ArrayList<AbstractCommand> listaComandos;
	private ArrayList<AbstractCommand> listaCasos;
	private ArrayList<AbstractCommand> listaComandosDosCasos;
	
	public int verificaAtribuicao(String input) {
			if(input.contains("\"")) return 1;
			if(input.contains(".")) return 2;
			return 0;
	}
	
	public void verificaId(String id){
		if(!symbolTable.exists(id)){
			throw new IsiSemanticException("Symbol " + id + " not declared");
		}
	}
	
	public void exibeComandos(){
		for(AbstractCommand c: program.getComandos()){
			System.out.println(c);
		}
	}
	
	public void generateCode(){
		program.generateTarget();
	}
}

prog	: 'programa' decl bloco 'fimprog'
		{ 
			program.setVarTable(symbolTable);
			program.setComandos(stack.pop());
			
			program.setVarTable(symbolTableAtribuidos);
			
			
			ArrayList<IsiSymbol> listaSimbolos = symbolTable.getAllSymbols();
						
			for(IsiSymbol variavel : listaSimbolos){
				if(!symbolTableAtribuidos.exists(variavel.getName())) {
					System.out.println("WARNING: Variável " + variavel.getName() + " inicializada, mas não atribuida");
				}
			}
		}
		;
		
decl	: (declaravar)*
		;

declaravar 	: tipo ID 	{
							_varName = _input.LT(-1).getText();
							_varValue = null;
							symbol = new IsiVariable(_varName, _tipo, _varValue);
							if(!symbolTable.exists(_varName)){
								symbolTable.add(symbol);
							}else{
								throw new IsiSemanticException("Symbol "+_varName + " already declared");
							}
						}
			 	(VIR
			 	 ID	{
							_varName = _input.LT(-1).getText();
							_varValue = null;
							symbol = new IsiVariable(_varName, _tipo, _varValue);
							if(!symbolTable.exists(_varName)){
								symbolTable.add(symbol);
							}else{
								throw new IsiSemanticException("Symbol "+_varName + " already declared");
							}
						}
			 	 )* SC
			;

tipo		: 'inteiro' { _tipo = IsiVariable.INT;}
			| 'texto' { _tipo = IsiVariable.TEXT;}
			| 'decimal' { _tipo = IsiVariable.DECIMAL;}
			;
		
bloco	: 	{ 
				mainThread = new ArrayList<AbstractCommand>();
				stack.push(mainThread);
			}
		 (cmd)+
		;

cmd		: cmdleitura { }
 		| cmdescrita { }
 		| cmdattrib { }
 		| cmdif
 		| cmdwhile
		;
		
cmdleitura	: 'leia' AP 
					 ID { 
					 		verificaId(_input.LT(-1).getText());
					 		_readID = _input.LT(-1).getText();
					 	}
					 FP 
					 SC
					 {
					 	IsiVariable var = (IsiVariable)symbolTable.get(_readID);
					 	
					 	int variableType = var.getType();

						if (!symbolTableAtribuidos.exists(_exprID)) {
							symbolTableAtribuidos.add(symbol);
						}
					 
					 	CommandLeitura cmd = new CommandLeitura(_readID, var);
					 	stack.peek().add(cmd);
					 }
			;

cmdescrita	: 'escreva' AP
						ID {
								verificaId(_input.LT(-1).getText());
								_writeID = _input.LT(-1).getText();
							}
						FP
						SC
						{
						 	CommandEscrita cmd = new CommandEscrita(_writeID);
						 	stack.peek().add(cmd);
						 }
			;
			
cmdattrib	: 	ID 
				{
					verificaId(_input.LT(-1).getText());
					_exprID = _input.LT(-1).getText();
				}
				ATTR{
					_exprContent = "";
				}
				expr
				SC
				{
					_varName = _input.LT(-1).getText();
					
					
					int variableType = ((IsiVariable)symbolTable.get(_exprID)).getType();
					
					symbol = new IsiVariable(_exprID, variableType, _exprContent);
					
					boolean validacaoTipoIgual = (variableType == verificaAtribuicao(_exprContent));

					if(!validacaoTipoIgual) {
						throw new IsiSemanticException("Value " + _exprContent + " missmatches variable " + _exprID + " type");
					}
				

					if (!symbolTableAtribuidos.exists(_exprID)) {
						symbolTableAtribuidos.add(symbol);
					}
					
					CommandAtribuicao cmd = new CommandAtribuicao(_exprID, _exprContent);
					stack.peek().add(cmd);
				}
			;

cmdif	: 	'se'
			AP 
			ID {_exprDecision = _input.LT(-1).getText(); }
			OPREL {_exprDecision += _input.LT(-1).getText(); }
			(ID | INT | DECIMAL | TEXTO) {_exprDecision += _input.LT(-1).getText(); }
			FP 
			'entao' 
			ACH 
			{ 
				mainThread = new ArrayList<AbstractCommand>();
				stack.push(mainThread);
			}
			(cmd)+ 
			FCH
			{
				listaTrue = stack.pop();
			}
			('senao'
			 ACH 
			 {
			 	mainThread = new ArrayList<AbstractCommand>();
				stack.push(mainThread);
			 }
			 (cmd)+ 
			 FCH
			 {
				listaFalse = stack.pop();
			})?
			{
				CommandDecisao cmd = new CommandDecisao(_exprDecision, listaTrue, listaFalse);
				stack.peek().add(cmd);
			}
		;
	
cmdwhile : 'enquanto'
			AP
			ID {_exprDecision = _input.LT(-1).getText(); }
			OPREL {_exprDecision += _input.LT(-1).getText(); }
			(ID | INT | DECIMAL | TEXTO) {_exprDecision += _input.LT(-1).getText(); }
			FP 
			ACH 
			{ 
				mainThread = new ArrayList<AbstractCommand>();
				stack.push(mainThread);
			}
			(cmd)+ 
			FCH
			{ 
				listaComandos = stack.pop();
				CommandEnquanto cmd = new CommandEnquanto(_exprDecision, listaComandos);
				stack.peek().add(cmd);
			}
		;
expr	: 	termo ( 
			OP {_exprContent += _input.LT(-1).getText();}
			termo )*
		;
		
termo	: ID {
				verificaId(_input.LT(-1).getText());
				_exprContent += _input.LT(-1).getText();
			} 
		| 
			INT
			{
				_exprContent += _input.LT(-1).getText();
			}
		| 
			DECIMAL
			{
				_exprContent += _input.LT(-1).getText();
			}
		|
			TEXTO
			{
				_exprContent += _input.LT(-1).getText();
			}
		;
		
AP	: '('
	;
	
FP	: ')'
	;

SC	: ';'
	;
	
OP	: '+' | '-' | '*' | '/' | '^'
	;

ATTR	: '='
		;
		
VIR		: ','
		;
		
OPREL 	: '>' | '<' | '>=' | '<=' | '==' | '!='
		;
		
ACH	: '{'
	;
	
FCH	: '}'
	;

ID		: [a-z] ([a-z] | [A-Z] | [0-9])*
		;

DECIMAL	: [0-9]+ ('.' [0-9]+)?
		;
		
INT		: [0-9]+
		;


		
TEXTO	: '"' .*? '"'
		;
		
		
WS	: (' ' | '\t' | '\n' | '\r') -> skip;	
