//adding header files
#include<stdio.h>
#include<string.h>
FILE *f;
char name[100], type, title[20], css[20], script[20], option[20];

void clean_stdin() 
{
    int c;
    while ((c = getchar()) != '\n' && c != EOF)
        ;
}

void radio()
{
int oc,j;
printf("Enter the Heading of field:");
scanf("%s",name);
clean_stdin();
fprintf(f,"<tr> \n<td>%s</td>\n",name);
printf("How many options:");
scanf("%d",&oc);
clean_stdin();
for(j=1; j<=oc; j++)
{
printf("Enter the %d option:",j);
scanf("%s",option);
clean_stdin();
fprintf(f,"<td><input type=radio name=%s value=%s>%s</td>\n",name,option,option);
}
fprintf(f,"</tr>\n");
}

void text()
{
char d[23];
printf("Enter the name of field:");
scanf("%s",name);
clean_stdin();
printf("Enter any default value:");
scanf("%s",d);
clean_stdin();
fprintf(f,"<tr> \n <td>%s</td> \n <td><input type=text name=%s value=%s></td></tr>\n",name,name,d);
}

void checkbox()
{
int oc,j;
printf("Enter the Heading of field:");
scanf("%s",name);
clean_stdin();
fprintf(f,"<tr> \n<td>%s</td>\n",name);
printf("How many options:");
scanf("%d",&oc);
clean_stdin();
for(j=1; j<=oc; j++)
{
printf("Enter the %d option:",j);
scanf("%s",option);
clean_stdin();
fprintf(f,"<td><input type=checkbox name=%s value=%s>%s</td>\n",name,option,option);
}
fprintf(f,"</tr>\n");
}

void password()
{
printf("Enter the name of field:");
scanf("%s",name);
clean_stdin();
fprintf(f,"<tr> \n <td>%s</td> \n <td><input type=password name=%s></td></tr>\n",name,name);
}

void main()
{
f=fopen("onform.html","w");

int i,n;

printf("Enter the title for your html file:");
scanf("%s", title);
printf("Enter the css file to be used:");
scanf("%s",css);
printf("Enter the name of script file to be executed:");
scanf("%s",script);
printf("How many fields you want in your table:");
scanf("%d",&n);
clean_stdin();

//fprintf for writing the things in html file

fprintf(f,"<html><head> \n <title>%s</title>",title);
fprintf(f,"<link rel=\"stylesheet\" type=\"text/css\" href=\"%s\"> \n </head><body>\n",css);
fprintf(f,"<header><h1>%s</h1></header>",title);
fprintf(f,"<table>");
fprintf(f, "<form action=\"%s\" method=\"GET\">",script);

for(i=0; i<n; i++)
{
printf("Enter the type of field:");
scanf("%c",&type);
if(type=='t')
{
  text();
}
else if(type=='r')
{
	radio();
}
else if(type=='c')
{
	checkbox();
}
else if(type=='p')
{	
	password();
}
}
fprintf(f,"</table>");
fprintf(f,"<center><input type=submit value=Submit></center>");
fprintf(f,"</form></body></html>");
}
