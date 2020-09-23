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
%token ID NUMBER EAX EBX ECX EDX INC DEC MOV MUL NUMERODECIMAL NUMEROOCTAL NUMEROHEXADECIMAL NUMEROBINARIO
%%
final: incrementar {printf("FINAL\n");}
	| decrementar {printf("FINAL\n");}
	| asignar {printf("FINAL\n");}
    | prueba {printf("FINAL\n");imprimeTablaSimbolos();}
	;

prueba: NUMERODECIMAL {localizaSimbolo(lexema,NUMERODECIMAL);} NUMEROOCTAL {localizaSimbolo(lexema,NUMEROOCTAL);$$=$2;}
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
	int i, longitud=0;
    double suma=0;
	for(i=0;i<nSim;i++){
		if(!strcasecmp(tablaSimbolos[nSim].nombre,nom)){/*if(!strcasecmp(tablaSimbolos[nSim].nombre,nom);*/
				return i;
		}
	}
	strcpy(tablaSimbolos[nSim].nombre,nom);
	tablaSimbolos[nSim].token=token;
	//Asignacion de valor decimal
	if(token==NUMERODECIMAL){
        if(isdigit(lexema[strlen(lexema)-1])){
		    suma=atof(lexema);
        }
        else{
            longitud=strlen(lexema)-2;
            for(int j=0; j<=longitud; j++){
                suma=suma+((int)(lexema[j]-'0'))*pow(10,(longitud-j));
            }
        }
	}
//Asignacion de valor hexadecimal
    else if(token==NUMEROHEXADECIMAL){
		longitud=strlen(lexema)-2;
        for(int j=0; j<=longitud; j++){
            if(isdigit(lexema[j])){
                suma=suma+((int)(lexema[j]-'0'))*pow(16,(longitud-j));
            }
            if(lexema[j]>='a'&&lexema[j]<='f'){
                suma=suma+((int)(lexema[j])-87)*pow(16,(longitud-j));
            }
            if(lexema[j]>='A' && lexema[j]<='F'){
                suma=suma+((int)(lexema[j])-55)*pow(16,(longitud-j));
            }
        }
	}
//Asignacion de valor octal
    else if(token==NUMEROOCTAL){
		longitud=strlen(lexema)-2;
        for(int j=0; j<=longitud; j++){
            suma=suma+((int)(lexema[j]-'0'))*pow(8,(longitud-j));
        }
	}
//Asignacion de valor binario
    else if(token==NUMEROBINARIO){
		longitud=strlen(lexema)-2;
        for(int j=0; j<=longitud; j++){
            suma=suma+((int)(lexema[j]-'0'))*pow(2,(longitud-j));
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
	while((c=getchar())==' ');   /*permitirme ignorar blancos*/
	
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
        //NUMEROHEXADECIMAL
		if(lexema[i-2]=='h'|| lexema[i-2]=='H'){
            for(int j=0;j<(i-2);j++){
                if((isdigit(lexema[j])) || (lexema[j]>='a'&&lexema[j]<='f') || (lexema[j]>='A' && lexema[j]<='F')) return NUMEROHEXADECIMAL;
                else return 0;
            }
        }
//---------------------------------------------------
		return ID;
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
		if(lexema[i-2]=='d'|| lexema[i-2]=='D'|| isdigit(lexema[i-2])){
            for(int j=0;j<i-2;j++){
                if(!isdigit(lexema[j])) return 0;
                else return NUMERODECIMAL;
            }
        }
//NUMEROOCTAL
		if(lexema[i-2]=='q'|| lexema[i-2]=='Q' || lexema[i-2]=='o' || lexema[i-2]=='O'){
            for(int j=0;j<(i-2);j++){
                if(lexema[j]>='0' && lexema[j]<='8') return NUMEROOCTAL;
                else return 0;
            }
        }
//NUMEROBINARIO
		if(lexema[i-2]=='b'||lexema[i-2]=='B'){
            for(int j=0;j<(i-2);j++){
                if(lexema[j]=='0' || lexema[j]=='1') return NUMEROBINARIO;
                else return 0;
            }
	    }
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
