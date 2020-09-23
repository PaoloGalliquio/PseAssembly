%{
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<string.h>
#include<ctype.h>

/*prototipos de funcion*/
int yylex();
void yyerror(char *s);
int localizaSimbolo(char *nom,int token);
void imprimeTablaSimbolos();

/*estructuras*/
typedef struct{
	char nombre[100];    
	int token; 
	int tipodato;          
	double valor;        
}TipoTS;
TipoTS tablaSimbolos[100];

/*variables*/
int nSim=0;
char lexema[100];

%}
%token NUMBER MEMO REG NEG EXCL COMP ID 
%%

final:          instruccion ;

instruccion:    assembler   {printf("FINAL DE INSTRUCCION\n");} 
                |
                negacion   {printf("FINAL DE INSTRUCCION\n");}
                |
                exclusividad   {printf("FINAL DE INSTRUCCION\n");}
                |
                comparacion {printf("FINAL DE INSTRUCCION\n");}
                ;

assembler:      ID {$$=localizaSimbolo(lexema,ID);} NUMBER {$$=localizaSimbolo(lexema,NUMBER);} ',' NUMBER {$$=localizaSimbolo(lexema,NUMBER);} {printf("Operacion en assembler\n");}
                |
                ID {$$=localizaSimbolo(lexema,ID);} REG ',' NUMBER {printf("Operacion entre registro y numero\n");}
                ;

negacion:       NEG {$$=localizaSimbolo(lexema,NEG);} REG {$$=localizaSimbolo(lexema,REG);} {printf("Negacion de un registro\n");}
                ;

exclusividad:   EXCL {$$=localizaSimbolo(lexema,EXCL);}  {printf("XOR entre 2 registros\n");}
                ;

comparacion:	COMP {$$=localizaSimbolo(lexema,COMP);} REG {$$=localizaSimbolo(lexema,REG);} ',' REG {$$=localizaSimbolo(lexema,REG);} {printf("Comparacion entre 2 registros\n");}
				; 


%%

void yyerror(char *s){
	fprintf(stderr,"%s\n",s);
}


int localizaSimbolo(char *nom,int token){
	int i;
	for(i=0;i<nSim;i++){
		if(!strcmp(tablaSimbolos[nSim].nombre,nom)){
				return i;
		}
	}
	strcpy(tablaSimbolos[nSim].nombre,nom);
	tablaSimbolos[nSim].token=token;
	if(token==NUMBER){
		tablaSimbolos[nSim].valor=atof(lexema);
	}
	else{
		tablaSimbolos[nSim].valor=0.0;
	}
	nSim++;
	return nSim-1;


}

void imprimeTablaSimbolos(){
	int i;
	printf("Tabla de simbolos\n");
	for(i=0;i<nSim;i++){
		printf("%d %s %d %lf\n",i,tablaSimbolos[i].nombre,tablaSimbolos[i].token,tablaSimbolos[i].valor);		
	}

}

int yylex(){ char c;int i; while((c=getchar())==' ');   /*permitirme ignorar
blancos*/ /*	 if (c=='\n'){ //ungetc(c,stdin); return CAMBIOLINEA; }*/

    //REGISTROS 
	if(c=='e'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='a'){
			lexema[i++]=c;
			c=getchar();
			if(c=='x'){
                lexema[i++]=c; 
				lexema[i]='\0';
				return REG;
			}
			else ungetc(c,stdin);
			
		}
		else if(c=='b'){
			lexema[i++]=c;
			c=getchar();
			if(c=='x'){
                lexema[i++]=c; 
				lexema[i]='\0';
				return REG;
				
			}
			else ungetc(c,stdin);
			
		}
		else if(c=='c'){
			lexema[i++]=c;
			c=getchar();
			if(c=='x'){
                lexema[i++]=c; 
				lexema[i]='\0';
				return REG;
				
			}
			else ungetc(c,stdin);
			
		}
		else if(c=='d'){
			lexema[i++]=c;
			c=getchar();
			if(c=='x'){
                lexema[i++]=c; 
				lexema[i]='\0';
				return REG;

			}
			else ungetc(c,stdin);
			
		}
		else ungetc(c,stdin);
		
	}

    //PALABRAS RESERVADAS DE FUNCIONES
	if(c=='E'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='X'){
			lexema[i++]=c;
			c=getchar();
			if(c=='C'){
                lexema[i++]=c;
                c=getchar();
                if(c=='L'){
                    lexema[i++]=c;       
				    lexema[i]='\0';
				    return EXCL;
				    
                }
                else ungetc(c,stdin);
                
			}
			else ungetc(c,stdin);
			
		}
		else ungetc(c,stdin);
		
	}
    
	if(c=='n'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='e'){
			lexema[i++]=c;
			c=getchar();
			if(c=='g'){     
                lexema[i++]=c;   
			    lexema[i]='\0';
			    return NEG;
            }
            else ungetc(c,stdin);
            
		}
		else ungetc(c,stdin);
		
	}
    

//-----------------------------------------------------
    if(isalpha(c)){
		i=0;
		do{
			lexema[i++]=c;
			c=getchar();
		}while(isalnum(c));
		ungetc(c,stdin);
		lexema[i++]='\0';
		return ID;

	}
	if(isdigit(c)){ 
		//scanf("%d",&yylval);
		i=0;
		do{
			lexema[i++]=c;
			c=getchar();
		}while(isdigit(c));
		ungetc(c,stdin);
		lexema[i++]='\0';
		return NUMBER;
	}
	if(c=='\n'){
		return 0;
	}
	return c;
}

int main(){
	if(!yyparse()){
		printf("cadena válida\n");
		imprimeTablaSimbolos();
	}
	else{
		printf("cadena inválida\n");	
	}
}

