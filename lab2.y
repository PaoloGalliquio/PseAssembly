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
%token ID NUMBER CAMBIOLINEA EAX EBX ECX EDX INC DEC MOV MUL
%%
final: incrementar CAMBIOLINEA {printf("FINAL\n");}
	| decrementar CAMBIOLINEA {printf("FINAL\n");}
	| asignar CAMBIOLINEA {printf("FINAL\n");}
	;

incrementar: INC EAX {$$= $2+1;}
		| INC EBX {$$= $2+1;}
		| INC ECX {$$= $2+1;}
		| INC EDX {$$= $2+1;}
		;
decrementar: DEC EAX {$$= $2-1;}
		| DEC EBX  {$$= $2-1;}
		| DEC ECX  {$$= $2-1;}
		| DEC EDX  {$$= $2-1;}
		;
asignar: MOV EAX {$$=localizaSimbolo(lexema,EAX);} EBX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EAX {$$=localizaSimbolo(lexema,EAX);} ECX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EAX {$$=localizaSimbolo(lexema,EAX);} EDX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EAX {$$=localizaSimbolo(lexema,EAX);} NUMBER {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EBX {$$=localizaSimbolo(lexema,EBX);} EAX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EBX {$$=localizaSimbolo(lexema,EBX);} ECX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EBX {$$=localizaSimbolo(lexema,EBX);} EDX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EBX {$$=localizaSimbolo(lexema,EBX);} NUMBER {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV ECX {$$=localizaSimbolo(lexema,ECX);} EAX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV ECX {$$=localizaSimbolo(lexema,ECX);} EBX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV ECX {$$=localizaSimbolo(lexema,ECX);} EDX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV ECX {$$=localizaSimbolo(lexema,ECX);} NUMBER {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EDX {$$=localizaSimbolo(lexema,EDX);} EAX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EDX {$$=localizaSimbolo(lexema,EDX);} EBX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EDX {$$=localizaSimbolo(lexema,EDX);} ECX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	| MOV EDX {$$=localizaSimbolo(lexema,EDX);} NUMBER {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
	;
%%
void yyerror(char *s){
	fprintf(stderr,"%s\n",s);
}


int localizaSimbolo(char *nom,int token){
	int i;
	for(i=0;i<nSim;i++){
		if(!strcmp(tablaSimbolos[nSim].nombre,nom)){/*if(!strcasecmp(tablaSimbolos[nSim].nombre,nom);*/
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

int yylex(){
	char c;int i;
	while((c=getchar())==' ');   /*permitirme ignorar blancos*/
	if (c=='\n') return CAMBIOLINEA;
	
    if(isalpha(c)){
		i=0;
		do{
			lexema[i++]=c;
			c=getchar();
		}while(isalnum(c));
		ungetc(c,stdin);
		lexema[i++]='\0';
		if(!strcmp(lexema,"EAX"))	return EAX;
		if(!strcmp(lexema,"EBX"))	return EBX;
		if(!strcmp(lexema,"ECX"))	return ECX;
		if(!strcmp(lexema,"EDX"))	return EDX;
		if(!strcmp(lexema,"asignar"))	return MOV;
       		if(!strcmp(lexema,"incrementar"))	return INC;
    		if(!strcmp(lexema,"decrementar"))	return DEC;
		if(!strcmp(lexema,"multiplicar"))	return MUL;
//---------------------------------------------------
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
		//imprimeTablaSimbolos();
	}
	else{
		printf("cadena inválida\n");	
	}
}


