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
%token NUMERODECIMAL NUMEROHEXADECIMAL NUMEROOCTAL NUMEROBINARIO EAX EBX ECX EDX MOV INC DEC MUL
%%
listainst: listainst instr '\n' 
		| instr '\n' 
		;
instr 	: asignacion 
		| incrementar | decrementar     
		;

asignacion: MOV EAX {$$=localizaSimbolo(lexema,EAX);} EBX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EAX {$$=localizaSimbolo(lexema,EAX);} ECX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EAX {$$=localizaSimbolo(lexema,EAX);} EDX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EAX {$$=localizaSimbolo(lexema,EAX);} NUMERODECIMAL {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EBX {$$=localizaSimbolo(lexema,EBX);} EAX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EBX {$$=localizaSimbolo(lexema,EBX);} ECX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EBX {$$=localizaSimbolo(lexema,EBX);} EDX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EBX {$$=localizaSimbolo(lexema,EAX);} NUMERODECIMAL {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV ECX {$$=localizaSimbolo(lexema,ECX);} EAX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV ECX {$$=localizaSimbolo(lexema,ECX);} EBX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV ECX {$$=localizaSimbolo(lexema,ECX);} EDX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV ECX {$$=localizaSimbolo(lexema,EAX);} NUMERODECIMAL {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EDX {$$=localizaSimbolo(lexema,EDX);} EAX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EDX {$$=localizaSimbolo(lexema,EDX);} EBX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EDX {$$=localizaSimbolo(lexema,EDX);} ECX {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
		| MOV EDX {$$=localizaSimbolo(lexema,EAX);} NUMERODECIMAL {printf("El resultado %d\n",$4);printf("Pos en tabla %d\n",$3);}
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

%%
void yyerror(char *s){
	fprintf(stderr,"%s\n",s);
}


int localizaSimbolo(char *nom,int token){
	int i, longitud;
    double suma=0.0;
	for(i=0;i<nSim;i++){
		if(!strcasecmp(tablaSimbolos[nSim].nombre,nom)){/*if(!strcmp(tablaSimbolos[nSim].nombre,nom);*/
				return i;
		}
	}
	strcpy(tablaSimbolos[nSim].nombre,nom);
	tablaSimbolos[nSim].token=token;
//Asignacion de valor decimal
	if(token==NUMERODECIMAL){
        if(isdigit(lexema[strlen(lexema)]))
		    suma=atof(lexema);
        else{
            longitud=strlen(lexema)-2;
            for(int j=0; j<=longitud; j++){
                suma=suma+(atof(lexema[j]))*10^(longitud-j);
            }
        }
	}
//Asignacion de valor hexadecimal
    if(token==NUMEROHEXADECIMAL){
		longitud=strlen(lexema)-2;
        for(int j=0; j<=longitud; j++){
            if(isdigit(lexema[j])){
                suma=suma+(atof(lexema[j])*16^(longitud-j);
            }
            if(lexema[j]>='a'&&lexema[j]<='f'){
                suma=suma+((int)(lexema[j])-87)*16^(longitud-j);
            }
            if(lexema[j]>='A' && lexema[j]<='F'){
                suma=suma+((int)(lexema[j])-55)*16^(longitud-j);
            }
        }
	}
//Asignacion de valor octal
    if(token==NUMEROOCTAL){
		longitud=strlen(lexema)-2;
        for(int j=0; j<=longitud; j++){
            suma=suma+(atof(lexema[j]))*8^(longitud-j);
        }
	}
//Asignacion de valor binario
    if(token==NUMEROBINARIO){
		longitud=strlen(lexema)-2;
        for(int j=0; j<=longitud; j++){
            suma=suma+(atof(lexema[j]))*2^(longitud-j);
        }
	}
//Sin asignacion de valor numerico inicial
	else{
		suma=0.0;
	}
    tablaSimbolos[nSim].valor=suma;
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
	while((c=getchar())==' ');/*permitirme ignorar blancos*/
//---------------------------------------
//REGISTROS 
	if(c=='E'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='A'){
			lexema[i++]=c;
			c=getchar();
			if(c=='X'){
				lexema[i]='\0';
				return EAX;
			}
			else ungetc(c,stdin);
		}
		else if(c=='B'){
			lexema[i++]=c;
			c=getchar();
			if(c=='X'){
				lexema[i]='\0';
				return EBX;
			}
			else ungetc(c,stdin);
		}
		else if(c=='C'){
			lexema[i++]=c;
			c=getchar();
			if(c=='X'){
				lexema[i]='\0';
				return ECX;
			}
			else ungetc(c,stdin);
		}
		else if(c=='D'){
			lexema[i++]=c;
			c=getchar();
			if(c=='X'){
				lexema[i]='\0';
				return EDX;
			}
			else ungetc(c,stdin);
		}
		else ungetc(c,stdin);
	}
//PALABRAS RESERVADAS DE FUNCIONES
	if(c=='M'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='O'){
			lexema[i++]=c;
			c=getchar();
			if(c=='V'){
				lexema[i]='\0';
				return INC;
			}
			else ungetc(c,stdin);
		}
		else ungetc(c,stdin);
	}
	if(c=='I'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='N'){
			lexema[i++]=c;
			c=getchar();
			if(c=='C'){
				lexema[i]='\0';
				return INC;
			}
			else ungetc(c,stdin);
		}
		else ungetc(c,stdin);
	}
	if(c=='D'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='E'){
			lexema[i++]=c;
			c=getchar();
			if(c=='C'){
				lexema[i]='\0';
				return DEC;
			}
			else ungetc(c,stdin);
		}
		else ungetc(c,stdin);
	}


	if(c=='M'){
		i=0;
		lexema[i++]=c;
		c=getchar();
		if(c=='U'){
			lexema[i++]=c;
			c=getchar();
			if(c=='L'){
				lexema[i]='\0';
				return MUC;
			}
			else ungetc(c,stdin);
		}
		else ungetc(c,stdin);
	}


	if(isdigit(c)){
		i=0;
		do{
			lexema[i++]=c;
			c=getchar();
		}while(isalnum(c));
		ungetc(c,stdin);
		lexema[i++]='\0';
//NUMERODECIMAL
		if(lexema[--i]=='d'||lexema[--i]=='D'||isdigit(lexema[--i])){
            for(int j=0;j<i;j++){
                if(!isdigit(lexema[j])) return;
                else return NUMERODECIMAL;
        }
//NUMEROHEXADECIMAL
		if(lexema[--i]=='h'||lexema[--i]=='H'){
            for(int j=0;j<(i-2);j++){
                if((isdigit(lexema[j])) || (lexema[j]>='a'&&lexema[j]<='f') || (lexema[j]>='A' && lexema[j]<='F')) return NUMEROHEXADECIMAL;
                else return;
        }
//NUMEROOCTAL
		if(lexema[--i]=='q'||lexema[--i]=='Q' ||lexema[--i]=='o' ||lexema[--i]=='O'){
            for(int j=0;j<(i-2);j++){
                if(lexema[j]>='0' && lexema[j]<='8') return NUMEROOCTAL;
                else return;
        }
//NUMEROBINARIO
		if(lexema[--i]=='b'||lexema[--i]=='B'){
            for(int j=0;j<(i-2);j++){
                if(lexema[j]=='0' || lexema[j]=='1') return NUMEROBINARIO;
                else return;
        }
	}
//----------------------------------------
    if(isalpha(c)){
        if(c=='e'){
            
        }
		i=0;
		do{
			lexema[i++]=c;
			c=getchar();
		}while(isalnum(c));
		ungetc(c,stdin);
		lexema[i++]='\0';
		return ID;

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

