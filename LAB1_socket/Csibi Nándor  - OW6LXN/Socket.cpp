#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include <winsock2.h>

int main(int argc, char* argv[])
{
	// Ellenőrzés
	if (argc < 5)
	{
		printf("Használat: %s IP port oldal fájl\n", argv[0]);
		return 1;
	}

	// Winsock inicializálás
	WSADATA wsd;
	if (WSAStartup(0x0202, &wsd) != 0)
	{
		perror("WSAStartup");
		return 1;
	}

	// TCP socket létrehozása
	SOCKET sock;
	sock = socket(PF_INET, SOCK_STREAM, 0);

	if (sock < 0) {
		printf("socket: %d\r\n", WSAGetLastError());
		return 1;
	}

	// Cím összeállítása
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr(argv[1]);
	addr.sin_port = htons(atoi(argv[2]));

	// Kapcsolódás
	if (connect(sock, (struct sockaddr*)&addr, sizeof(addr)) < 0)
	{
		printf("connect: %d\r\n", WSAGetLastError());
		return 1;
	}

	// Kérés összeállítása
	char req[256];
	int reqlen;
	reqlen = snprintf(req, sizeof(req), "GET %s HTTP/1.0\r\n\r\n", argv[3]);
	send(sock, req, reqlen, 0);

	// Kérés fogadása
	char resp[1024];
	int resplen;
	resplen = recv(sock, resp, sizeof(resp) - 1, 0);

	if (resplen > 0) {
		resp[resplen] = 0;

		//printf("%s\r\n", resp);

		// Fejléc vizsgálata
		char version[16];
		int status;
		char error[256];
		if (sscanf(resp, "HTTP/%16s %d %256[^\r\n]\r\n", version, &status, error) == 3)
		{
			if (status == 200)
			{
				// OK
				char* pdata;
				while ((pdata = strstr(resp, "\r\n\r\n")) == NULL)
				{
					resplen = recv(sock, resp, sizeof(resp) - 1, 0);
					resp[resplen] = 0;
				}
				printf("%s\r\n", pdata + 4);

				// állományba mentés
				FILE* f;
				f = fopen(argv[4], "w");
				if (f == NULL)
				{
					perror("fopen");
					return 1;
				}

				// az adat elejének kiírása
				fwrite(pdata + 4, 1, resplen - (pdata - resp + 4), f);

				// olvasunk és írunk
				while ((resplen = recv(sock, resp, sizeof(resp), 0)) > 0)
				{
					fwrite(resp, 1, resplen, f);
				}

				// lezárjuk az állományt
				fclose(f);

				printf("Vege!\r\n");
			}


			else
			{
				// eroor
				printf("%s\r\n", error);
			}
		}
	}

	closesocket(sock);

	WSACleanup();

	return 0;
}
