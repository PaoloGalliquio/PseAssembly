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
%token NUMBER ID CAMBIOLINEA
%%


Gramatica;


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
    tablaSimbolos[nSim].calor=suma;
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

