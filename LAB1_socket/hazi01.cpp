/*
Stefán Erik Ede
2022.03.01
INFO2_1.labor
*/


#define _CRT_SECURE_NO_WARNINGS
#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <winsock2.h>


int main(int argc, char *argv[]) {
 
//Ellenõrzés
if (argc < 5) {
	printf("Használat: %s IP port oldal fájl\n", argv[0]);
	return 1;
}

//Winsock inicializálása
WSADATA wsd;
if (WSAStartup(0x0202, &wsd) != 0) {
	printf("WSAStartup: %d", WSAGetLastError());
	return 1;
}



//Socket inicializálása
SOCKET sock;
if ((sock = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
	printf("socket: %d\n\r", WSAGetLastError());
	return 1;
}

//Szerver cimének beállítása
struct sockaddr_in addr;
addr.sin_family = AF_INET;
addr.sin_addr.s_addr = inet_addr(argv[1]);
addr.sin_port = htons(atoi(argv[2]));

//Csatlakozás a szerverhez
if(connect(sock, (struct sockaddr*) &addr, sizeof(addr)) < 0) {
	printf("connect: %d\r\n", WSAGetLastError());
	return 1;
}

//Lekérdezzük a fejlécet
char request[256];
int reqlen;
reqlen = sprintf(request, "GET %s HTTP/1.0\r\n\r\n", argv[3]);

send(sock, request, reqlen, 0);

//Várjuk a szerver válaszát
char received[2048];
int recvlen;

recvlen = recv(sock, received, sizeof(received), 0);
if (recvlen < 0) {
	printf("Receive: %d\r\n", WSAGetLastError());
	return 1;
}
else {
	received[recvlen] = 0;
	printf("A kapott üzenet: \n%s\n", received);
}

char version[16];
int status;
char error[256];
if (sscanf(received, "HTTP/%16s %d %256[^^\r\n", version, &status, error) == 3) {
	printf("A szerver statusz jelzese: %d %s\n", status, error);
}

char* pdata = strstr(received, "\r\n\r\n");
if ((pdata == NULL)) {
	printf("Nincs üzenet\n");
	return 1;
}

//Kiírjuk egy fájlba a szerver válaszát
FILE* f;
f = fopen(argv[4], "w");
if (!f) {
	printf("Fopen error\n");
	return 1;
}
fwrite(pdata + 4, 1, recvlen - (pdata - received) - 4, f);

while ((recvlen = recv(sock, received, sizeof(received), 0)) > 0) {
	fwrite(received, 1, recvlen, f);
}

//Zárunk mindent
fclose(f);
int closesocket(sock);

WSACleanup();

return 0;

}

